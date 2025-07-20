// report_model.dart
import 'package:flutter/material.dart';

class ReportDataModel extends ChangeNotifier {
  // Data untuk setiap langkah laporan
  String? imagePath;
  String? reportAddress;
  String? detailAddress;
  String? reportDescription;
  // Tambahkan variabel lain untuk langkah 4 & 5 di sini...

  // Fungsi untuk memperbarui data dan memberitahu pendengar (halaman)
  void updateImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }

  void updateLocation(String address, String detail) {
    reportAddress = address;
    detailAddress = detail;
    notifyListeners();
  }

  void updateDescription(String description) {
    reportDescription = description;
    notifyListeners();
  }
  
  // Fungsi untuk membersihkan semua data (misalnya setelah laporan berhasil dikirim)
  void clear() {
    imagePath = null;
    reportAddress = null;
    detailAddress = null;
    reportDescription = null;
    notifyListeners();
  }
}