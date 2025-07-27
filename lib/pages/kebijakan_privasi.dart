import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: const Text("Kebijakan Privasi"),
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
                "Kebijakan Privasi LaporKades",
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
            
            _buildSection(
              "Pendahuluan",
              "Kebijakan Privasi ini adalah komitmen nyata dari LaporKades (\"kami\") untuk menghargai dan melindungi setiap data atau informasi pribadi Pengguna (\"Anda\") aplikasi LaporKades.\n\nDengan mengakses dan/atau mempergunakan layanan LaporKades, Anda menyatakan bahwa setiap data Anda merupakan data yang benar dan sah, serta Anda dianggap telah membaca, memahami, dan memberikan persetujuan kepada kami untuk memperoleh, mengumpulkan, menyimpan, mengelola, dan mempergunakan data tersebut sebagaimana tercantum dalam Kebijakan Privasi ini."
            ),
            
            _buildSection(
              "1. Perolehan dan Pengumpulan Data Pengguna",
              "LaporKades mengumpulkan data Pengguna dengan tujuan untuk mengelola dan memperlancar proses penggunaan aplikasi. Adapun data Pengguna yang dikumpulkan adalah sebagai berikut:\n\nA. Data yang diserahkan secara mandiri oleh Pengguna:\n• Saat membuat atau memperbarui akun, termasuk di antaranya nama pengguna (username), alamat email, dan password.\n• Saat membuat laporan, termasuk foto, lokasi, deskripsi, detail alamat, dan jenis laporan (Publik atau Privat).\n\nB. Data yang terekam saat Pengguna mempergunakan aplikasi:\n• Data lokasi riil: Kami mengumpulkan lokasi geografis Anda saat Anda membuat laporan untuk memastikan akurasi.\n• Data penggunaan: Kami mencatat aktivitas Anda di aplikasi, seperti waktu pendaftaran, login, dan pembuatan laporan.\n• Data perangkat: Seperti model perangkat keras, sistem operasi, dan versinya untuk membantu kami memecahkan masalah teknis."
            ),

            _buildSection(
              "2. Penggunaan Data",
              "LaporKades dapat menggunakan data yang diperoleh untuk hal-hal sebagai berikut:\n\n• Memproses segala bentuk laporan yang Anda kirimkan dan meneruskannya ke pihak yang berwenang (misalnya, pemerintah desa).\n• Memverifikasi identitas Anda dan mengelola akun Anda.\n• Menghubungi Anda terkait status laporan Anda atau untuk meminta informasi tambahan.\n• Menampilkan laporan Anda secara publik di aplikasi jika Anda memilih jenis laporan \"Publik\".\n• Melakukan analisis data untuk tujuan internal guna meningkatkan keamanan dan fitur aplikasi."
            ),

            _buildSection(
              "3. Pengungkapan Data Pribadi Pengguna",
              "LaporKades menjamin tidak ada penjualan atau pengalihan data pribadi Anda kepada pihak ketiga lain tanpa izin Anda, kecuali dalam hal-hal sebagai berikut:\n\n• Dibutuhkan adanya pengungkapan data laporan kepada pihak berwenang (pemerintah desa) yang relevan untuk menindaklanjuti laporan Anda.\n• Jika Anda memilih jenis laporan \"Publik\", maka data laporan Anda (selain data pribadi seperti email) dapat ditampilkan secara publik di dalam aplikasi.\n• Dibutuhkan untuk mematuhi kewajiban hukum atau adanya permintaan yang sah dari aparat penegak hukum."
            ),
            
            _buildSection(
              "4. Keamanan Data",
              "Kami berkomitmen untuk melindungi data Anda dan akan melakukan langkah-langkah keamanan yang wajar untuk mencegah akses, pengumpulan, penggunaan, pengungkapan, atau risiko serupa yang tidak sah."
            ),

            _buildSection(
              "5. Penyimpanan dan Penghapusan Data",
              "Kami akan menyimpan data Anda selama akun Anda aktif atau selama diperlukan untuk memenuhi tujuan layanan kami dan mematuhi peraturan yang berlaku. Anda dapat meminta penghapusan akun dan data terkait dengan menghubungi kami."
            ),

            _buildSection(
              "6. Pembaruan Kebijakan Privasi",
              "Kami dapat sewaktu-waktu melakukan perubahan atau pembaruan terhadap Kebijakan Privasi ini. Kami menyarankan agar Anda memeriksa halaman ini secara berkala untuk mengetahui perubahan apa pun."
            )
          ],
        ),
      ),
    );
  }
}