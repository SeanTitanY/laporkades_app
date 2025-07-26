import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../report_model.dart'; // Sesuaikan path ke model Anda
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:laporkades_app/pages/laporan2_lokasi.dart';
import 'package:laporkades_app/pages/home.dart';
import 'package:laporkades_app/pages/laporan3_detail.dart';

const String cloudinaryCloudName = "dq6s6f6dw";
const String cloudinaryUploadPreset = "laporkades";

// Enum untuk merepresentasikan pilihan jenis laporan
enum ReportType { privat, publik }

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // State lokal untuk checkbox dan jenis laporan
  bool _isAgreed = false;
  ReportType _selectedReportType = ReportType.privat; // Defaultnya privat
  bool _isSubmitting = false; // State untuk loading saat submit

  /// Fungsi untuk menampilkan modal pilihan jenis laporan dari bawah
  void _showReportTypeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        // StatefulBuilder agar modal bisa mengelola state-nya sendiri saat memilih
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
                      const Text("Pilih Jenis Laporan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRadioOption(
                    setModalState: setModalState,
                    title: "Privat/Rahasia",
                    description: "Laporan ini hanya bisa diakses secara privat olehmu dan petugas yang menindaklanjuti laporanmu. Tenang aja, laporanmu tidak akan terlihat oleh pengguna lain.",
                    bulletPoints: const ["kamu ingin menjaga kerahasiaan dan privasi data dalam laporan yang kamu buat."],
                    value: ReportType.privat,
                  ),
                  const SizedBox(height: 16),
                  _buildRadioOption(
                    setModalState: setModalState,
                    title: "Publik",
                    description: "Laporan akan ditampilkan di aplikasi dan dapat dilihat oleh siapapun. Pengguna lain juga bisa mendukung dan mengomentari laporanmu.",
                    bulletPoints: const [
                      "laporan bersifat umum dan ingin dibagikan ke masyarakat luas.",
                      "laporan punya potensi untuk menginspirasi orang lain agar peduli hal yang sama.",
                    ],
                    value: ReportType.publik,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Widget helper untuk membuat setiap opsi radio di dalam modal
  Widget _buildRadioOption({
    required StateSetter setModalState,
    required String title,
    required String description,
    required List<String> bulletPoints,
    required ReportType value,
  }) {
    return InkWell(
      onTap: () {
        // Perbarui state utama dan state modal, lalu tutup
        setState(() => _selectedReportType = value);
        setModalState(() => _selectedReportType = value);
        Navigator.pop(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<ReportType>(
            value: value,
            groupValue: _selectedReportType,
            onChanged: (ReportType? newValue) {
              // --- PERBAIKAN DI SINI ---
              // Pastikan newValue tidak null sebelum digunakan
              if (newValue != null) {
                setState(() => _selectedReportType = newValue);
                setModalState(() => _selectedReportType = newValue);
                Navigator.pop(context);
              }
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),
                Text("Pilih ${title.split('/').first}, jika:", style: const TextStyle(fontWeight: FontWeight.w500)),
                ...bulletPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(color: Colors.black54)),
                      Expanded(child: Text(point, style: const TextStyle(color: Colors.black54))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk mendapatkan data dari ReportDataModel
    return Consumer<ReportDataModel>(
      builder: (context, reportData, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Tinjau Laporan", style: TextStyle(color: Colors.black, fontSize: 16)),
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 16.0),
                alignment: Alignment.center,
                child: const Text("Langkah 4/4", style: TextStyle(color: Colors.grey, fontSize: 12)),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                _buildReportTypeCard(),
                const SizedBox(height: 16),
                _buildImageSection(reportData.imagePath),
                _buildInfoCard(
                  title: "Lokasi Laporan",
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reportData.reportAddress ?? 'Alamat tidak diatur', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text("Detail Alamat Laporan", style: TextStyle(color: Colors.grey)),
                      Text(reportData.detailAddress?.isNotEmpty == true ? reportData.detailAddress! : '-', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  onChangePressed: () {
                    // 1. Dapatkan imagePath dari provider
                    final String? imagePath = reportData.imagePath;

                    // 2. Cek apakah imagePath tidak null
                    if (imagePath != null) {
                      // Jika ada, lanjutkan navigasi
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          // Hapus 'const' karena imagePath adalah variabel
                          builder: (context) => SetLocationScreen(imagePath: imagePath),
                        ),
                      );
                    } else {
                      // 3. Jika null, tampilkan pesan error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gambar tidak ditemukan untuk diedit.')),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                ),
                _buildInfoCard(
                  title: "Deskripsi",
                  content: Text(reportData.reportDescription ?? 'Deskripsi kosong', style: const TextStyle(fontSize: 16)),
                  onChangePressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          // Hapus 'const' karena imagePath adalah variabel
                          builder: (context) => ReportDetailScreen(),
                        ),
                      );
                  },
                ),
                _buildDeclarationCard(),
                _buildSubmitButton(reportData),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET BUILDER HELPERS ---

  Widget _buildImageSection(String? imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imagePath != null
          ? Image.file(File(imagePath), height: 200, width: double.infinity, fit: BoxFit.cover)
          : Container(height: 200, color: Colors.grey[300], child: const Center(child: Text("Tidak ada gambar"))),
    );
  }

  Widget _buildReportTypeCard() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Jenis Laporan", style: TextStyle(color: Colors.grey, fontSize: 14)),
                TextButton(onPressed: _showReportTypeModal, child: const Text("Ganti")),
              ],
            ),
            Text(
              _selectedReportType == ReportType.privat ? "Privat/Rahasia" : "Publik",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Widget content,
    required VoidCallback onChangePressed,
  }) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                TextButton(onPressed: onChangePressed, child: const Text("Ganti")),
              ],
            ),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildDeclarationCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PERNYATAAN", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            const Text("Laporan yang saya buat benar dan dapat dipertanggungjawabkan.", style: TextStyle(fontSize: 16)),
            CheckboxListTile(
              title: const Text("Ya, saya setuju"),
              value: _isAgreed,
              onChanged: (bool? value) => setState(() => _isAgreed = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport(ReportDataModel reportData) async {
    if (reportData.imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gambar tidak boleh kosong.")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 1. Unggah Gambar ke Cloudinary
      final cloudinary = CloudinaryPublic(cloudinaryCloudName, cloudinaryUploadPreset, cache: false);
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(reportData.imagePath!, resourceType: CloudinaryResourceType.Image),
      );
      String imageUrl = response.secureUrl;

      final String description = reportData.reportDescription ?? "";

      // 2. Simpan Semua Data ke Firestore
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) throw Exception("Pengguna tidak login.");

      await firestore.collection('laporan').add({
        'userId': user.uid,
        'imageUrl': imageUrl,
        'alamat': reportData.reportAddress,
        'detailAlamat': reportData.detailAddress,
        'deskripsi': description,
        'deskripsiLowerCase': description.toLowerCase(),
        'status': 'Menunggu',
        'tanggalDibuat': Timestamp.now(),
        'jenisLaporan': _selectedReportType.name,
      });
      
      // 3. Proses Berhasil
      reportData.clear();
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Laporan berhasil dikirim!")));
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

    } catch (e) {
      // 4. Proses Gagal
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mengirim laporan: $e")));
      }
    } finally {
      if(mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildSubmitButton(ReportDataModel reportData) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isAgreed && !_isSubmitting
              ? () => _submitReport(reportData) // Panggil fungsi submit di sini
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAgreed ? Colors.blueAccent : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isSubmitting
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
              : const Text('Kirim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}