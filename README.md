# Portal Penyuluh Agama Islam 2026 — FINAL Supabase + Vercel

Website statis responsif untuk Surianto, S.Ag — Penyuluh Agama Islam PPPK, KUA Kec. Panca Lautang.

## Arsitektur
- **GitHub/Vercel:** source code dan hosting frontend.
- **Supabase Database:** profil, kelompok binaan, agenda, materi, laporan, galeri.
- **Supabase Storage:** bucket `documents` untuk PDF/DOC/DOCX/XLS/XLSX/PPT/PPTX dan bucket `gallery` untuk JPG/PNG/WEBP.
- **Supabase Auth:** login admin; password tidak disimpan di JavaScript.
- **RLS:** pengunjung hanya membaca data publik; akun yang tercatat sebagai `admin` dapat mengelola data.

## Setup Supabase — sekali saja
1. Buat/open project Supabase.
2. Buka **SQL Editor → New query**.
3. Salin seluruh isi `supabase-schema.sql`, lalu klik **Run**.
4. Buka **Authentication → Users → Add user → Create new user**.
5. Gunakan email `admin@penyuluh.local` dan password admin yang Anda tetapkan (termasuk password yang Anda minta sebelumnya). Jika Supabase meminta verifikasi email, matikan kebutuhan konfirmasi email untuk akun admin atau konfirmasi akun tersebut sesuai pengaturan proyek.
6. Setelah user dibuat, buka **Table Editor → profiles → Insert row** dan isi `id` dengan UUID user tadi, `full_name` = `Surianto, S.Ag`, `role` = `admin`. Kolom lain bisa dibiarkan/default lalu diperbarui dari Dashboard Admin.

## Hubungkan website ke project
Buka `supabase-config.js` dan ganti:
- `SUPABASE_URL` dengan Project URL Supabase.
- `SUPABASE_ANON_KEY` dengan Publishable/Anon key dari Project Settings → API.
- `ADMIN_EMAIL` dengan email admin yang dibuat.

Jangan memasukkan **service_role key** ke frontend. Publishable/anon key boleh ada di frontend karena keamanan utama dilakukan oleh RLS.

## Fitur final
- Login Supabase Auth.
- Dashboard statistik real-time dari database.
- CRUD kelompok, agenda, materi, laporan, galeri.
- Edit profil.
- Baca materi lengkap melalui modal.
- Cetak / Simpan laporan sebagai PDF melalui dialog print browser.
- Upload dokumen dan foto ke Supabase Storage.
- URL file tersimpan dan dapat digunakan lintas perangkat.
- Lightbox galeri.
- Responsive HP/desktop.

## Deployment Vercel
Setelah `supabase-config.js` diisi, upload project ke GitHub lalu **Import Project** di Vercel. Karena website ini static, tidak membutuhkan server Node.

## Catatan keamanan
Password admin **tidak** ditulis di `index.html`/`app.js`. Jangan commit service-role key. Jika password admin pernah dibagikan di tempat publik, ganti password melalui Supabase Auth.

## Fitur baru: Kegiatan KUA + Foto + Berita
Versi ini menambahkan:
- Menu publik Kegiatan KUA.
- Setiap kegiatan dapat memiliki foto, tanggal, lokasi, dan berita lengkap di bawah foto.
- Dashboard Admin memiliki data Kegiatan KUA dan penghitung jumlah kegiatan.
- Admin dapat Tambah/Edit/Hapus Kegiatan KUA.
- Upload foto melalui tab Upload dapat diarahkan ke Kegiatan KUA + Berita.
- Data kegiatan tersimpan di tabel `kegiatan_kua` Supabase; foto menggunakan bucket `gallery`.

### Supabase
Jalankan seluruh `supabase-schema.sql` di Supabase SQL Editor. Script menggunakan `create table if not exists` dan kebijakan yang dapat dijalankan ulang.

### Deploy Vercel
Setelah mengganti file proyek dengan versi ini, lakukan commit/push ke branch yang terhubung Vercel lalu Redeploy. Pastikan `supabase-config.js` tetap berisi URL dan anon key project Supabase Anda.
