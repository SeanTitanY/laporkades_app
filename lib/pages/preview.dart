import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Menggunakan AppBar agar lebih rapi
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // Aksi ini sama dengan tombol "Ulangi"
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tinjau Foto',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        // Pastikan judul tidak di tengah (agar muncul setelah 'x')
        centerTitle: false,
        // Menghilangkan jarak default antara leading dan title
        titleSpacing: 0,
      ),
      // Mengubah layout utama menjadi Column
      body: Column(
        children: [
          // Expanded agar area gambar mengisi ruang yang tersedia
          Expanded(
            child: Center(
              // Widget untuk memastikan layout berbentuk persegi (1x1)
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.file(
                  File(imagePath),
                  // 'cover' akan membuat gambar mengisi penuh area persegi
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Kontrol di bagian bawah tetap sama
          _buildBottomControls(context),
        ],
      ),
    );
  }

  // Widget untuk membuat UI tombol di bagian bawah
  Widget _buildBottomControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        // mainAxisAlignment dihapus agar tidak ada spasi otomatis
        children: [
          // Tombol "Ulangi" dibungkus Expanded
          Expanded(
            child: TextButton(
              onPressed: () {
                // Kembali ke halaman kamera
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                // Sesuaikan style untuk tombol sekunder
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Ulangi'),
            ),
          ),
          // Beri sedikit jarak antar tombol
          const SizedBox(width: 12),
          // Tombol "Gunakan" dibungkus Expanded
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Logika saat foto diterima
                print("Foto digunakan: $imagePath");

                // Kembali ke halaman form sebelumnya sambil mengirim path gambar
                Navigator.of(context).pop(imagePath); // Ini akan menutup preview
                Navigator.of(context).pop(); // Ini akan menutup kamera
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // Padding horizontal tidak lagi diperlukan karena ada Expanded
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Gunakan'),
            ),
          ),
        ],
      ),
    );
  }
}