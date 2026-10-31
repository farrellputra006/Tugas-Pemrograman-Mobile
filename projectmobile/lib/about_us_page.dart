import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const Color primaryGreen = Color(0xFF1A6556);

  Widget _buildTopRightLogo() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'ECOWA',
            style: TextStyle(
              color: primaryGreen,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.5),
            child: SvgPicture.asset(
              'lib/images/Vector.svg',
              width: 14,
              height: 14,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                primaryGreen,
                BlendMode.srcIn,
              ),
            ),
          ),
          const Text(
            'K',
            style: TextStyle(
              color: primaryGreen,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Tentang Kami',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo ECOWALK di pojok kanan atas
            _buildTopRightLogo(),

            const SizedBox(height: 16),

            // Paragraf Pembuka
            const Text(
              'ECOWALK adalah aplikasi wisata yang membantu pengguna menemukan destinasi terbaik dengan rekomendasi berdasarkan lokasi, perbandingan harga, serta informasi transportasi.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Bagian Misi Kami (underline)
            const Text(
              'Misi Kami',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Menyediakan pengalaman wisata yang lebih mudah, informatif, dan terjangkau bagi semua orang dengan fokus pada ekowisata yang ramah lingkungan.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Bagian Apa yang Kami Tawarkan?
            const Text(
              'Apa yang Kami Tawarkan?',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            _buildBulletItem(
              'Rekomendasi tempat wisata berdasarkan lokasi dan preferensi Anda.',
            ),
            _buildBulletItem(
              'Informasi harga tiket, ketersediaan fasilitas, dan ulasan pengguna.',
            ),
            _buildBulletItem(
              'Peta interaktif untuk membantu navigasi di area wisata.',
            ),
            _buildBulletItem(
              'Perbandingan harga transportasi untuk perjalanan yang lebih hemat.',
            ),

            const SizedBox(height: 18),

            // Paragraf Penutup
            const Text(
              'Kami percaya bahwa menjelajahi dunia harus menjadi pengalaman yang menyenangkan dan mudah diakses oleh semua orang, dengan tetap menjaga kelestarian lingkungan.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Untuk pertanyaan atau saran, hubungi kami di:',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 14),

            // Kontak Email
            const Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.black87,
                  size: 20,
                ),
                SizedBox(width: 14),
                Text(
                  'support@ecowalk.com',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Kontak Telepon
            const Row(
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.black87,
                  size: 20,
                ),
                SizedBox(width: 14),
                Text(
                  '0899-1234-4567',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
