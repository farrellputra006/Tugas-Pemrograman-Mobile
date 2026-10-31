import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DestinationItem {
  final String id;
  final String title;
  final String location;
  final String distance;
  final String price;
  final double rating;
  final String imagePath;
  final String category;
  final String description;
  final List<String> facilities;

  const DestinationItem({
    required this.id,
    required this.title,
    required this.location,
    required this.distance,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.category,
    required this.description,
    required this.facilities,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // Theme colors matching Ecowalk brand and reference mockups
  static const Color primaryGreen = Color(0xFF265D52);
  static const Color darkGreen = Color(0xFF1E604E);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF64748B);

  int _selectedNavIndex = 0; // Tab 0: BERANDA (Home)
  String _selectedCategory = 'Semua';
  String _userName = 'ASEP KOPLING';
  String? _profileImagePath;

  late final AnimationController _botAnimController;
  late final Animation<double> _botFloatAnimation;

  final List<String> _categories = const [
    'Semua',
    'Kuliner',
    'Sejarah',
    'Alam',
    'Religi',
    'Seni',
  ];

  late final List<DestinationItem> _destinations;

  @override
  void initState() {
    super.initState();

    _destinations = const [
      DestinationItem(
        id: 'dufan',
        title: 'Dunia Fantasi (DUFAN)',
        location: 'Ancol, Jakarta Utara',
        distance: '1.68 KM',
        price: 'Rp. 260.000',
        rating: 5.0,
        imagePath: 'lib/images/dufan.png',
        category: 'Alam',
        description:
            'Taman hiburan outdoor terbesar dengan beragam wahana atraktif dan menantang adrenalin seperti Halilintar, Tornado, Kora-kora, dan Bianglala.',
        facilities: ['Wahana Ekstrem', 'Restoran', 'Mushola', 'Toilet Bersih', 'Loker'],
      ),
      DestinationItem(
        id: 'tmii',
        title: 'Taman Mini Indonesia Indah (TMII)',
        location: 'Jakarta Timur',
        distance: '3.84 KM',
        price: 'Mulai dari Rp. 25.000',
        rating: 5.0,
        imagePath: 'lib/images/tmii.png',
        category: 'Sejarah',
        description:
            'Kawasan taman wisata bertema budaya Indonesia dengan anjungan daerah representatif seluruh provinsi, museum, kereta gantung, dan miniatur kepulauan nusantara.',
        facilities: ['Anjungan Daerah', 'Kereta Gantung', 'Museum', 'Taman Burung', 'Food Court'],
      ),
      DestinationItem(
        id: 'ragunan',
        title: 'Taman Margasatwa Ragunan',
        location: 'Pasar Minggu, Jakarta Selatan',
        distance: '6.20 KM',
        price: 'Mulai dari Rp. 4.000',
        rating: 4.8,
        imagePath: 'lib/images/dufan.png',
        category: 'Alam',
        description:
            'Kebun binatang legendaris dengan ribuan spesies satwa langka dan pepohonan rindang seluas 140 hektar yang sejuk untuk rekreasi keluarga.',
        facilities: ['Pusat Primata', 'Sewa Sepeda', 'Danau', 'Taman Anak', 'Parkir Luas'],
      ),
      DestinationItem(
        id: 'monas',
        title: 'Monumen Nasional (MONAS)',
        location: 'Gambir, Jakarta Pusat',
        distance: '4.15 KM',
        price: 'Mulai dari Rp. 15.000',
        rating: 4.9,
        imagePath: 'lib/images/tmii.png',
        category: 'Sejarah',
        description:
            'Ikon kebanggaan Indonesia dengan museum diorama perjuangan bangsa serta puncak tugu emas dengan pemandangan lanskap kota Jakarta 360 derajat.',
        facilities: ['Museum Sejarah', 'Lift Puncak', 'Taman Luas', 'Wisata Malam', 'Kereta Wisata'],
      ),
    ];

    _botAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _botFloatAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _botAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _botAnimController.dispose();
    super.dispose();
  }

  List<DestinationItem> get _filteredDestinations {
    if (_selectedCategory == 'Semua') {
      return _destinations;
    }
    return _destinations
        .where((item) => item.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  void _navigateToProfile() async {
    final result = await Navigator.pushNamed(
      context,
      '/profile',
      arguments: {
        'name': _userName,
        'imagePath': _profileImagePath,
      },
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (result['name'] != null && (result['name'] as String).isNotEmpty) {
          _userName = result['name'] as String;
        }
        if (result.containsKey('imagePath')) {
          _profileImagePath = result['imagePath'] as String?;
        }
      });
    }
  }

  void _navigateToNotifikasi() {
    Navigator.pushNamed(context, '/notifikasi');
  }

  void _showDestinationDetail(DestinationItem item) {
    Navigator.pushNamed(
      context,
      '/detail-wisata',
      arguments: {
        'id': item.id,
        'title': item.title,
        'rating': item.id == 'dufan' ? '4.75' : item.rating.toString(),
        'reviewsCount': item.id == 'dufan' ? '24.543 Ulasan' : '18.210 Ulasan',
        'openHours': '10:00 - 22:00',
        'isOpen': true,
        'address': item.id == 'dufan'
            ? 'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430'
            : '${item.title}, ${item.location}',
        'description': item.description,
        'priceRange': item.id == 'dufan'
            ? 'Rp. 190.000 - Rp. 400.000'
            : item.price,
        'distance': item.distance,
        'heroImage': item.id == 'dufan' ? 'lib/images/dufan_detail_hero.png' : item.imagePath,
        'mapImage': 'lib/images/map_dufan.png',
      },
    );
  }

  void _showCompareSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Perbandingan Destinasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Table(
                border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                children: const [
                  TableRow(
                    decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Kriteria', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('DUFAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('TMII', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Jarak', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('1.68 KM', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('3.84 KM', style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Tiket Masuk', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Rp. 260.000', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Mulai Rp. 25.000', style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Tema', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Wahana Bermain', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Edukasi & Budaya', style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(8.0), child: Text('Rating', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('⭐ 5.0', style: TextStyle(fontSize: 12))),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('⭐ 5.0', style: TextStyle(fontSize: 12))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textDark,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/komparasi');
                      },
                      child: const Text('Halaman Lengkap'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAiAssistantChat() {
    final TextEditingController promptController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 18,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/images/bot_mascot.png',
                    width: 42,
                    height: 52,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ecowalk AI Assistant',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textDark),
                      ),
                      Text(
                        'Panduan pintar liburan Anda',
                        style: TextStyle(fontSize: 12, color: textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Halo! Saya asisten pintar Ecowalk. Ada destinasi yang ingin Anda kunjungi hari ini? Tanyakan rekomendasi rute, tiket, atau waktu terbaik!',
                  style: TextStyle(fontSize: 13, color: textDark, height: 1.4),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Wisata Keluarga', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      promptController.text = 'Rekomendasi wisata keluarga terbaik di Jakarta';
                    },
                  ),
                  ActionChip(
                    label: const Text('Tiket Murah', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      promptController.text = 'Tempat wisata hemat di bawah 50 ribu';
                    },
                  ),
                  ActionChip(
                    label: const Text('Wahana Ramah Anak', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      promptController.text = 'Spot bermain edukatif ramah anak';
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: promptController,
                      decoration: InputDecoration(
                        hintText: 'Tulis pertanyaanmu...',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: primaryGreen,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () {
                        final text = promptController.text.trim();
                        if (text.isNotEmpty) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('AI Ecowalk memproses: "$text"'),
                              backgroundColor: primaryGreen,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. TOP HEADER (ECOWALK logo, Avatar, Notification Bell)
                    _buildHeader(),

                    const SizedBox(height: 16),

                    // 2. WEATHER WIDGET CARD
                    _buildWeatherCard(),

                    const SizedBox(height: 20),

                    // 3. REKOMENDASI SECTION
                    _buildSectionHeaderWithAction('Rekomendasi', 'Cari Rute', () {
                      Navigator.pushNamed(context, '/rekomendasi');
                    }),
                    const SizedBox(height: 12),
                    _buildRecommendationList(),

                    const SizedBox(height: 22),

                    // 4. KATEGORI SECTION
                    _buildSectionHeaderWithAction('Kategori', 'Lihat Semua', () {
                      Navigator.pushNamed(context, '/kategori', arguments: _selectedCategory);
                    }),
                    const SizedBox(height: 12),
                    _buildCategoryChips(),

                    const SizedBox(height: 22),

                    // 5. PILIHAN TERATAS SECTION
                    _buildSectionHeaderWithAction('Pilihan Teratas', 'Jelajahi', () {
                      Navigator.pushNamed(context, '/kategori');
                    }),
                    const SizedBox(height: 12),
                    _buildPilihanTeratasList(),

                    const SizedBox(height: 22),

                    // 6. PROMO / COMPARISON BANNER
                    _buildCompareBanner(),

                    const SizedBox(height: 22),

                    // 7. KUNJUNGI LAGI SECTION
                    _buildSectionHeaderWithAction('Kunjungi Lagi', 'Selengkapnya', () {
                      _showDestinationDetail(_destinations[1]);
                    }),
                    const SizedBox(height: 12),
                    _buildKunjungiLagiList(),

                    const SizedBox(height: 22),

                    // 8. TERAKHIR DILIHAT SECTION
                    _buildSectionHeaderWithAction('Terakhir Dilihat', 'Selengkapnya', () {
                      Navigator.pushNamed(context, '/terakhir-dilihat');
                    }),
                    const SizedBox(height: 12),
                    _buildTerakhirDilihatCard(),
                  ],
                ),
              ),

              // Floating AI Mascot Avatar on the bottom right
              Positioned(
                right: 16,
                bottom: 84,
                child: AnimatedBuilder(
                  animation: _botFloatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _botFloatAnimation.value),
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: _showAiAssistantChat,
                    child: SizedBox(
                      width: 68,
                      height: 86,
                      child: Image.asset(
                        'lib/images/bot_mascot.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B4D8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.smart_toy_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomNavigationBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. TOP HEADER WIDGET
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Brand Logo ECOWALK (matching visual brand)
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ECOWA',
              style: TextStyle(
                color: darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                height: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: SvgPicture.asset(
                'lib/images/Vector.svg',
                width: 20,
                height: 22,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  darkGreen,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Text(
              'K',
              style: TextStyle(
                color: darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                height: 1.0,
              ),
            ),
          ],
        ),

        // Right side: Avatar and Notification Bell
        Row(
          children: [
            // Profile circular avatar (tap to go to Profile)
            GestureDetector(
              onTap: _navigateToProfile,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryGreen.withValues(alpha: 0.2), width: 1.5),
                ),
                child: ClipOval(
                  child: _profileImagePath != null
                      ? (kIsWeb
                          ? Image.network(
                              _profileImagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildFallbackAvatar(),
                            )
                          : Image.file(
                              File(_profileImagePath!),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildFallbackAvatar(),
                            ))
                      : _buildFallbackAvatar(),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Notification Bell Button
            GestureDetector(
              onTap: _navigateToNotifikasi,
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFallbackAvatar() {
    return Image.asset(
      'lib/images/asep_kopling.jpg',
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: primaryGreen.withValues(alpha: 0.1),
        child: const Icon(Icons.person, color: primaryGreen, size: 22),
      ),
    );
  }

  // 2. WEATHER CARD WIDGET
  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(context, '/cuaca');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'lib/images/weather_card.png',
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildNativeWeatherCard();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNativeWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF386C5E),
            Color(0xFFC7A87A),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Minggu, 16 Febuari 2025',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Klapanunggal, Bogor',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '30°C',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 44,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Cerah Berawan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
          Image.asset(
            'lib/images/weather_icon.png',
            width: 105,
            height: 105,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.wb_sunny_rounded, size: 80, color: Colors.amber),
          ),
        ],
      ),
    );
  }

  // 3. SECTION HEADERS
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.bold,
        color: textDark,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildSectionHeaderWithAction(String title, String actionText, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: textDark,
            letterSpacing: 0.2,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionText,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 16, color: textMuted),
            ],
          ),
        ),
      ],
    );
  }

  // 4. REKOMENDASI LIST (HORIZONTAL CARDS)
  Widget _buildRecommendationList() {
    final items = _filteredDestinations;
    if (items.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: const Text('Tidak ada destinasi pada kategori ini'),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildDestinationCard(item);
        },
      ),
    );
  }

  Widget _buildDestinationCard(DestinationItem item, {double width = 175, double height = 250}) {
    return GestureDetector(
      onTap: () => _showDestinationDetail(item),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
              ),

              // Gradient dark overlay on bottom for readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.95),
                      ],
                      stops: const [0.3, 0.5, 0.78, 1.0],
                    ),
                  ),
                ),
              ),

              // Distance Badge Top Right (e.g. "1.68 KM")
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4D43).withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.distance,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Card Text Information (Bottom)
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Location Pin
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.redAccent, size: 11),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Price
                    Text(
                      item.price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Stars + "Lebih Lanjut >"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => const Icon(
                              Icons.star,
                              color: Color(0xFFFFB800),
                              size: 11,
                            ),
                          ),
                        ),
                        const Text(
                          'Lebih Lanjut >',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. KATEGORI CHIPS
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E6B5E) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2E6B5E) : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 6. PILIHAN TERATAS LIST
  Widget _buildPilihanTeratasList() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _destinations.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _destinations[index];
          return GestureDetector(
            onTap: () => _showDestinationDetail(item),
            child: Container(
              width: 145,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(item.imagePath, fit: BoxFit.cover),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.redAccent, size: 9),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  item.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 7. BANNER PROMO / KOMPARASI
  Widget _buildCompareBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF498579).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(context, '/komparasi');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 361 / 103,
              child: Image.asset(
                'lib/images/banner_komparasi.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackCompareBanner(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackCompareBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF498579),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 100, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Banyak pilihan tempat wisata bikin bingung?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bandingkan sekarang dan temukan yang terbaik!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF265D52),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/komparasi'),
                  child: const Text(
                    'Bandingkan Sekarang',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            bottom: 0,
            top: 0,
            child: Image.asset(
              'lib/images/banner_traveler.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  // 8. KUNJUNGI LAGI LIST
  Widget _buildKunjungiLagiList() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _destinations.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _destinations[index];
          return GestureDetector(
            onTap: () => _showDestinationDetail(item),
            child: Container(
              width: 145,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(item.imagePath, fit: BoxFit.cover),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.redAccent, size: 9),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  item.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 9. TERAKHIR DILIHAT CARD
  Widget _buildTerakhirDilihatCard() {
    final item = _destinations[0];
    return _buildDestinationCard(item, width: double.infinity, height: 180);
  }

  // 10. BOTTOM NAVIGATION BAR (MATCHING MOCKUP WITH ELEVATED BERANDA CIRCLE)
  Widget _buildBottomNavigationBar() {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.transparent,
      child: SizedBox(
        height: 64 + bottomPadding,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Dark Teal / Green Bar Base
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 10,
              child: Container(
                color: const Color(0xFF347063),
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Row(
                  children: [
                    // Tab 1: BERANDA (Place for elevated home button)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedNavIndex = 0);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 26),
                          child: Text(
                            'BERANDA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tab 2: REKOMENDASI (Rute & Transportasi)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/rekomendasi');
                        },
                        child: Center(
                          child: Icon(
                            Icons.shield_outlined,
                            size: 26,
                            color: _selectedNavIndex == 1
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),

                    // Tab 3: Chat / Pesan
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedNavIndex = 2);
                          _showAiAssistantChat();
                        },
                        child: Center(
                          child: Icon(
                            Icons.chat_bubble_rounded,
                            size: 24,
                            color: _selectedNavIndex == 2
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),

                    // Tab 4: AKUN
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedNavIndex = 3);
                          _navigateToProfile();
                        },
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 27,
                            color: _selectedNavIndex == 3
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Elevated Circular Home Button (Tab 0: BERANDA)
            Positioned(
              left: (MediaQuery.of(context).size.width / 4 - 56) / 2,
              top: -8,
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedNavIndex = 0);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF347063),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.home_rounded,
                      size: 32,
                      color: Color(0xFF347063),
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
