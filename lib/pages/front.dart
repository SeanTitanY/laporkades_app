import 'package:flutter/material.dart';
import 'package:laporkades_app/pages/laporan1_foto.dart';
import 'package:laporkades_app/pages/cari_laporan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laporkades_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  /// Fungsi untuk menampilkan dialog dari bawah
  void _showPreReportInfoSheet() {
    bool dontShowAgain = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          "Sudah siap untuk membuat laporanmu?",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("Baca ini dulu sebelum membuat laporan ya!", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  
                  _buildInfoItem(Icons.check_circle_outline, "Tindak Lanjut Laporan", "Hanya laporan terkait permasalahan di Desa Tegal Rejo saja yang akan ditindaklanjuti."),
                  _buildInfoItem(Icons.location_on_outlined, "Lokasi Laporan", "Lokasi laporan kamu diambil secara otomatis berdasarkan lokasi yang tersimpan saat pengambilan foto."),
                  _buildInfoItem(Icons.lock_outline, "Laporan Privat/Rahasia", "Jenis laporanmu akan otomatis terpilih privat/rahasia. Tetap pakai jenis ini jika kamu ingin laporanmu tidak terlihat oleh siapapun kecuali dirimu sendiri dan petugas."),
                  _buildInfoItem(Icons.people_outline, "Laporan Publik", "Ubah jenis laporan menjadi Publik pada laman Tinjau Laporan jika kamu ingin laporanmu terlihat oleh pengguna lainnya."),
                  
                  const SizedBox(height: 24),
                  
                  CheckboxListTile(
                    title: const Text("Saya mengerti. Jangan tampilkan halaman ini lagi.", style: TextStyle(fontSize: 14)),
                    value: dontShowAgain,
                    onChanged: (bool? value) {
                      setModalState(() {
                        dontShowAgain = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (dontShowAgain) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('hasSeenPreReportInfo', true);
                        }
                        if (mounted) {
                           Navigator.pop(context);
                           Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportCameraScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Buat Laporan"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Widget helper untuk membuat setiap baris info
  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 16, height: 1.4),
                children: [
                  TextSpan(text: '$title\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String namaPengguna = user?.displayName ?? 'Warga Tegal Rejo';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                height: 180,
                width: double.infinity,
                color: const Color(0xFF005465),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 45, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 22, color: Colors.white, fontFamily: 'Poppins'),
                          children: <TextSpan>[
                            const TextSpan(text: 'Hi, ', style: TextStyle(fontWeight: FontWeight.w400)),
                            TextSpan(text: namaPengguna, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Selamat datang di LaporKades.', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),
                    ],
                  ),
                ),
              ),
            ),
            
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Mengalami Masalah di Tegal Rejo?', style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0))),
                      const SizedBox(height: 4),
                      const Text('Buat Aduan Warga, Yuk!', style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // 1. Cek status login terlebih dahulu
                            final user = FirebaseAuth.instance.currentUser;

                            if (user == null) {
                              // 2. Jika belum login, arahkan ke halaman login
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                            } else {
                              // 3. Jika sudah login, lanjutkan logika yang ada
                              final prefs = await SharedPreferences.getInstance();
                              final bool hasSeenInfo = prefs.getBool('hasSeenPreReportInfo') ?? false;

                              if (!mounted) return;

                              if (hasSeenInfo) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const ReportCameraScreen()));
                              } else {
                                _showPreReportInfoSheet();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 14, 4, 190),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('BUAT ADUAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 208, 243, 245),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Eksplor Aduan Warga', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PublicReportsScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Lihat dan cari aduan warga', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        const SizedBox(height:20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}