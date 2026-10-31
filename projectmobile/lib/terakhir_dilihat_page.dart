import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TerakhirDilihatPage extends StatelessWidget {
  final List<Map<String, dynamic>>? items;

  const TerakhirDilihatPage({super.key, this.items});

  // Warna tema sesuai referensi aplikasi Ecowalk
  static const Color appColorPrimary = Color(0xFF4A8173);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    // Daftar riwayat destinasi terakhir dilihat (default sesuai mockup)
    final recentItems = items ?? [
      {
        'id': 'dufan',
        'title': 'Dunia Fantasi (DUFAN)',
        'rating': '4.75',
        'openHours': '10:00 - 22:00',
        'location': 'Ancol, Jakarta utara',
        'price': 'Mulai dari Rp. 200.000',
        'priceRange': 'Rp. 190.000 - Rp. 400.000',
        'reviewsCount': '24.543 Ulasan',
        'address':
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'description':
            'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
        'distance': '1.68 KM',
        'heroImage': 'lib/images/dufan_detail_hero.png',
        'mapImage': 'lib/images/map_dufan.png',
      },
      {
        'id': 'dufan',
        'title': 'Dunia Fantasi (DUFAN)',
        'rating': '4.75',
        'openHours': '10:00 - 22:00',
        'location': 'Ancol, Jakarta utara',
        'price': 'Mulai dari Rp. 200.000',
        'priceRange': 'Rp. 190.000 - Rp. 400.000',
        'reviewsCount': '24.543 Ulasan',
        'address':
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'description':
            'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
        'distance': '1.68 KM',
        'heroImage': 'lib/images/dufan_detail_hero.png',
        'mapImage': 'lib/images/map_dufan.png',
      },
      {
        'id': 'dufan',
        'title': 'Dunia Fantasi (DUFAN)',
        'rating': '4.75',
        'openHours': '10:00 - 22:00',
        'location': 'Ancol, Jakarta utara',
        'price': 'Mulai dari Rp. 200.000',
        'priceRange': 'Rp. 190.000 - Rp. 400.000',
        'reviewsCount': '24.543 Ulasan',
        'address':
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'description':
            'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
        'distance': '1.68 KM',
        'heroImage': 'lib/images/dufan_detail_hero.png',
        'mapImage': 'lib/images/map_dufan.png',
      },
      {
        'id': 'dufan',
        'title': 'Dunia Fantasi (DUFAN)',
        'rating': '4.75',
        'openHours': '10:00 - 22:00',
        'location': 'Ancol, Jakarta utara',
        'price': 'Mulai dari Rp. 200.000',
        'priceRange': 'Rp. 190.000 - Rp. 400.000',
        'reviewsCount': '24.543 Ulasan',
        'address':
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'description':
            'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
        'distance': '1.68 KM',
        'heroImage': 'lib/images/dufan_detail_hero.png',
        'mapImage': 'lib/images/map_dufan.png',
      },
    ];

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
            'Terakhir Dilihat',
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
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: recentItems.length,
            separatorBuilder: (context, index) => const Divider(
              height: 24,
              thickness: 0.8,
              color: Color(0xFFE5E7EB),
            ),
            itemBuilder: (context, index) {
              final item = recentItems[index];
              return _buildRecentItem(context, item);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRecentItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () => _navigateToDetailWisata(context, item),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Avatar / Thumbnail Abu-abu
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  item['heroImage'] ?? 'lib/images/dufan.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: const Color(0xFFD9D9D9));
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Deskripsi Destinasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? 'Dunia Fantasi (DUFAN)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 13,
                        color: Color(0xFFFBBF24),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item['rating'] ?? '4.75'}  | Open ${item['openHours'] ?? '10:00 - 22:00'}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['location'] ?? 'Ancol, Jakarta utara',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['price'] ?? 'Mulai dari Rp. 200.000',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron Arrow Right
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: textDark,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetailWisata(BuildContext context, Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/detail-wisata',
      arguments: {
        'id': item['id'] ?? 'dufan',
        'title': item['title'] ?? 'Dunia Fantasi (DUFAN)',
        'rating': item['rating'] ?? '4.75',
        'reviewsCount': item['reviewsCount'] ?? '24.543 Ulasan',
        'openHours': item['openHours'] ?? '10:00 - 22:00',
        'isOpen': true,
        'address': item['address'] ??
            'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
        'description': item['description'] ??
            'Dufan (Dunia Fantasi) adalah taman hiburan yang terletak di kawasan Taman Impian Ancol, Jakarta Utara. Dufan merupakan salah satu taman hiburan terbesar dan terpopuler di Indonesia.',
        'priceRange': item['priceRange'] ?? 'Rp. 190.000 - Rp. 400.000',
        'distance': item['distance'] ?? '1.68 KM',
        'heroImage': item['heroImage'] ?? 'lib/images/dufan_detail_hero.png',
        'mapImage': item['mapImage'] ?? 'lib/images/map_dufan.png',
      },
    );
  }
}
