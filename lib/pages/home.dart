import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          child: Image.asset(
            'assets/icons/appLogoNoBg.png',
            height: 70,
            width: 70,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/icons/notification.png',
              height: 30,
              width: 30,
            ),
          ),
        ),
      ],
    );
  }
}