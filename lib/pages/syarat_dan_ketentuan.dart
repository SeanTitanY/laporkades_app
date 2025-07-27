import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  // Helper widget untuk membuat setiap bagian (judul + isi)
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
            height: 1.5, // Jarak antar baris
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Syarat & Ketentuan"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Syarat & Ketentuan LaporKades",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "Terakhir diperbarui: 27 Juli 2025",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              "Selamat datang di LaporKades! Dengan mendaftar dan/atau menggunakan aplikasi LaporKades, maka Anda dianggap telah membaca, mengerti, memahami, dan menyetujui semua isi dalam Syarat & Ketentuan ini.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 24),

            _buildSection(
              "1. Larangan",
              "Anda setuju untuk tidak menggunakan layanan LaporKades untuk tujuan yang melanggar hukum atau untuk melakukan hal-hal berikut:\n\n• Mengirimkan laporan palsu, menipu, atau menyesatkan.\n• Menggunakan bahasa yang mengandung hinaan, kata kasar, SARA, pornografi, atau provokasi.\n• Mengunggah materi apa pun yang mengandung virus atau kode komputer berbahaya lainnya."
            ),
            
            _buildSection(
              "2. Privasi",
              "Privasi Anda sangat penting bagi kami. Pengumpulan dan penggunaan data pribadi Anda diatur oleh Kebijakan Privasi kami, yang merupakan bagian tak terpisahkan dari Syarat & Ketentuan ini."
            ),

            _buildSection(
              "3. Konten Pengguna",
              "Anda bertanggung jawab penuh atas semua konten (foto, teks, lokasi) yang Anda kirimkan. Anda mempertahankan kepemilikan atas konten Anda, namun memberikan kami hak untuk menggunakan dan mendistribusikannya sehubungan dengan layanan LaporKades (misalnya, meneruskan laporan ke pihak desa). Kami berhak untuk meninjau atau menghapus konten yang melanggar ketentuan."
            ),
            
            _buildSection(
              "4. Penghentian Layanan",
              "Kami dapat, atas kebijakan kami sendiri, menangguhkan atau menghentikan akses Anda ke layanan kami dengan atau tanpa pemberitahuan jika terjadi pelanggaran terhadap Syarat & Ketentuan ini."
            ),

            _buildSection(
              "5. Batasan Tanggung Jawab",
              "Layanan LaporKades disediakan \"sebagaimana adanya\" tanpa jaminan apa pun. Kami tidak bertanggung jawab atas kerusakan atau kerugian yang timbul dari penggunaan layanan kami."
            ),

            _buildSection(
              "6. Perubahan Ketentuan",
              "Kami berhak untuk mengubah Syarat & Ketentuan ini dari waktu ke waktu. Dengan tetap mengakses layanan setelah perubahan, Anda dianggap menyetujui perubahan tersebut."
            ),

            _buildSection(
              "7. Kontak Informasi",
              "Jika Anda memiliki pertanyaan tentang Syarat & Ketentuan ini, silakan hubungi kami di @pemdes.desategalrejo"
            ),
          ],
        ),
      ),
    );
  }
}