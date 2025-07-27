import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:laporkades_app/pages/laporan3_detail.dart';
import 'package:provider/provider.dart';
import 'package:laporkades_app/report_model.dart';

class SetLocationScreen extends StatefulWidget {
  final String imagePath;
  const SetLocationScreen({super.key, required this.imagePath});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  // --- State Management ---
  bool _isSameAsPhotoLocation = true;
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _manualAddressController = TextEditingController();
  String _currentAddress = "Mencari lokasi...";
  bool _isLoadingLocation = true;
  Widget? _cachedImageWidget;

  @override
  void initState() {
    super.initState();
    // 1. Dapatkan lokasi GPS real-time.
    _getCurrentLocationAndAddress();

    // 2. Buat widget gambar sekali saja untuk performa.
    _cachedImageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.file(
        File(widget.imagePath),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Text('Gagal memuat gambar.'),
          );
        },
      ),
    );
  }

  /// Fungsi untuk mendapatkan lokasi GPS saat ini dan mengubahnya menjadi alamat.
  Future<void> _getCurrentLocationAndAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _currentAddress = 'Layanan lokasi tidak aktif.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _currentAddress = 'Izin lokasi ditolak.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _currentAddress = 'Izin lokasi ditolak permanen.');
      return;
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        if (mounted) {
          setState(() {
            _currentAddress = "${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea} ${p.postalCode}, ${p.country}";
            _isLoadingLocation = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _currentAddress = 'Gagal mendapatkan lokasi.');
    }
  }

  @override
  void dispose() {
    _detailController.dispose();
    _manualAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Atur Lokasi Laporan", style: TextStyle(color: Colors.black, fontSize: 16)),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16.0),
            alignment: Alignment.center,
            child: const Text("Langkah 2/4", style: TextStyle(color: Colors.grey, fontSize: 12)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),
              _buildLocationInfoSection(),
              const SizedBox(height: 32),
              _buildReportLocationSection(),
              const SizedBox(height: 32),
              _buildAddressDetailSection(),
              _buildNextButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Bagian UI ---

  Widget _buildImageSection() {
    return Stack(
      children: [
        if (_cachedImageWidget != null) _cachedImageWidget!,
        Positioned(
          bottom: 12, right: 12,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text("Ganti Foto"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: .9),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Lokasi Foto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _isLoadingLocation
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(_currentAddress, style: const TextStyle(fontSize: 16, height: 1.4)),
        const SizedBox(height: 8),
        const Text("(Terdeteksi otomatis berdasarkan lokasi Anda saat ini)", style: TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildReportLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Lokasi Laporan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sama dengan lokasi foto"),
              Switch(
                value: _isSameAsPhotoLocation,
                onChanged: (value) {
                  setState(() {
                    _isSameAsPhotoLocation = value;
                    if (!value && !_isLoadingLocation) {
                      _manualAddressController.text = _currentAddress;
                    }
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_isSameAsPhotoLocation)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _isLoadingLocation
                    ? const Text("Memuat...", style: TextStyle(color: Colors.grey))
                    : Text(_currentAddress, style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.blueAccent, fontWeight: FontWeight.w500)),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () {
                  setState(() {
                    _isSameAsPhotoLocation = false;
                    if (!_isLoadingLocation) {
                      _manualAddressController.text = _currentAddress;
                    }
                  });
                },
              ),
            ],
          ),
        if (!_isSameAsPhotoLocation)
          TextField(
            controller: _manualAddressController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Masukkan Lokasi Manual',
              hintText: 'Ketik alamat atau nama tempat...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
      ],
    );
  }

  Widget _buildAddressDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Detail Alamat Laporan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        const Text("(Nama gedung, patokan, keadaan sekitar, dll.)", style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 12),
        TextField(
          controller: _detailController,
          keyboardType: TextInputType.multiline,
          minLines: 4,
          maxLines: null,
          maxLength: 100,
          decoration: const InputDecoration(
            hintText: "Contoh: Trotoar di depan Balai Kota, dekat pohon besar yang miring.",
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // 1. Dapatkan instance ReportDataModel dari Provider
            final reportData = Provider.of<ReportDataModel>(context, listen: false);

            // 2. Simpan path gambar ke dalam model
            reportData.updateImagePath(widget.imagePath);

            // 3. Tentukan alamat final dan detailnya
            final String finalAddress = _isSameAsPhotoLocation 
                ? _currentAddress 
                : _manualAddressController.text;
            final String detailAddress = _detailController.text;
            
            // 4. Simpan data lokasi ke dalam model
            reportData.updateLocation(finalAddress, detailAddress);
            
            // 5. Navigasi ke halaman detail laporan (Langkah 3)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportDetailScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Selanjutnya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}