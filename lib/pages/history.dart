import 'package:flutter/material.dart';

// Model sederhana untuk merepresentasikan satu entri riwayat laporan
class ReportHistory {
  final String imageUrl;
  final String title;
  final String status;
  final String date;
  final Color statusColor;

  ReportHistory({
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.date,
    required this.statusColor,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Data dummy untuk ditampilkan di daftar riwayat
  final List<ReportHistory> _historyList = [
    ReportHistory(
      imageUrl: 'assets/laporan1.jpg', // Ganti dengan path aset Anda
      title: 'Jalan Rusak dan Berlubang di Depan Balai Desa',
      status: 'Selesai',
      date: '20 Juli 2025',
      statusColor: Colors.green,
    ),
    ReportHistory(
      imageUrl: 'assets/laporan2.jpg', // Ganti dengan path aset Anda
      title: 'Lampu Jalan Padam di RT 04',
      status: 'Diproses',
      date: '18 Juli 2025',
      statusColor: Colors.orange,
    ),
    ReportHistory(
      imageUrl: 'assets/laporan3.jpg', // Ganti dengan path aset Anda
      title: 'Tumpukan Sampah Liar di Pinggir Sungai',
      status: 'Menunggu',
      date: '15 Juli 2025',
      statusColor: Colors.grey,
    ),
    ReportHistory(
      imageUrl: 'assets/laporan4.jpg', // Ganti dengan path aset Anda
      title: 'Saluran Air Tersumbat Menyebabkan Banjir',
      status: 'Ditolak',
      date: '12 Juli 2025',
      statusColor: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Riwayat Laporan",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _historyList.length,
        itemBuilder: (context, index) {
          // Membuat kartu untuk setiap item di daftar riwayat
          return _buildHistoryCard(_historyList[index]);
        },
      ),
    );
  }

  /// Widget untuk membuat satu kartu riwayat laporan
  Widget _buildHistoryCard(ReportHistory report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Gambar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              report.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              // Penanganan jika gambar tidak ditemukan
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Gambar tidak ditemukan')),
                );
              },
            ),
          ),
          // Bagian Detail Teks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris yang berisi status dan tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: report.statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        report.status,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Tanggal
                    Text(
                      report.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Judul Laporan
                Text(
                  report.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}