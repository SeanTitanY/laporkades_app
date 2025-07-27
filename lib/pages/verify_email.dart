// verify_email_screen.dart
import 'package:flutter/material.dart';
import 'package:laporkades_app/pages/login.dart'; // Sesuaikan path

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Email"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Satu Langkah Lagi!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kami telah mengirimkan link verifikasi ke alamat email Anda. Silakan periksa kotak masuk Anda untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Arahkan ke halaman login
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Kembali ke Halaman Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}