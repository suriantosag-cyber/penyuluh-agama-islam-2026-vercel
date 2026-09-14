# Penyuluh Agama Islam — KUA Kec. Panca Lautang — 2026 (Secure)

## Arsitektur
- GitHub: source code
- Vercel: hosting/deployment
- Supabase Database: data konten
- Supabase Storage: PDF & foto
- Supabase Auth: login admin
- RLS: membatasi perubahan database/storage kepada user yang terautentikasi

## Setup satu kali
1. Jalankan `supabase/schema.sql` di Supabase SQL Editor.
2. Di Supabase Authentication > Users, buat satu user admin dengan email dan password yang Anda pilih.
3. Masukkan Supabase anon/public key ke `supabase-config.js`, atau kelola konfigurasi publik tersebut melalui sistem deployment Anda.
4. Push folder ini ke GitHub.
5. Import repository ke Vercel.

Tidak ada service-role key di browser. Jangan pernah menaruh `SUPABASE_SERVICE_ROLE_KEY` di frontend.

## Data awal
Profil Surianto, S.Ag., status Penyuluh Agama Islam – PPPK, KUA Kec. Panca Lautang, SK 2567/Kw.21.1/Kp.00.3/02/2025, WhatsApp 082132244214, dan 4 kelompok binaan/98 peserta.

## Catatan
File PDF materi dan foto galeri yang belum diberikan tidak dibuat-buat. Upload melalui Dashboard Admin setelah login. Website otomatis menyimpan file di Supabase Storage dan URL-nya dapat dipakai pada konten.
