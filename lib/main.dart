// main.dart
import 'package:flutter/material.dart';
import 'package:laporkades_app/pages/home.dart';
import 'package:provider/provider.dart';
import 'report_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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