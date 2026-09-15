create extension if not exists pgcrypto;

create table if not exists public.content_items (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('agenda','kegiatan_kua','materi','laporan','galeri','arsip')),
  title text not null,
  excerpt text,
  content text,
  event_date date,
  participants integer default 0,
  file_path text,
  file_name text,
  file_type text,
  file_size bigint,
  image_url text,
  published boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.site_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);

insert into public.site_settings(key,value) values
('profile','{"name":"Surianto, S.Ag.","role":"Penyuluh Agama Islam – PPPK","KUA":"KUA Kec. Panca Lautang","SK":"2567/Kw.21.1/Kp.00.3/02/2025","whatsapp":"082132244214","groups":98}')
on conflict(key) do update set value=excluded.value;

alter table public.content_items enable row level security;
alter table public.site_settings enable row level security;

drop policy if exists "public read published content" on public.content_items;
create policy "public read published content" on public.content_items for select
using (published = true or auth.role() = 'authenticated');

drop policy if exists "authenticated manage content" on public.content_items;
create policy "authenticated manage content" on public.content_items for all
to authenticated using (true) with check (true);

drop policy if exists "public read profile" on public.site_settings;
create policy "public read profile" on public.site_settings for select using (key='profile');

drop policy if exists "authenticated manage settings" on public.site_settings;
create policy "authenticated manage settings" on public.site_settings for all
to authenticated using (true) with check (true);

insert into storage.buckets (id,name,public)
values ('documents','documents',true)
on conflict (id) do update set public=true;

alter table storage.objects enable row level security;

drop policy if exists "documents public read" on storage.objects;
create policy "documents public read" on storage.objects for select
using (bucket_id='documents');

drop policy if exists "authenticated upload documents" on storage.objects;
create policy "authenticated upload documents" on storage.objects for insert
to authenticated with check (bucket_id='documents');

drop policy if exists "authenticated update documents" on storage.objects;
create policy "authenticated update documents" on storage.objects for update
to authenticated using (bucket_id='documents') with check (bucket_id='documents');

drop policy if exists "authenticated delete documents" on storage.objects;
create policy "authenticated delete documents" on storage.objects for delete
to authenticated using (bucket_id='documents');
