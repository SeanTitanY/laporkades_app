// main.dart
import 'package:flutter/material.dart';
import 'package:laporkades_app/pages/home.dart';
import 'package:provider/provider.dart';
import 'report_model.dart';

void main() {
  runApp(
    // Sediakan ReportDataModel ke seluruh aplikasi
    ChangeNotifierProvider(
      create: (context) => ReportDataModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapor Kades App',
      home: const HomePage(), // Mulai dari halaman pertama laporan
    );
  }
}