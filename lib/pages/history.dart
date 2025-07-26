import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReportHistory {
  final String imageUrl;
  final String title;
  final String status;
  final DateTime date;
  final Color statusColor;

  ReportHistory({
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.date,
    required this.statusColor,
  });

  factory ReportHistory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'selesai':
          return Colors.green;
        case 'diproses':
          return Colors.orange;
        case 'ditolak':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return ReportHistory(
      imageUrl: data['imageUrl'] ?? '',
      title: data['deskripsi'] ?? 'Tidak ada deskripsi',
      status: data['status'] ?? 'Menunggu',
      date: (data['tanggalDibuat'] as Timestamp).toDate(),
      statusColor: getStatusColor(data['status'] ?? 'Menunggu'),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<ReportHistory> _reports = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  final int _limit = 10;

  Future<void> _handleRefresh() async {
    // Reset semua state paginasi
    _reports.clear();
    _lastDocument = null;
    _hasMore = true;
    _isLoading = true; // Tampilkan loading indicator utama lagi

    // Panggil fetch untuk mengambil data halaman pertama
    await _fetchReports();
  }

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('id', timeago.IdMessages());
    _fetchReports();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _fetchReports();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchReports() async {
    print("Memulai fetch reports...");

    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("User tidak login.");
    setState(() {
      _hasMore = false;
      _isLoading = false;
    });
    return;
  }

  Query query = FirebaseFirestore.instance
      .collection('laporan')
      .where('userId', isEqualTo: user.uid)
      .orderBy('tanggalDibuat', descending: true);

  if (_lastDocument != null) {
    query = query.startAfterDocument(_lastDocument!);
  }

  QuerySnapshot querySnapshot;

  try {
    querySnapshot = await query.limit(_limit).get();
  } catch (queryError) {
    print("Query error: $queryError");
    setState(() {
      _isLoading = false;
      _isLoadingMore = false;
      _hasMore = false;
    });
    return;
  }

  print("Total documents fetched: ${querySnapshot.docs.length}");


      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        List<ReportHistory> newReports = querySnapshot.docs
            .map((doc) => ReportHistory.fromFirestore(doc))
            .toList();

        if (mounted) {
          setState(() {
            _reports.addAll(newReports);
            _hasMore = newReports.length == _limit;
          });
        }
      } else {
        if (mounted) setState(() => _hasMore = false);
      }
    } catch (e) {
      print("Error fetching reports: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("Riwayat Laporan",
            style: TextStyle(color: Colors.black, fontSize: 18)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 1. Jadikan RefreshIndicator sebagai widget terluar.
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              // 2. Jika daftar kosong, bungkus pesan dengan ListView agar bisa di-scroll.
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: const Center(
                          child: Text("Anda belum membuat laporan.")
                        ),
                      ),
                    );
                  },
                )
              // 3. Jika daftar tidak kosong, tampilkan ListView.builder seperti biasa.
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _reports.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _reports.length) {
                      return _isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox();
                    }
                    return _buildHistoryCard(_reports[index]);
                  },
                ),
    );
  }

  Widget _buildHistoryCard(ReportHistory report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              report.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Gagal memuat gambar')),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: report.statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        report.status,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      timeago.format(report.date, locale: 'id'),
                      style: const TextStyle(color: Colors.grey, fontSize: 12)
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  report.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}