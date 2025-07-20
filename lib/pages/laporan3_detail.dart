import 'package:flutter/material.dart';
import 'package:laporkades_app/pages/laporan4_tinjau.dart';
import 'package:provider/provider.dart';
import 'package:laporkades_app/report_model.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  int _characterCount = 0;
  final int _minCharacters = 50;
  final int _maxCharacters = 2000;

  final List<String> _suggestionChips = [
    'Ada pelanggaran...',
    'Segera tindak lanjuti masalah...',
    'Masalah ini terjadi saat...',
    'Butuh segera ditindaklanjuti karena...',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _characterCount = _controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addSuggestion(String text) {
    final currentText = _controller.text;
    final newText = currentText.isEmpty ? text : '$currentText $text';
    _controller.text = newText;
    // Pindahkan kursor ke akhir teks
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tombol "Selanjutnya" akan aktif jika karakter >= 50
    final bool isButtonEnabled = _characterCount >= _minCharacters;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Tulis Detail Laporan", style: TextStyle(color: Colors.black, fontSize: 16)),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16.0),
            alignment: Alignment.center,
            child: const Text("Langkah 3/4", style: TextStyle(color: Colors.grey, fontSize: 12)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInstructionBox(),
              const SizedBox(height: 24),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildSuggestionChips(),
              _buildNextButton(isButtonEnabled),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(
          left: BorderSide(color: Colors.blue.shade300, width: 4),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ceritakan dengan detail, jelas dan padat.",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            "Kamu bisa tulis deskripsi masalah, waktu kejadian, dan detail lain yang diperlukan.",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

Widget _buildDescriptionField() {
  return TextField(
    controller: _controller,
    minLines: 8,
    maxLines: null,
    maxLength: _maxCharacters, // maxLength tetap ada untuk membatasi input
    keyboardType: TextInputType.multiline,
    // Gunakan buildCounter untuk custom counter
    buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
      // Kita gunakan Row untuk memisahkan teks ke kiri dan kanan
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Teks "Minimal 50 Karakter" di kiri
          Text(
            'Minimal $_minCharacters Karakter',
            style: TextStyle(
              color: currentLength < _minCharacters ? Colors.red : Colors.green,
              fontSize: 11,
            ),
          ),
          // Teks "0/2000" di kanan
          Text(
            '$currentLength/$maxLength',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      );
    },
    decoration: InputDecoration(
      hintText: "Tulis deskripsi laporanmu di sini...",
      alignLabelWithHint: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      // Properti 'counter' dihapus dari sini karena sudah digantikan oleh buildCounter
    ),
  );
}

  Widget _buildSuggestionChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kata-kata yang bisa kamu gunakan:",
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0, // Jarak horizontal antar chip
          runSpacing: 8.0, // Jarak vertikal antar baris chip
          children: _suggestionChips.map((text) {
            return ActionChip(
              label: Text(text),
              onPressed: () => _addSuggestion(text),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNextButton(bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () {
                  // 1. Akses ReportDataModel dari Provider
                  final reportData = Provider.of<ReportDataModel>(context, listen: false);

                  // 2. Simpan teks deskripsi dari controller ke dalam model
                  reportData.updateDescription(_controller.text);

                  // 3. Navigasi ke halaman ringkasan (summary)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Ganti SummaryScreen() dengan halaman tinjau Anda jika namanya berbeda
                      builder: (context) => const SummaryScreen(), 
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.blueAccent : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Selanjutnya',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}