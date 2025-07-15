import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CameraLocationScreen extends StatefulWidget {
  const CameraLocationScreen({super.key});

  @override
  State<CameraLocationScreen> createState() => _CameraLocationScreenState();
}

class _CameraLocationScreenState extends State<CameraLocationScreen> {
  CameraController? _cameraController;
  Position? _currentPosition;
  bool _isPermissionGranted = false;
  String _statusMessage = "Menginisialisasi kamera dan lokasi...";

  @override
  void initState() {
    super.initState();
    _initializeCameraAndLocation();
  }

  Future<void> _initializeCameraAndLocation() async {
    // 1. Meminta izin lokasi
    LocationPermission locationPermission = await Geolocator.requestPermission();

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      setState(() {
        _statusMessage = "Izin lokasi ditolak. Fitur tidak dapat berjalan.";
      });
      return;
    }
    
    // 2. Mendapatkan daftar kamera yang tersedia
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      setState(() {
        _statusMessage = "Tidak ada kamera yang ditemukan.";
      });
      return;
    }

    // 3. Inisialisasi CameraController
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    
    try {
      await _cameraController!.initialize();
      // Setelah kamera siap, baru dapatkan lokasi
      _currentPosition = await Geolocator.getCurrentPosition();
      
      setState(() {
        _isPermissionGranted = true; // Semua siap
      });

    } on CameraException catch (e) {
      setState(() {
        _statusMessage = "Gagal menginisialisasi kamera: ${e.description}";
      });
    }
  }

  @override
  void dispose() {
    // Pastikan untuk melepaskan controller saat widget tidak digunakan
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kamera & Geolokasi"),
      ),
      body: _isPermissionGranted
          ? Stack(
              fit: StackFit.expand,
              children: [
                // Widget untuk menampilkan preview kamera
                CameraPreview(_cameraController!),

                // Widget untuk menampilkan data lokasi
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _currentPosition != null
                          ? 'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}'
                          : 'Mencari lokasi...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )
          : Center(
              // Tampilkan pesan status jika belum siap atau izin ditolak
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_statusMessage, textAlign: TextAlign.center),
              ),
            ),
    );
  }
}