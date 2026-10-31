import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String? initialName;
  final String? initialImagePath;

  const EditProfilePage({
    super.key,
    this.initialName,
    this.initialImagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color primaryGreen = Color(0xFF1A6556);

  late TextEditingController _nameController;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  bool _initializedFromArgs = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _imagePath = widget.initialImagePath;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedFromArgs) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args['name'] != null && _nameController.text.isEmpty) {
          _nameController.text = args['name'] as String;
        }
        if (args['imagePath'] != null && _imagePath == null) {
          _imagePath = args['imagePath'] as String?;
        }
      }
      _initializedFromArgs = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _openCameraValidation() async {
    Navigator.pop(context); // Tutup bottom sheet
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 88,
      );

      if (pickedFile != null && mounted) {
        // Arahkan ke halaman validasi dengan hasil foto kamera sebagai background
        final result = await Navigator.pushNamed(
          context,
          '/image-validation',
          arguments: {
            'imagePath': pickedFile.path,
            'source': 'camera',
          },
        );

        if (result != null && result is String && mounted) {
          setState(() {
            _imagePath = result;
          });
        }
      } else if (mounted) {
        // Jika batal sebelum capture atau ingin akses layar kamera langsung
        final result = await Navigator.pushNamed(
          context,
          '/image-validation',
        );

        if (result != null && result is String && mounted) {
          setState(() {
            _imagePath = result;
          });
        }
      }
    } catch (e) {
      debugPrint('Kamera error di edit profile: $e');
      if (mounted) {
        final result = await Navigator.pushNamed(
          context,
          '/image-validation',
          arguments: {
            'autoLaunchCamera': true,
          },
        );

        if (result != null && result is String && mounted) {
          setState(() {
            _imagePath = result;
          });
        }
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    Navigator.pop(context); // Tutup bottom sheet
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        // Arahkan ke halaman validasi perubahan gambar untuk konfirmasi
        final result = await Navigator.pushNamed(
          context,
          '/image-validation',
          arguments: {'imagePath': pickedFile.path},
        );

        if (result != null && result is String) {
          setState(() {
            _imagePath = result;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar dari galeri: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indikator garis abu-abu atas
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 28),

                // Pilihan Kamera dan Galeri
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Opsi Kamera
                    InkWell(
                      onTap: _openCameraValidation,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBEBEB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera,
                              size: 34,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Kamera',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 36),

                    // Opsi Galeri
                    InkWell(
                      onTap: _pickImageFromGallery,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 34,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Galeri',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() {
    final updatedName = _nameController.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil disimpan'),
        backgroundColor: primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context, {
      'name': updatedName.isNotEmpty ? updatedName : null,
      'imagePath': _imagePath,
    });
  }

  Widget _buildAvatarImage() {
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      if (_imagePath!.startsWith('assets/') || _imagePath!.startsWith('lib/')) {
        return Image.asset(
          _imagePath!,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        );
      } else if (kIsWeb) {
        return Image.network(
          _imagePath!,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        );
      } else {
        final file = File(_imagePath!);
        return Image.file(
          file,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        );
      }
    }
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      'lib/images/asep_kopling.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.person,
            size: 64,
            color: primaryGreen,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 65.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Avatar Tengah dengan Tombol Edit Pensil Lingkaran
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Lingkaran Foto Profil
                    GestureDetector(
                      onTap: _showImageSourceBottomSheet,
                      child: Container(
                        width: avatarRadius * 2,
                        height: avatarRadius * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: ClipOval(
                          child: _buildAvatarImage(),
                        ),
                      ),
                    ),

                    // Tombol Pensil Hijau di pojok kanan bawah
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceBottomSheet,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryGreen,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Input Nama Pengguna (single underline + user icon)
              TextField(
                controller: _nameController,
                cursorColor: primaryGreen,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 24,
                  ),
                  hintText: 'Nama Pengguna',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryGreen,
                      width: 1.8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 52),

              // Tombol SIMPAN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'SIMPAN',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
