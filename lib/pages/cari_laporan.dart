import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

// Model untuk data laporan publik
class PublicReport {
  final String imageUrl;
  final String description;
  final String location;
  final String status;
  final DateTime timestamp;
  final Color statusColor;

  PublicReport({
    required this.imageUrl,
    required this.description,
    required this.location,
    required this.status,
    required this.timestamp,
    required this.statusColor,
  });

  factory PublicReport.fromFirestore(DocumentSnapshot doc) {
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

    return PublicReport(
      imageUrl: data['imageUrl'] ?? '',
      description: data['deskripsi'] ?? '',
      location: data['alamat'] ?? 'Lokasi tidak diketahui',
      status: data['status'] ?? 'Menunggu',
      timestamp: (data['tanggalDibuat'] as Timestamp).toDate(),
      statusColor: getStatusColor(data['status'] ?? 'Menunggu'),
    );
  }
}


class PublicReportsScreen extends StatefulWidget {
  const PublicReportsScreen({super.key});

  @override
  State<PublicReportsScreen> createState() => _PublicReportsScreenState();
}

class _PublicReportsScreenState extends State<PublicReportsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  List<PublicReport> _reports = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  String _searchQuery = "";
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    // Setting locale untuk timeago
    timeago.setLocaleMessages('id', timeago.IdMessages());
    _fetchReports();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _fetchReports();
      }
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text != _searchQuery) {
      // Reset dan mulai pencarian baru
      setState(() {
        _reports = [];
        _lastDocument = null;
        _hasMore = true;
        _isLoading = true;
        _searchQuery = _searchController.text;
      });
      _fetchReports();
    }
  }

  Future<void> _fetchReports() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      Query query = FirebaseFirestore.instance
          .collection('laporan')
          .where('jenisLaporan', isEqualTo: 'publik')
          .orderBy('tanggalDibuat', descending: true);

      if (_searchQuery.isNotEmpty) {
        final searchTerm = _searchQuery.toLowerCase();
        query = query.where('deskripsiLowerCase', isGreaterThanOrEqualTo: searchTerm)
                    .where('deskripsiLowerCase', isLessThanOrEqualTo: '$searchTerm\uf8ff');
}

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.limit(_limit).get();
      
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        List<PublicReport> newReports = querySnapshot.docs.map((doc) => PublicReport.fromFirestore(doc)).toList();
        
        if (mounted) {
          setState(() {
            _reports.addAll(newReports);
            _hasMore = newReports.length == _limit;
          });
        }
      } else {
        if (mounted) setState(() => _hasMore = false);
      }
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
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text("Laporan Warga", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Ketik kata kunci laporan",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_reports.isEmpty) {
      return const Center(child: Text("Tidak ada laporan publik yang ditemukan."));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _reports.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _reports.length) {
          return _isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox();
        }
        return _buildReportCard(_reports[index]);
      },
    );
  }

  Widget _buildReportCard(PublicReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dan Status
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    report.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100, height: 100, color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: report.statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      report.status,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Detail Teks
            Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.description,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(report.location.split(',').first, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  timeago.format(report.timestamp, locale: 'id'),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}