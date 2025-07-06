import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _notificationBgColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontFamily: 'Bulgatti',
            fontSize: 18,
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
          margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
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
            child: SvgPicture.asset(
              'assets/icons/notification.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
      ],
    );
  }
}