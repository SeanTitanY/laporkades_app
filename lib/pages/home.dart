import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Ganti path import ini sesuai dengan struktur folder proyek Anda
import 'package:laporkades_app/pages/front.dart';
import 'package:laporkades_app/pages/history.dart';
import 'package:laporkades_app/pages/profile.dart';
import 'package:laporkades_app/pages/notifikasi.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  Color _notificationBgColor = Colors.transparent;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HalamanBeranda(),
    const HalamanRiwayat(),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HalamanNotifikasi()),
            );

            if (_notificationBgColor != Colors.transparent) return;

            setState(() {
              _notificationBgColor = const Color(0xffF7F8F8);
            });

            Timer(const Duration(milliseconds: 100), () {
              setState(() {
                _notificationBgColor = Colors.transparent;
              });
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 40,
            decoration: BoxDecoration(
              color: _notificationBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 30,
            ),
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
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: const Color(0xFF005465),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }
}