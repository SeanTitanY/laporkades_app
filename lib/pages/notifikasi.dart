import 'package:flutter/material.dart';

class HalamanNotifikasi extends StatelessWidget {
  const HalamanNotifikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PERUBAHAN DI SINI ---
      appBar: AppBar(
        title: const Text('Notifikasi'), // Judul halaman
        centerTitle: true,              // Membuat judul di tengah
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      // --- BATAS PERUBAHAN ---
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada notifikasi baru', // Diubah agar lebih sesuai
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}