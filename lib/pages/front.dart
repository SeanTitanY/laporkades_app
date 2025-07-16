import 'package:flutter/material.dart';
import 'package:laporkades_app/pages/laporan.dart';

// Pastikan Anda juga memiliki class MyCustomClipper di proyek Anda
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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    const String namaPengguna = "Warga Tegal Rejo";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment bisa tetap start karena Center akan menanganinya
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN 1: HEADER YANG MELENGKUNG
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
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Hi, ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: namaPengguna,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selamat datang di LaporKades.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // -- PERUBAHAN DI SINI: MENAMBAHKAN WIDGET CENTER --
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
                      // Teks Ajakan
                      const Text(
                        'Mengalami Masalah di Tegal Rejo?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Buat Aduan Warga, Yuk!',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Tombol Buat Laporan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigasi ke halaman kamera dan geolokasi
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReportCameraScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 14, 4, 190),
                            foregroundColor: Colors.white,
                        
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'BUAT ADUAN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Container biru sekarang langsung di dalam Column
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 208, 243, 245),
              child: Padding(
                // Padding ini hanya untuk teks di dalamnya
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Eksplor Aduan Warga',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    const SizedBox(height: 20),

                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Tombol Cari Laporan ditekan!');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 16, // Menambahkan sedikit padding horizontal
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4, // Menambahkan sedikit shadow
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft, // <-- 1. Bungkus Text dengan Align
                              child: Text(
                                'Lihat aduan warga lainnya',
                                // textAlign dihapus karena sudah diatur oleh Align
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height:20),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Tombol Cari Laporan ditekan!');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 16, // Menambahkan sedikit padding horizontal
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4, // Menambahkan sedikit shadow
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft, // <-- 1. Bungkus Text dengan Align
                              child: Text(
                                'Pantau laporan yang kamu buat',
                                // textAlign dihapus karena sudah diatur oleh Align
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height:20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Tombol Cari Laporan ditekan!');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 16, // Menambahkan sedikit padding horizontal
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4, // Menambahkan sedikit shadow
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft, // <-- 1. Bungkus Text dengan Align
                              child: Text(
                                'Cari Aduan',
                                // textAlign dihapus karena sudah diatur oleh Align
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
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
