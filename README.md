# Website Penyuluh Agama Islam 2026

Website Next.js + Tailwind + Supabase Storage + Supabase Database, siap dideploy ke Vercel.

## Data profil
- Surianto, S.Ag
- Penyuluh Agama Islam – PPPK
- KUA Kec. Panca Lautang
- SK: 2567/Kw.21.1/Kp.00.3/02/2025
- WhatsApp: 082132244214
- 4 kelompok binaan: 30 + 20 + 15 + 33 = 98 peserta

## Fitur
- Profil premium responsif
- Agenda, materi dakwah, laporan, galeri
- Materi PDF bisa dibaca langsung dengan viewer browser
- Login admin
- Tambah/edit/hapus konten
- Upload PDF/DOC/DOCX/XLS/XLSX/PPT/PPTX/JPG/PNG/WEBP, maksimal 15 MB
- File masuk Supabase Storage; URL otomatis disimpan ke tabel konten
- Dashboard statistik
- Tombol WhatsApp

## Deploy Vercel (tanpa mengubah kode)
1. Buat project Supabase.
2. Buka Supabase > SQL Editor, jalankan `supabase/schema.sql` sekali.
3. Supabase > Project Settings > API: salin Project URL, anon key, service_role key.
4. Di Vercel > Project > Settings > Environment Variables isi:
   - NEXT_PUBLIC_SUPABASE_URL
   - NEXT_PUBLIC_SUPABASE_ANON_KEY
   - SUPABASE_SERVICE_ROLE_KEY
   - SUPABASE_STORAGE_BUCKET = penyuluh-files
   - ADMIN_PASSWORD = bismillah 2026!
   - ADMIN_SESSION_SECRET = buat kalimat acak panjang
5. Deploy / Redeploy.
6. Buka `/admin` untuk login.

### Keamanan
Jangan pernah memasukkan `SUPABASE_SERVICE_ROLE_KEY` ke kode frontend atau GitHub. Gunakan hanya Environment Variables Vercel.

### Ganti password admin
Ubah `ADMIN_PASSWORD` di Vercel lalu Redeploy.
