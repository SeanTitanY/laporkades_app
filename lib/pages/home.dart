import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Ganti path import ini sesuai dengan struktur folder proyek Anda
import 'package:laporkades_app/pages/front.dart';
import 'package:laporkades_app/pages/history.dart';
import 'package:laporkades_app/pages/profile.dart';
import 'package:laporkades_app/pages/notifikasi.dart';
import 'package:laporkades_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HalamanBeranda(),
    const HistoryScreen(),
    const HalamanProfil(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontFamily: 'Bulgatti',
            fontSize: 15,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Lapor',
              style: TextStyle(
                color: Color(0xFF005465),
              ),
            ),
            TextSpan(
              text: 'Kades',
              style: TextStyle(
                color: Color(0xFF006A17),
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/appLogoNoBg.svg',
            height: 70,
            width: 70,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // 1. Dapatkan status login pengguna
            final user = FirebaseAuth.instance.currentUser;

            // 2. Cek apakah pengguna sudah login atau belum
            if (user == null) {
              // Jika BELUM login, arahkan ke halaman login
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              // Jika SUDAH login, arahkan ke halaman notifikasi
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanNotifikasi()),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 40,
            child: const Icon(Icons.notifications_none, size: 30),
          ),
        ),
      ],
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) {
      // 1. Dapatkan status login pengguna saat ini
      final user = FirebaseAuth.instance.currentUser;

      // 2. Cek apakah pengguna mencoba mengakses halaman yang butuh login
      if (index > 0 && user == null) {
        // Jika BELUM login dan klik Riwayat (index 1) atau Profil (index 2),
        // arahkan ke halaman login.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Jika SUDAH login atau jika pengguna klik Home (index 0),
        // ganti halaman seperti biasa.
        setState(() {
          _selectedIndex = index;
        });
      }
    },
    selectedItemColor: const Color(0xFF005465),
    unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }
}