import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailUlasanPage extends StatelessWidget {
  final Map<String, dynamic>? data;

  const DetailUlasanPage({super.key, this.data});

  // Warna tema sesuai referensi aplikasi Ecowalk
  static const Color appColorPrimary = Color(0xFF4A8173);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic> review = {};

    if (args != null && args is Map<String, dynamic>) {
      review = args;
    } else if (data != null) {
      review = data!;
    } else {
      // Data default sesuai tampilan tangkapan layar
      review = {
        'name': 'Kaisyarani Zahra',
        'rating': 5.0,
        'comment':
            'pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik',
        'date': 'Diulas pada 12 Febuari 2025',
        'images': <String>[],
      };
    }

    final String name = review['name'] ?? 'Kaisyarani Zahra';
    final double ratingVal = (review['rating'] is num)
        ? (review['rating'] as num).toDouble()
        : 5.0;
    final String ratingStr = '${ratingVal.toStringAsFixed(1)} / 5.0';
    final String comment = review['comment'] ??
        'pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik';
    final String date = review['date'] ?? 'Diulas pada 12 Febuari 2025';
    final List<dynamic> images = (review['images'] is List) ? review['images'] : [];

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
            'Nilai & Ulasan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Avatar Bulat, Nama Pengguna, Badge Nilai Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Avatar Placeholder
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1D5DB),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // User Name
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ),

                    // Rating Pill Badge (5.0 / 5.0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF387B6C),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        ratingStr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Isi Komentar Ulasan Lengkap
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1F2937),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Foto Lampiran Ulasan (Dua kotak abu-abu / gambar ulasan)
                Row(
                  children: [
                    _buildPhotoSquare(
                      images.isNotEmpty ? images[0].toString() : null,
                    ),
                    const SizedBox(width: 12),
                    _buildPhotoSquare(
                      images.length > 1 ? images[1].toString() : null,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 4. Tanggal Ulasan (Rata Kanan)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: textMuted,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Garis Pembatas
                const Divider(
                  height: 1,
                  thickness: 0.8,
                  color: Color(0xFFE5E7EB),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSquare(String? imagePath) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(4),
      ),
      child: imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: const Color(0xFFD1D5DB)),
              ),
            )
          : null,
    );
  }
}
