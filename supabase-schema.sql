-- SUPABASE FINAL SCHEMA — Portal Penyuluh Agama Islam 2026
-- Jalankan seluruh file ini di Supabase > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default 'Surianto, S.Ag',
  status text not null default 'Penyuluh Agama Islam – PPPK',
  kua text not null default 'Kec. Panca Lautang',
  sk_number text not null default '2567/Kw.21.1/Kp.00.3/02/2025',
  nip text,
  whatsapp text not null default '082132244214',
  photo_url text,
  bio text,
  role text not null default 'admin' check (role in ('admin')),
  updated_at timestamptz not null default now()
);

create table if not exists public.groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  participants integer not null default 0 check (participants >= 0),
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.agenda (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  activity_date date not null,
  activity_time text,
  place text,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.materials (
  id uuid primary key default gen_random_uuid(),
  category text not null default 'UMUM',
  title text not null,
  excerpt text,
  body text,
  file_url text,
  file_name text,
  storage_path text,
  published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null default 'Laporan Kegiatan',
  activity_date date,
  place text,
  description text,
  file_url text,
  file_name text,
  storage_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.gallery (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  category text not null default 'penyuluh' check (category in ('penyuluh','kua')),
  image_url text,
  file_name text,
  storage_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.kegiatan_kua (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  activity_date date not null default current_date,
  place text,
  description text not null,
  image_url text,
  file_name text,
  storage_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

drop trigger if exists groups_updated_at on public.groups;
create trigger groups_updated_at before update on public.groups for each row execute function public.set_updated_at();
drop trigger if exists agenda_updated_at on public.agenda;
create trigger agenda_updated_at before update on public.agenda for each row execute function public.set_updated_at();
drop trigger if exists materials_updated_at on public.materials;
create trigger materials_updated_at before update on public.materials for each row execute function public.set_updated_at();
drop trigger if exists reports_updated_at on public.reports;
create trigger reports_updated_at before update on public.reports for each row execute function public.set_updated_at();
drop trigger if exists gallery_updated_at on public.gallery;
create trigger gallery_updated_at before update on public.gallery for each row execute function public.set_updated_at();
drop trigger if exists kegiatan_kua_updated_at on public.kegiatan_kua;
create trigger kegiatan_kua_updated_at before update on public.kegiatan_kua for each row execute function public.set_updated_at();

do $$ begin
  if not exists (select 1 from pg_policies where policyname='Public can read profiles' and tablename='profiles') then
    create policy "Public can read profiles" on public.profiles for select using (true);
  end if;
  if not exists (select 1 from pg_policies where policyname='Admins can manage profiles' and tablename='profiles') then
    create policy "Admins can manage profiles" on public.profiles for all using (auth.uid() = id) with check (auth.uid() = id);
  end if;
end $$;

alter table public.profiles enable row level security;
alter table public.groups enable row level security;
alter table public.agenda enable row level security;
alter table public.materials enable row level security;
alter table public.reports enable row level security;
alter table public.gallery enable row level security;
alter table public.kegiatan_kua enable row level security;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path=public
as $$ select exists (select 1 from public.profiles p where p.id = auth.uid() and p.role='admin') $$;

-- Public read policies (safe published/public content)
drop policy if exists "Public can read groups" on public.groups;
create policy "Public can read groups" on public.groups for select using (true);
drop policy if exists "Public can read agenda" on public.agenda;
create policy "Public can read agenda" on public.agenda for select using (true);
drop policy if exists "Public can read materials" on public.materials;
create policy "Public can read materials" on public.materials for select using (published = true or public.is_admin());
drop policy if exists "Public can read reports" on public.reports;
create policy "Public can read reports" on public.reports for select using (true);
drop policy if exists "Public can read gallery" on public.gallery;
create policy "Public can read gallery" on public.gallery for select using (true);
drop policy if exists "Public can read kegiatan_kua" on public.kegiatan_kua;
create policy "Public can read kegiatan_kua" on public.kegiatan_kua for select using (true);

-- Admin write policies
DO $$ DECLARE t text; BEGIN
  FOREACH t IN ARRAY ARRAY['groups','agenda','kegiatan_kua','materials','reports','gallery'] LOOP
    EXECUTE format('drop policy if exists "Admins manage %s" on public.%I', t, t);
    EXECUTE format('create policy "Admins manage %s" on public.%I for all using (public.is_admin()) with check (public.is_admin())', t, t);
  END LOOP;
END $$;

-- Storage buckets
insert into storage.buckets (id, name, public) values ('documents','documents',true) on conflict (id) do update set public=true;
insert into storage.buckets (id, name, public) values ('gallery','gallery',true) on conflict (id) do update set public=true;

-- Storage read/write policies. Drop first so this script can be safely re-run.
drop policy if exists "Public read documents" on storage.objects;
create policy "Public read documents" on storage.objects for select using (bucket_id='documents');
drop policy if exists "Admin insert documents" on storage.objects;
create policy "Admin insert documents" on storage.objects for insert with check (bucket_id='documents' and public.is_admin());
drop policy if exists "Admin update documents" on storage.objects;
create policy "Admin update documents" on storage.objects for update using (bucket_id='documents' and public.is_admin()) with check (bucket_id='documents' and public.is_admin());
drop policy if exists "Admin delete documents" on storage.objects;
create policy "Admin delete documents" on storage.objects for delete using (bucket_id='documents' and public.is_admin());

drop policy if exists "Public read gallery files" on storage.objects;
create policy "Public read gallery files" on storage.objects for select using (bucket_id='gallery');
drop policy if exists "Admin insert gallery files" on storage.objects;
create policy "Admin insert gallery files" on storage.objects for insert with check (bucket_id='gallery' and public.is_admin());
drop policy if exists "Admin update gallery files" on storage.objects;
create policy "Admin update gallery files" on storage.objects for update using (bucket_id='gallery' and public.is_admin()) with check (bucket_id='gallery' and public.is_admin());
drop policy if exists "Admin delete gallery files" on storage.objects;
create policy "Admin delete gallery files" on storage.objects for delete using (bucket_id='gallery' and public.is_admin());

-- Initial public content
insert into public.groups(name,participants) values
('BKMT Nurul Hidayah Wette’e',30),('BKMT Nurul Falah Wette’e',20),('BKMT Baitul Ibadah',15),('TPA Diniyah DDI Bilokka',33)
on conflict do nothing;

insert into public.materials(category,title,excerpt,body,published) values
('AKHLAK','Menjaga Lisan di Era Digital','Adab berbicara, bermedia sosial, dan menjaga kehormatan sesama Muslim.','Lisan dan jari kita sama-sama dapat menjadi sarana kebaikan. Sebelum berbicara atau menulis di media sosial, periksa kebenaran informasi, hindari fitnah, dan pilih kata yang menjaga kehormatan orang lain. Jadikan teknologi sebagai sarana silaturahmi dan dakwah yang santun.',true),
('KELUARGA','Keluarga Sakinah','Membangun komunikasi, keteladanan, dan pembagian peran yang penuh kasih.','Keluarga sakinah dibangun melalui iman, komunikasi terbuka, saling menghormati, dan keteladanan. Luangkan waktu untuk bermusyawarah, mendengar anggota keluarga, dan menyelesaikan masalah tanpa merendahkan satu sama lain.',true),
('IBADAH','Keutamaan Shalat Berjamaah','Memahami keutamaan, persiapan, dan cara menumbuhkan kebiasaan berjamaah.','Shalat berjamaah menguatkan kedisiplinan, persaudaraan, dan kepedulian sosial. Mulailah dari menjaga waktu shalat, mempersiapkan diri sebelum azan, dan mengajak keluarga dengan cara yang lembut.',true),
('MUAMALAH','Jujur dalam Bermuamalah','Kejujuran sebagai fondasi kepercayaan dalam kehidupan sosial.','Kejujuran menjaga kepercayaan dalam perdagangan, pekerjaan, pelayanan, dan kehidupan bermasyarakat. Hindari menyembunyikan cacat barang, memanipulasi informasi, atau mengambil hak orang lain.',true)
on conflict do nothing;
