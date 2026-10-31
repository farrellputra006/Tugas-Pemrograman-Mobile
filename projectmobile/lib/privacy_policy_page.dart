import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Kebijakan Privasi',
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

            // Judul Kebijakan Privasi
            const Text(
              'KEBIJAKAN PRIVASI APLIKASI ECOWALK',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Diperbaharui tanggal 16 Februari 2024',
              style: TextStyle(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 22),

            // Paragraf Pembuka
            const Text(
              'Kami menghargai privasi pengguna. Kebijakan ini menjelaskan bagaimana ECOWALK mengumpulkan, menggunakan, dan melindungi data Anda.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Poin 1: Data yang Kami Kumpulkan
            const Text(
              '1. Data yang Kami Kumpulkan',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Kami dapat mengumpulkan data berikut:',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            _buildBulletItem('Data Pribadi: Nama, email, dan informasi akun.'),
            _buildBulletItem(
              'Data Lokasi: Untuk memberikan rekomendasi wisata dan perhitungan jarak.',
            ),
            _buildBulletItem(
              'Ulasan dan Foto: Jika Anda memposting ulasan atau berbagi pengalaman wisata.',
            ),

            const SizedBox(height: 18),

            // Poin 2: Cara Kami Menggunakan Data
            const Text(
              '2. Cara Kami Menggunakan Data',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            _buildBulletItem(
              'Memberikan rekomendasi tempat wisata berdasarkan lokasi.',
            ),
            _buildBulletItem(
              'Memproses pencarian dan filter destinasi sesuai preferensi.',
            ),
            _buildBulletItem(
              'Menampilkan ulasan dan foto yang dibagikan pengguna lain.',
            ),
            _buildBulletItem(
              'Menyediakan informasi transportasi berdasarkan data lokasi.',
            ),

            const SizedBox(height: 18),

            // Poin 3: Keamanan Data
            const Text(
              '3. Keamanan Data',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Kami menggunakan enkripsi dan metode keamanan lainnya untuk melindungi data Anda.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Poin 4: Hak Pengguna
            const Text(
              '4. Hak Pengguna',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            _buildBulletItem(
              'Anda dapat memperbarui atau menghapus informasi akun kapan saja.',
            ),
            _buildBulletItem(
              'Anda dapat menonaktifkan fitur lokasi jika tidak ingin berbagi data lokasi.',
            ),
            _buildBulletItem(
              'Kami tidak akan membagikan data pribadi Anda kepada pihak ketiga tanpa persetujuan Anda.',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
