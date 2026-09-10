create extension if not exists pgcrypto;

create table if not exists public.site_profile(id int primary key default 1,name text not null,status text,kua text,sk text,whatsapp text,nip text,photo_url text,updated_at timestamptz default now());
create table if not exists public.agenda(id uuid primary key default gen_random_uuid(),title text not null,description text,date text,file_url text,file_name text,created_at timestamptz default now());
create table if not exists public.materials(id uuid primary key default gen_random_uuid(),title text not null,description text,category text,date text,content text,file_url text,file_name text,created_at timestamptz default now());
create table if not exists public.reports(id uuid primary key default gen_random_uuid(),title text not null,description text,date text,file_url text,file_name text,created_at timestamptz default now());
create table if not exists public.gallery(id uuid primary key default gen_random_uuid(),title text not null,description text,image_url text,file_url text,file_name text,created_at timestamptz default now());

insert into public.site_profile(id,name,status,kua,sk,whatsapp) values (1,'Surianto, S.Ag','Penyuluh Agama Islam – PPPK','KUA Kec. Panca Lautang','2567/Kw.21.1/Kp.00.3/02/2025','082132244214') on conflict (id) do nothing;

insert into public.agenda(title,date,description) values
('Majelis Taklim & Pembinaan Keagamaan','2026-09-12','Pembinaan rutin jamaah dan penguatan literasi keislaman.'),
('Bimbingan Baca Al-Qur’an','2026-09-16','Pendampingan membaca Al-Qur’an untuk peserta binaan.'),
('Penyuluhan Keluarga Sakinah','2026-09-20','Komunikasi sehat, ketahanan keluarga, dan pembinaan pasangan.');

insert into public.materials(title,description,category,content) values
('Keluarga Sakinah: Memulai dari Komunikasi','Materi dakwah tentang membangun keluarga melalui komunikasi yang sehat dan penuh empati.','Keluarga Sakinah','Komunikasi adalah fondasi penting dalam membangun keluarga sakinah. Suami dan istri perlu membiasakan diri mendengar dengan empati, berbicara dengan santun, dan menyelesaikan masalah tanpa merendahkan satu sama lain.

Mulailah dari kebiasaan sederhana: menyediakan waktu berbicara, menyampaikan kebutuhan dengan jelas, meminta maaf ketika keliru, dan menyepakati cara menyelesaikan konflik.'),
('Mencegah Radikalisme di Lingkungan Keluarga','Panduan sederhana untuk membangun ketahanan keluarga terhadap paham kekerasan dan intoleransi.','Moderasi Beragama','Keluarga memiliki peran penting dalam menanamkan sikap saling menghormati. Ajarkan anak untuk memeriksa informasi, berdialog dengan santun, menghargai perbedaan, dan memahami agama secara utuh.

Kembangkan budaya tabayyun, literasi digital, serta keteladanan dalam kehidupan sehari-hari.'),
('Pencegahan Penyalahgunaan Narkoba','Materi penyuluhan untuk keluarga dan masyarakat tentang pencegahan penyalahgunaan narkoba.','Keluarga & Remaja','Pencegahan dimulai dari komunikasi yang terbuka dan lingkungan yang mendukung. Orang tua perlu mengenal pergaulan anak, membangun kepercayaan, dan memberi ruang bagi anak untuk bercerita.

Jika muncul tanda bahaya, segera cari bantuan profesional dan layanan resmi yang tersedia.');

insert into public.reports(title,date,description) values
('Laporan Kegiatan Pembinaan BKMT','2026-08-28','Dokumentasi kegiatan pembinaan dan materi penyuluhan.'),
('Laporan Bimbingan Baca Al-Qur’an','2026-08-21','Rekap pelaksanaan bimbingan membaca Al-Qur’an.');

insert into public.gallery(title,description,image_url) values
('Dokumentasi Penyuluh','Kegiatan dan pelayanan Penyuluh Agama Islam.','/profile.jpg'),
('Dokumentasi KUA Panca Lautang','Identitas Kementerian Agama dan KUA Kec. Panca Lautang.','/logo-kemenag.png');

drop policy if exists "public read site_profile" on public.site_profile;
create policy "public read site_profile" on public.site_profile for select using (true);
drop policy if exists "public read agenda" on public.agenda;
drop policy if exists "public read materials" on public.materials;
drop policy if exists "public read reports" on public.reports;
drop policy if exists "public read gallery" on public.gallery;
create policy "public read agenda" on public.agenda for select using (true);
create policy "public read materials" on public.materials for select using (true);
create policy "public read reports" on public.reports for select using (true);
create policy "public read gallery" on public.gallery for select using (true);

insert into storage.buckets(id,name,public) values ('penyuluh-files','penyuluh-files',true) on conflict (id) do update set public=true;
