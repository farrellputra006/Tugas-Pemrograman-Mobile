import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RekapPerjalananPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RekapPerjalananPage({super.key, this.data});

  @override
  State<RekapPerjalananPage> createState() => _RekapPerjalananPageState();
}

class _RekapPerjalananPageState extends State<RekapPerjalananPage> {
  // Warna tema sesuai referensi aplikasi Ecowalk
  static const Color appColorPrimary = Color(0xFF4A8173);
  static const Color primaryGreen = Color(0xFF1B6A5A);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);

  bool _showFeedbackCard = true;
  int _userRating = 0;

  late final Map<String, dynamic> _item;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _item = args;
    } else if (widget.data != null) {
      _item = widget.data!;
    } else {
      // Default ke Dunia Fantasi (DUFAN) sesuai mockup referensi
      _item = {
        'id': 'dufan',
        'title': 'Dunia Fantasi (DUFAN)',
        'dateTime': '19 Febuari 2025 | 12:00 WIB',
        'address':
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'heroImage': 'lib/images/rekap_dufan_hero.png',
        'mapImage': 'lib/images/rekap_map.png',
        'transportImage': 'lib/images/transport_ojek.png',
        'rating': '4.75',
        'reviewsCount': '24.543 Ulasan',
        'openHours': '10:00 - 22:00',
        'priceRange': 'Rp. 190.000 - Rp. 400.000',
        'distance': '1.68 KM',
      };
    }
  }

  void _navigateToRating(int rating) {
    setState(() {
      _userRating = rating;
    });
    Navigator.pushNamed(
      context,
      '/rating-wisata',
      arguments: {
        'id': _item['id'] ?? 'dufan',
        'title': 'Dunia Fantasi\n(DUFAN)',
        'rawTitle': _item['title'] ?? 'Dunia Fantasi (DUFAN)',
        'heroImage': 'lib/images/dufan_detail_hero.png',
        'initialRating': rating > 0 ? rating : 5,
        'userName': 'Kaisyarani',
      },
    );
  }

  void _navigateToDetailWisata() {
    Navigator.pushNamed(
      context,
      '/detail-wisata',
      arguments: {
        'id': _item['id'] ?? 'dufan',
        'title': _item['title'] ?? 'Dunia Fantasi (DUFAN)',
        'rating': _item['rating'] ?? '4.75',
        'reviewsCount': _item['reviewsCount'] ?? '24.543 Ulasan',
        'openHours': _item['openHours'] ?? '10:00 - 22:00',
        'isOpen': true,
        'address': _item['address'] ??
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'description':
            'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
        'priceRange': _item['priceRange'] ?? 'Rp. 190.000 - Rp. 400.000',
        'distance': _item['distance'] ?? '1.68 KM',
        'heroImage': 'lib/images/dufan_detail_hero.png',
        'mapImage': 'lib/images/map_dufan.png',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _item['title'] ?? 'Dunia Fantasi (DUFAN)';
    final dateTime = _item['dateTime'] ?? '19 Febuari 2025 | 12:00 WIB';
    final address = _item['address'] ??
        'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: appColorPrimary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColorPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Kembali',
          ),
          title: const Text(
            'Rekap Perjalanan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO IMAGE (Dufan Komidi Putar & Pengunjung)
                _buildHeroImage(),

                const SizedBox(height: 18),

                // 2. TITLE & DETAIL INFO
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateTime,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.map_outlined,
                        size: 16,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: textMuted,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 3. RUTE PERJALANAN SECTION
                const Text(
                  'Rute Perjalanan',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 10),
                _buildRouteMap(),

                const SizedBox(height: 20),

                // 4. TRANSPORTASI SECTION
                const Text(
                  'Transportasi',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTransportCard(),

                const SizedBox(height: 20),

                // 5. RATING / FEEDBACK CARD ("Bagaimana Perjalananmu?")
                if (_showFeedbackCard) ...[
                  _buildFeedbackCard(),
                  const SizedBox(height: 20),
                ],

                // 6. BOTTOM ACTION BUTTON ("Pergi Lagi")
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColorPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _navigateToDetailWisata,
                    child: const Text(
                      'Pergi Lagi',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Hero Image dengan sudut membulat rapi
  Widget _buildHeroImage() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'lib/images/rekap_dufan_hero.png',
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'lib/images/dufan.png',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  // 2. Rute Perjalanan Map Card
  Widget _buildRouteMap() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/peta-rute',
          arguments: {
            'origin': _item['origin'] ?? 'Lokasi Asal',
            'destination': _item['title'] ?? 'Destinasi',
            'mode': _item['transport'] ?? 'Transportasi Terpilih',
            'duration': _item['estimatedDuration'] ?? '20 Menit',
            'distance': _item['distance'] ?? '5.2 KM',
            'isLiveNavigation': true,
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 135,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'lib/images/rekap_map.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'lib/images/map_route.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.fullscreen, size: 12, color: Color(0xFF1B6A5A)),
                      SizedBox(width: 3),
                      Text(
                        'Lihat Peta',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B6A5A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Kartu Transportasi (Ojek Online)
  Widget _buildTransportCard() {
    return Container(
      width: 78,
      height: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
            Image.asset(
              'lib/images/transport_ojek.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF2E7D32),
                  child: const Center(
                    child: Icon(Icons.two_wheeler, color: Colors.white, size: 36),
                  ),
                );
              },
            ),
            // Gradient overlay untuk teks yang jelas
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ojek Online',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Gojek, Grab, Maxim',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 7.5,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Nyaman, dan cepat',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 7.5,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Kartu Feedback & Rating
  Widget _buildFeedbackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bagaimana Perjalananmu?',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFeedbackCard = false;
                  });
                },
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Yuk beri ulasan untuk tempat yang baru kamu kunjungi !',
            style: TextStyle(
              fontSize: 11.5,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              final starNumber = index + 1;
              final isFilled = starNumber <= _userRating;
              return GestureDetector(
                onTap: () => _navigateToRating(starNumber),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 30,
                    color: isFilled ? const Color(0xFFFBBF24) : textDark,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
