import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporkades_app/pages/preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class ReportCameraScreen extends StatefulWidget {
  const ReportCameraScreen({super.key});
  @override
  State<ReportCameraScreen> createState() => _ReportCameraScreenState();
}

class _ReportCameraScreenState extends State<ReportCameraScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } on CameraException catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _flashMode = _flashMode == FlashMode.off ? FlashMode.auto :
                   _flashMode == FlashMode.auto ? FlashMode.torch : FlashMode.off;
    });
    _cameraController!.setFlashMode(_flashMode);
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.torch:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      default:
        return Icons.flash_off;
    }
  }

  /// FUNGSI BARU: Otomatis memotong bagian tengah gambar menjadi 1x1.
  Future<void> _autoCropAndShowPreview(String filePath) async {
    // 1. Baca dan decode gambar dari file path
    final imageBytes = await File(filePath).readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) return;

    // 2. Tentukan ukuran potongan persegi (ambil sisi terpendek)
    final cropSize = originalImage.width < originalImage.height
        ? originalImage.width
        : originalImage.height;
    
    // 3. Hitung titik awal (x, y) untuk cropping dari tengah
    final offsetX = (originalImage.width - cropSize) ~/ 2;
    final offsetY = (originalImage.height - cropSize) ~/ 2;

    // 4. Potong gambar di memori
    final croppedImage = img.copyCrop(
      originalImage,
      x: offsetX,
      y: offsetY,
      width: cropSize,
      height: cropSize,
    );

    // 5. Simpan gambar yang sudah dipotong ke file sementara
    final tempDir = await getTemporaryDirectory();
    final newFilePath = '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(newFilePath).writeAsBytes(img.encodeJpg(croppedImage));

    // 6. Navigasi ke halaman preview dengan gambar baru
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: newFilePath),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Ambil foto laporan",
          style: TextStyle(fontSize: 16, color: Colors.white)
          ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16.0),
            alignment: Alignment.center,
            child: const Text(
              "Langkah 1/5",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          )
        ],
        backgroundColor: Colors.black.withValues(alpha:0.8),
        elevation: 0,
        bottom: PreferredSize(
    // Atur tinggi tambahan yang Anda inginkan di sini
    preferredSize: const Size.fromHeight(90.0), 
    child: Container(), // Widget kosong untuk menciptakan ruang
  ),
      ),
      body: _isCameraInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_cameraController!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildControlBar(),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildControlBar() {
  return Container(
    color: Colors.black.withOpacity(0.8),
    // Padding vertical diubah agar tidak ada padding atas ganda
    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 54.0),
    child: Column(
      // Penting: agar Column tidak mengisi semua ruang vertikal
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- TAMBAHAN DI SINI ---
        // SizedBox untuk memberi ruang tambahan di atas tombol
        const SizedBox(height: 60), // Atur tinggi tambahan di sini

        // Row yang berisi semua tombol tetap sama
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_library_outlined, size: 32),
              color: Colors.white,
              onPressed: () async {
                final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  // Panggil fungsi auto-crop
                  await _autoCropAndShowPreview(image.path);
                }
              },
            ),
            GestureDetector(
              onTap: () async {
                if (!_cameraController!.value.isInitialized ||
                    _cameraController!.value.isTakingPicture) {
                  return;
                }
                try {
                  final picture = await _cameraController!.takePicture();
                  // Panggil fungsi auto-crop
                  await _autoCropAndShowPreview(picture.path);
                } on CameraException catch (e) {
                  debugPrint("Error taking picture: $e");
                }
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  border: Border.all(color: Colors.white, width: 4),
                ),
              ),
            ),
            IconButton(
              icon: Icon(_getFlashIcon(), size: 32),
              color: Colors.white,
              onPressed: _toggleFlash,
            ),
          ],
        ),
      ],
    ),
  );
}
}