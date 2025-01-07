# **SQL Project: World Layoffs Analysis**

## **Proyek Overview**
Proyek ini menggunakan dataset **World Layoffs** yang diambil dari [Tech layoffs dataset from COVID 2019 to present](https://www.kaggle.com/datasets/swaptr/layoffs-2022), dengan tujuan untuk membersihkan data dan melakukan **Exploratory Data Analysis (EDA)**. Dataset mencakup informasi tentang pemberhentian karyawan global, termasuk perusahaan, lokasi, industri, dan tahap pendanaan.

Proyek terdiri dari dua bagian:
1. **Data Cleaning**: Memastikan integritas, konsistensi, dan kebersihan data sebelum analisis.
2. **Exploratory Data Analysis (EDA)**: Menggali wawasan dari dataset yang sudah bersih, seperti tren PHK berdasarkan waktu, lokasi, dan industri.

---

## **Tujuan Proyek**
1. **Data Cleaning**:
   - Membersihkan data untuk menghapus duplikasi dan nilai kosong.
   - Menstandarkan nama perusahaan, lokasi, dan industri untuk analisis yang lebih akurat.
2. **Exploratory Data Analysis (EDA)**:
   - Mengidentifikasi tren PHK berdasarkan persentase, lokasi, industri, dan tahun.
   - Menganalisis pola PHK terbesar berdasarkan perusahaan dan tahap pendanaan.

---

## **Bagian 1: Data Cleaning**
### **Langkah-Langkah Utama**
1. **Penghapusan Duplikasi**:
   - Menggunakan **ROW_NUMBER()** untuk mengidentifikasi dan menghapus duplikasi berdasarkan kombinasi kolom penting seperti `company`, `location`, dan `industry`.
2. **Penanganan Nilai Kosong**:
   - Mengubah nilai kosong (`''` atau `0`) menjadi **NULL** untuk konsistensi dan kemudahan analisis.
   - Menghapus baris yang tidak relevan jika kedua kolom kunci (`total_laid_off` dan `percentage_laid_off`) bernilai **NULL**.
3. **Standarisasi Data**:
   - Membersihkan spasi tambahan pada nama perusahaan menggunakan fungsi **TRIM()**.
   - Menstandarkan nama perusahaan dan lokasi agar seragam (contoh: `Butterfly Network` menjadi nama konsisten).
4. **Penghapusan Kolom Tidak Diperlukan**:
   - Menghapus kolom `row_num` yang digunakan sementara selama proses pembersihan data.

---

## **Bagian 2: Exploratory Data Analysis (EDA)**
### **Analisis yang Dilakukan**
1. **Persentase PHK**:
   - Mengidentifikasi rentang persentase PHK (**min** dan **max**) untuk memahami tingkat keparahan PHK.
   - Menganalisis perusahaan dengan **100% PHK**, sebagian besar merupakan startup yang gagal bertahan.
2. **Total PHK**:
   - Mengidentifikasi perusahaan dengan PHK terbesar dalam satu waktu.
   - Menentukan perusahaan dengan PHK kumulatif terbesar.
3. **PHK Berdasarkan Lokasi dan Negara**:
   - Menganalisis jumlah PHK berdasarkan lokasi dan negara.
   - Menemukan wilayah dengan dampak PHK tertinggi.
4. **Tren Waktu**:
   - Menganalisis total PHK berdasarkan tahun untuk melihat pola historis.
   - Menghitung **Rolling Total** PHK per bulan menggunakan **Window Functions** untuk memetakan tren kumulatif.
5. **PHK Berdasarkan Industri**:
   - Mengidentifikasi industri dan tahap pendanaan (`stage`) yang paling terdampak.
6. **PHK Perusahaan Per Tahun**:
   - Menggunakan **DENSE_RANK()** untuk mengidentifikasi perusahaan dengan PHK terbesar per tahun.

---

## **Hasil Akhir**
- **Data Cleaning**:
  - Dataset bebas duplikasi dan nilai kosong telah ditangani.
  - Data siap digunakan untuk analisis mendalam atau visualisasi.
- **EDA**:
  - Mengungkap tren penting seperti:
    - Startup dengan 100% PHK.
    - Industri teknologi dan startup paling terdampak.
    - PHK memuncak pada periode tertentu yang berhubungan dengan kondisi ekonomi global.

---

## **Keterampilan dan Teknologi yang Digunakan**
- **SQL**:
  - Data Cleaning menggunakan fungsi seperti **ROW_NUMBER()**, **TRIM()**, dan **UPDATE**.
  - Analisis menggunakan **Aggregate Functions**, **Common Table Expressions (CTE)**, dan **Window Functions**.
- **Database Management**:
  - Pengelolaan tabel staging untuk menjaga integritas data mentah.

---
