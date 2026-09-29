# ⚡ TaskFlow - Mobile Task & Academic Schedule Manager (with Gamification)
> **Software Under Test (SUT) - Mata Kuliah Penjaminan Kualitas Perangkat Lunak (PKPL)**

---

### 👨‍💻 Informasi Pengembang
* **Nama:** Fajri Ahmad Siregar
* **NIM:** 202010370311465
* **Program Studi:** Teknik Informatika
* **Fakultas / Universitas:** Fakultas Teknik, Universitas Muhammadiyah Malang (UMM)
* **Desain UI (Figma):** [Figma UI TaskFlow](https://www.figma.com/make/QYTXHB3ZRi2pehAXT4YHP2/Mobile-Task-Manager-UI?t=mX7CbZVrhToP8y9H-1)

---

## 📖 Deskripsi Proyek
**TaskFlow** adalah aplikasi manajemen tugas akademik dan jadwal perkuliahan modern berbasis mobile (Flutter) yang dilengkapi dengan **sistem gamifikasi (XP, Leveling, Streak, dan Badges)**. Aplikasi ini dirancang untuk meningkatkan produktivitas mahasiswa dengan membuat proses penyelesaian tugas menjadi lebih menyenangkan, terpantau, dan anti-deadliner.

Aplikasi ini dijadikan sebagai **Software Under Test (SUT)** dalam rangka pengujian perangkat lunak pada mata kuliah Penjaminan Kualitas Perangkat Lunak (PKPL).

---

## ✨ Fitur Utama & Metode Gamifikasi

### 🎮 1. Fitur Gamifikasi (Gamification Mechanics)
* **Sistem XP (Experience Points):** Pengguna mendapatkan XP setiap kali menyelesaikan tugas berdasarkan tingkat prioritas:
  * Prioritas **Tinggi:** +100 XP
  * Prioritas **Sedang:** +50 XP
  * Prioritas **Rendah:** +25 XP
  * **Early Bird Bonus:** +25 XP tambahan jika diselesaikan sebelum tenggat waktu!
* **Level & Gelar (Level Progression):**
  * Level 1: *Novice Scholar*
  * Level 2: *Task Apprentice*
  * Level 3: *Productivity Adept*
  * Level 4: *Task Master*
  * Level 5: *Grandmaster Achiever*
* **Daily Streaks (Api Semangat Belajar 🔥):** Melacak konsistensi penyelesaian tugas setiap hari.
* **Medali & Pencapaian (Achievements / Badges):**
  * 🎯 *Langkah Pertama:* Selesaikan tugas pertamamu (+50 XP)
  * 🔥 *Pemburu Prioritas:* Selesaikan tugas prioritas tinggi (+75 XP)
  * 🛡️ *Anti Deadline:* Selesaikan tugas tepat waktu (+100 XP)
  * ⚡ *Semangat Menyala:* Pertahankan 3 hari streak beruntun (+150 XP)
  * 📚 *Arsitek Jadwal:* Catat jadwal perkuliahan (+100 XP)
  * 👑 *Produktif Maksimal:* Selesaikan 5 tugas (+200 XP)
* **Misi Harian (Daily Quests):** Target tugas harian dengan hadiah XP tambahan.
* **Modal Dialog Selebrasi:** Notifikasi selebrasi instan saat tugas selesai dan ketika pengguna berhasil naik level (*Level Up!*).

### 📋 2. Manajemen Tugas & Dashboard Pro
* **Statistik Realtime:** Total tugas, tugas selesai, dan tugas pending.
* **Pencarian & Filter Kategori:** Filter instan (Semua, Umum, Kuliah, Kerja, Pribadi) dan kotak pencarian judul tugas.
* **Deadline Picker & Indikator Waktu:** Peringatan visual berbasis warna untuk tugas mendekati batas waktu (*Due Soon*) dan terlambat (*Overdue*).
* **Konfirmasi Hapus:** Menghindari kehilangan data akibat ketidaksengajaan.

### 📅 3. Jadwal Perkuliahan Mingguan
* Pengelompokan mata kuliah terurut per hari (Senin s/d Minggu).
* Pengaturan jam mulai dan jam selesai kuliah yang rapi.

### 🔔 4. Automasi Pengingat (Reminder Engine)
* Background timer periodik (30 detik) yang mengevaluasi sisa waktu deadline.
* Badge counter merah pada lonceng notifikasi dan panel pop-up ringkasan tugas mendesak.

---

## 🛠️ Teknologi yang Digunakan
* **Framework:** Flutter SDK (Dart)
* **State Management:** GetX & Reactive Stateful Widgets
* **Desain UI:** Modern Dark Theme Material Design 3 & Glassmorphic Accent
* **Icons:** Cupertino Icons & Material Symbols

---

## 🚀 Cara Menjalankan Proyek
1. Pastikan Flutter SDK sudah terpasang di perangkat Anda.
2. Clone repositori ini:
   ```bash
   git clone https://github.com/ryuucrowne2025-jpg/taskflow.git
   ```
3. Masuk ke direktori proyek:
   ```bash
   cd taskflow
   ```
4. Unduh dependensi:
   ```bash
   flutter pub get
   ```
5. Jalankan aplikasi:
   ```bash
   flutter run
   ```

---

## 📄 Dokumen Kebutuhan SUT (PKPL)
Dokumen spesifikasi kebutuhan lengkap (SRS, User Story Gherkin, Use Case UML, NFR, dan RTM) tersedia pada berkas:
* [`DOKUMEN_REQUIREMENT_SUT_PKPL.md`](./DOKUMEN_REQUIREMENT_SUT_PKPL.md)
* [`DOKUMEN_REQUIREMENT_SUT_PKPL.docx`](./DOKUMEN_REQUIREMENT_SUT_PKPL.docx)
