import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TentangScreen extends StatefulWidget {
  const TentangScreen({super.key});

  @override
  State<TentangScreen> createState() => _TentangScreenState();
}

class _TentangScreenState extends State<TentangScreen> {
  String _appVersion = '...';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  // Fungsi untuk mengambil versi aplikasi secara dinamis
  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tentang Aplikasi LaporKades"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bagian Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ganti dengan logo aplikasi Anda
                  Image.asset(
                    'assets/icons/appLogoNoBg.png',
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  // Ganti dengan logo desa Anda jika ada, atau gunakan ikon
                  Image.asset(
                    'assets/icons/logo_tegalrejo.png',
                    height: 60,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Versi Aplikasi
              Text(
                'Versi $_appVersion',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              
              // Deskripsi Aplikasi
              const Text(
                'LaporKades merupakan Platform Aplikasi yang menyediakan layanan pengaduan oleh Masyarakat Tegal Rejo untuk Pemerintah Desa Tegal Rejo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}