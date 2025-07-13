import 'package:flutter/material.dart';

class HalamanRiwayat extends StatelessWidget {
  const HalamanRiwayat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Halaman Riwayat',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}