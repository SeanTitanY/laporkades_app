import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laporkades_app/pages/home.dart'; // Sesuaikan path ke halaman login Anda

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  /// Fungsi untuk melakukan log out
  Future<void> _signOut(BuildContext context) async {
    try {
      // 1. Sign out dari Google (jika sebelumnya login dengan Google)
      await GoogleSignIn().signOut();
      
      // 2. Sign out dari Firebase
      await FirebaseAuth.instance.signOut();
      
      // 3. Arahkan kembali ke halaman login dan hapus semua halaman sebelumnya
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("Error saat log out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Halaman Profil',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // Tombol Log Out ditambahkan di sini
            ElevatedButton(
              onPressed: () => _signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Beri warna merah untuk aksi keluar
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}