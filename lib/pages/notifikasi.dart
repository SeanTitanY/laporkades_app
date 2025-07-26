import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

// Model sederhana untuk data notifikasi
class NotificationItem {
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

class HalamanNotifikasi extends StatefulWidget {
  const HalamanNotifikasi({super.key});

  @override
  State<HalamanNotifikasi> createState() => _HalamanNotifikasiState();
}

class _HalamanNotifikasiState extends State<HalamanNotifikasi> {
  // Data dummy untuk ditampilkan
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Laporan Selesai',
      message: 'Laporan Anda mengenai "Jalan Rusak" telah ditindaklanjuti.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      title: 'Laporan Diproses',
      message: 'Laporan Anda mengenai "Lampu Jalan Padam" sedang dalam proses.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationItem(
      title: 'Selamat Datang!',
      message: 'Terima kasih telah bergabung dengan LaporKades.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Atur timeago untuk menggunakan Bahasa Indonesia
    timeago.setLocaleMessages('id', timeago.IdMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationTile(notification);
        },
      ),
    );
  }

  /// Widget untuk membuat satu baris notifikasi
  Widget _buildNotificationTile(NotificationItem notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: ListTile(
        // Tampilan berbeda untuk notifikasi yang belum dibaca
        tileColor: notification.isRead ? Colors.white : Colors.blue.shade50,
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.campaign, color: Colors.blue),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.message),
        trailing: Text(
          timeago.format(notification.timestamp, locale: 'id'),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: () {
          // Tandai sebagai sudah dibaca saat ditekan
          setState(() {
            notification.isRead = true;
          });
        },
      ),
    );
  }
}