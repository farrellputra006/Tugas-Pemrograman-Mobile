import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  // Warna tema sesuai referensi aplikasi Ecowalk
  static const Color appColorPrimary = Color(0xFF4A8173);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color linkBlue = Color(0xFF0284C7);
  static const Color statusGreen = Color(0xFF388E3C);

  @override
  Widget build(BuildContext context) {
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
            'Notifikasi',
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
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // 1. DUFAN Item 1
              _buildDufanNotificationItem(context),
              _buildDivider(),

              // 2. DUFAN Item 2
              _buildDufanNotificationItem(context),
              _buildDivider(),

              // 3. DUFAN Item 3
              _buildDufanNotificationItem(context),
              _buildDivider(),

              // 4. DUFAN Item 4
              _buildDufanNotificationItem(context),
              _buildDivider(),

              // 5. Cuaca Sedang Cerah Item
              _buildWeatherNotificationItem(context),
              _buildDivider(),

              // 6. DUFAN Item 5
              _buildDufanNotificationItem(context),
              _buildDivider(),

              // 7. DUFAN Item 6
              _buildDufanNotificationItem(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 24,
      thickness: 0.8,
      color: Color(0xFFE5E7EB),
    );
  }

  // Notifikasi Wisata Dunia Fantasi (DUFAN)
  Widget _buildDufanNotificationItem(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToRekapPerjalanan(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Abu-abu / Gambar Dufan
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'lib/images/dufan.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: const Color(0xFFD9D9D9));
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          'Dunia Fantasi (DUFAN)',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Status Selesai Badge
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 13,
                            color: appColorPrimary,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Selesai',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '19 Febuari 2025',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Transportasi Umum',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _navigateToDufanDetail(context),
                    child: const Text(
                      'Pergi Lagi',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: linkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Notifikasi Cuaca Sedang Cerah
  Widget _buildWeatherNotificationItem(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/cuaca'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon Matahari Cerah
            SizedBox(
              width: 68,
              height: 68,
              child: Center(
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: 52,
                  color: const Color(0xFFFACC15),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cuaca Sedang Cerah',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '19 Febuari 2025',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Yuk keluar dan jalan-jalan !',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/kategori'),
                    child: const Text(
                      'Lihat Destinasi Wisata',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: linkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigasi ke Halaman Rekap Perjalanan Selesai
  void _navigateToRekapPerjalanan(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/rekap-perjalanan',
      arguments: {
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
      },
    );
  }

  // Navigasi ke Detail Wisata DUFAN dengan data lengkap agar tidak salah halaman
  void _navigateToDufanDetail(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/detail-wisata',
      arguments: {
        'id': 'dufan',
        'title': 'Dunia Fantasi (DUFAN)',
        'rating': '4.75',
        'reviewsCount': '24.543 Ulasan',
        'openHours': '10:00 - 22:00',
        'isOpen': true,
        'address':
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'description':
            'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
        'priceRange': 'Rp. 190.000 - Rp. 400.000',
        'distance': '1.68 KM',
        'heroImage': 'lib/images/dufan_detail_hero.png',
        'mapImage': 'lib/images/map_dufan.png',
      },
    );
  }
}
