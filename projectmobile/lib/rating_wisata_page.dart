import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RatingWisataPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RatingWisataPage({super.key, this.data});

  @override
  State<RatingWisataPage> createState() => _RatingWisataPageState();
}

class _RatingWisataPageState extends State<RatingWisataPage> {
  // Theme color matching design screenshot (#3B7A6C)
  static const Color primaryGreen = Color(0xFF3B7A6C);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);

  int _selectedRating = 5; // Default 5 stars
  bool _hideUsername = false;
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _attachedImagePaths = [];
  final ImagePicker _picker = ImagePicker();

  late final Map<String, dynamic> _item;
  String _userName = 'Kaisyarani';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _item = args;
      if (args['userName'] != null) {
        _userName = args['userName'];
      }
    } else if (widget.data != null) {
      _item = widget.data!;
      if (widget.data!['userName'] != null) {
        _userName = widget.data!['userName'];
      }
    } else {
      _item = {
        'id': 'dufan',
        'title': 'Dunia Fantasi\n(DUFAN)',
        'rawTitle': 'Dunia Fantasi (DUFAN)',
        'heroImage': 'lib/images/dufan_detail_hero.png',
      };
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_selectedRating) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Kurang';
      case 3:
        return 'Cukup';
      case 4:
        return 'Bagus';
      case 5:
        return 'Bagus';
      default:
        return 'Bagus';
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: primaryGreen),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        setState(() {
                          _attachedImagePaths.add(file.path);
                        });
                      }
                    } catch (_) {
                      // Fallback: Add mock sample image
                      setState(() {
                        _attachedImagePaths.add('lib/images/dufan.png');
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: primaryGreen),
                  title: const Text('Ambil Foto Kamera'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      final XFile? file = await _picker.pickImage(source: ImageSource.camera);
                      if (file != null) {
                        setState(() {
                          _attachedImagePaths.add(file.path);
                        });
                      }
                    } catch (_) {
                      // Fallback: Add mock sample image
                      setState(() {
                        _attachedImagePaths.add('lib/images/dufan.png');
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitReview() {
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tuliskan ulasan pengalamanmu terlebih dahulu!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: primaryGreen, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ulasan Terkirim!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Terima kasih ${_hideUsername ? "Pengguna" : _userName}! Ulasanmu tentang ${_item['rawTitle'] ?? "tempat wisata ini"} sangat membantu wisatawan lain.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: textMuted, height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context, {
                      'rating': _selectedRating,
                      'comment': comment,
                      'isAnonymous': _hideUsername,
                      'images': _attachedImagePaths,
                    }); // Return to detail page
                  },
                  child: const Text('Selesai'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String heroImagePath = _item['heroImage'] ?? 'lib/images/dufan_detail_hero.png';
    final String badgeTitle = _item['title'] ?? 'Dunia Fantasi\n(DUFAN)';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryGreen,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Beri Ulasan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          titleSpacing: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HERO BANNER WITH ROUNDED BOTTOM & DESTINATION BADGE
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                    child: Image.asset(
                      heroImagePath,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 180,
                        color: primaryGreen.withValues(alpha: 0.15),
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: primaryGreen),
                        ),
                      ),
                    ),
                  ),

                  // Destination Pill Badge on Bottom Right
                  Positioned(
                    right: 16,
                    bottom: -16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        badgeTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 2. GREETINGS & PROMPT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai, $_userName !',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'bagaimana perjalananmu?',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. INTERACTIVE 5 STARS RATING WITH STATUS LABEL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        final starNumber = index + 1;
                        final isFilled = starNumber <= _selectedRating;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRating = starNumber;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 32,
                              color: isFilled ? const Color(0xFFFFB800) : Colors.black87,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _ratingLabel,
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 4. REVIEW TEXT AREA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _reviewController,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 13, color: textDark),
                    decoration: const InputDecoration(
                      hintText: 'Ketik disini . . .',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                      contentPadding: EdgeInsets.all(14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. TAMBAHKAN GAMBAR SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambahkan Gambar?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Dashed-style Add Button
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black87,
                                width: 1.2,
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.add, size: 28, color: Colors.black87),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Default thumbnail sample (matching mockup)
                        if (_attachedImagePaths.isEmpty)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: const DecorationImage(
                                image: AssetImage('lib/images/dufan.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        // Dynamic attached photos
                        ..._attachedImagePaths.map((path) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                    image: (path.startsWith('lib/')
                                            ? AssetImage(path)
                                            : FileImage(File(path)))
                                        as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _attachedImagePaths.remove(path);
                                    });
                                  },
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 6. SEMBUNYIKAN NAMA PENGGUNA (ANONYMOUS CHECKBOX)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _hideUsername,
                        activeColor: primaryGreen,
                        side: const BorderSide(color: Colors.black87, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        onChanged: (val) {
                          setState(() {
                            _hideUsername = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _hideUsername = !_hideUsername;
                        });
                      },
                      child: const Text(
                        'Sembunyikan Nama Pengguna',
                        style: TextStyle(
                          fontSize: 12,
                          color: textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 7. TOMBOL "KIRIM"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _submitReview,
                    child: const Text(
                      'Kirim',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
