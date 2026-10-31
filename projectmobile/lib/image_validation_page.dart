import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageValidationPage extends StatefulWidget {
  final String? previewImagePath;

  const ImageValidationPage({
    super.key,
    this.previewImagePath,
  });

  @override
  State<ImageValidationPage> createState() => _ImageValidationPageState();
}

class _ImageValidationPageState extends State<ImageValidationPage> {
  static const Color primaryGreen = Color(0xFF1A6556);

  late String _currentImagePath;
  bool _isFlipped = false;
  bool _isCapturing = false;
  bool _hasRealPhoto = false;
  CameraDevice _preferredCamera = CameraDevice.front;
  final ImagePicker _picker = ImagePicker();
  bool _autoLaunchTriggered = false;

  @override
  void initState() {
    super.initState();
    if (widget.previewImagePath != null && widget.previewImagePath!.isNotEmpty) {
      _currentImagePath = widget.previewImagePath!;
      _hasRealPhoto = true;
    } else {
      _currentImagePath = 'lib/images/camera_preview_sample.png';
      _hasRealPhoto = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['imagePath'] != null && (args['imagePath'] as String).isNotEmpty) {
        setState(() {
          _currentImagePath = args['imagePath'] as String;
          _hasRealPhoto = true;
        });
      }
      if (args['autoLaunchCamera'] == true && !_autoLaunchTriggered) {
        _autoLaunchTriggered = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _captureFromCamera();
        });
      }
    }
  }

  Future<void> _captureFromCamera({CameraDevice? device}) async {
    final cameraToUse = device ?? _preferredCamera;
    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: cameraToUse,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 88,
      );

      if (file != null && mounted) {
        setState(() {
          _currentImagePath = file.path;
          _hasRealPhoto = true;
          // Aktifkan mirror default bila menggunakan kamera depan
          _isFlipped = (cameraToUse == CameraDevice.front);
        });

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto kamera berhasil diambil!'),
            duration: Duration(milliseconds: 1200),
            behavior: SnackBarBehavior.floating,
            backgroundColor: primaryGreen,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error kamera di ImageValidationPage: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka kamera: $e'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    final nextDevice = _preferredCamera == CameraDevice.front
        ? CameraDevice.rear
        : CameraDevice.front;
    setState(() {
      _preferredCamera = nextDevice;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nextDevice == CameraDevice.front
              ? 'Beralih ke Kamera Depan...'
              : 'Beralih ke Kamera Belakang...',
        ),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryGreen,
      ),
    );

    await _captureFromCamera(device: nextDevice);
  }

  void _toggleMirror() {
    setState(() {
      _isFlipped = !_isFlipped;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFlipped ? 'Efek Cermin Aktif' : 'Efek Cermin Nonaktif'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryGreen,
      ),
    );
  }

  void _validateAndConfirmImage() {
    // Validasi dan simpan perubahan gambar, kembalikan path ke EditProfilePage
    Navigator.pop(context, _currentImagePath);
  }

  Widget _buildPreviewImage() {
    Widget imageWidget;
    if (_currentImagePath.startsWith('assets/') || _currentImagePath.startsWith('lib/')) {
      imageWidget = Image.asset(
        _currentImagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else if (kIsWeb) {
      imageWidget = Image.network(
        _currentImagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      final file = File(_currentImagePath);
      if (file.existsSync()) {
        imageWidget = Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else {
        imageWidget = _buildPlaceholder();
      }
    }

    if (_isFlipped) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.14159),
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt,
              size: 64,
              color: Colors.white54,
            ),
            SizedBox(height: 12),
            Text(
              'Ketuk tombol kamera untuk mengambil foto',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Gambar pratinjau penuh layar (Full-screen preview yang menyesuaikan hasil kamera)
            Positioned.fill(
              child: _buildPreviewImage(),
            ),

            // Subtle gradient overlay atas agar tombol tetap kontras dan terbaca
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 110,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Loading overlay saat kamera sedang memproses
            if (_isCapturing)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Membuka Kamera...',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bagian Atas: Tombol Back & Tombol Tukar Kamera Depan/Belakang
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Kembali
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Kembali',
                    ),

                    // Tombol Switch Kamera Depan / Belakang
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      onPressed: _switchCamera,
                      tooltip: 'Tukar Kamera Depan / Belakang',
                    ),
                  ],
                ),
              ),
            ),

            // Bagian Bawah: Bar Putih Melengkung dengan Kontrol Kamera & Konfirmasi
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: _hasRealPhoto
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Tombol Ambil Ulang Kamera
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _captureFromCamera(),
                                  icon: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: primaryGreen,
                                      size: 24,
                                    ),
                                  ),
                                  tooltip: 'Ambil Foto Lagi',
                                ),
                                const Text(
                                  'Foto Ulang',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            // Tombol Utama Konfirmasi Foto (Gunakan Foto Ini)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: _validateAndConfirmImage,
                                  child: Container(
                                    width: 66,
                                    height: 66,
                                    decoration: BoxDecoration(
                                      color: primaryGreen,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryGreen.withValues(alpha: 0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Gunakan Foto',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryGreen,
                                  ),
                                ),
                              ],
                            ),

                            // Tombol Cermin / Mirror
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: _toggleMirror,
                                  icon: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: _isFlipped ? const Color(0xFFE8F3EF) : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _isFlipped ? primaryGreen : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.flip,
                                      color: _isFlipped ? primaryGreen : Colors.black87,
                                      size: 24,
                                    ),
                                  ),
                                  tooltip: 'Cerminkan Foto',
                                ),
                                Text(
                                  'Cermin',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _isFlipped ? primaryGreen : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => _captureFromCamera(),
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: primaryGreen,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryGreen.withValues(alpha: 0.35),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Ketuk untuk Ambil Foto Kamera',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
