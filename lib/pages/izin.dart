import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laporkades_app/pages/home.dart'; // Sesuaikan path ke halaman utama Anda
import 'package:laporkades_app/pages/kebijakan_privasi.dart'; // Sesuaikan path

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  // Widget helper untuk membuat setiap item di daftar izin
  Widget _buildPermissionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•  ",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar belakang abu-abu seperti di contoh
      backgroundColor: Colors.grey[300], 
      appBar: AppBar(
        // AppBar dibuat transparan agar menyatu
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black54),
        title: const Text(
          "LaporKades",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Kartu putih di tengah
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Agar kartu menyesuaikan tinggi konten
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul utama dengan RichText agar bisa di-bold sebagian
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 24, color: Colors.black, height: 1.4),
                      children: const <TextSpan>[
                        TextSpan(text: 'Fitur ini '),
                        TextSpan(
                            text: 'mengakses, menyimpan, dan menggunakan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Daftar izin
                  _buildPermissionItem("kamera"),
                  _buildPermissionItem("lokasi"),
                  _buildPermissionItem("media penyimpanan"),
                  const SizedBox(height: 12),
                  const Text(
                    "untuk kebutuhan tindak lanjut laporan.",
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  
                  // Link Kebijakan Privasi dengan RichText
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      children: <TextSpan>[
                        const TextSpan(text: 'Baca '),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          // Menambahkan gestur klik
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: ' untuk lebih lengkap.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tombol "Saya Setuju"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ganti halaman saat ini dengan halaman utama
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Saya Setuju"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}