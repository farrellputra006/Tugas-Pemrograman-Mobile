import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
          'Ketentuan Layanan',
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

            // Judul Ketentuan
            const Text(
              'KETENTUAN PENGGUNAAN APLIKASI ECOWALK',
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
              'Selamat datang di ECOWALK! Dengan menggunakan aplikasi ini, Anda setuju dengan ketentuan dan persyaratan berikut:',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Poin 1
            const Text(
              '1. Dengan menggunakan aplikasi ECOWALK, Anda dapat menemukan informasi tentang tempat wisata, rekomendasi tempat, perbandingan harga, dan layanan peta berbasis lokasi.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Poin 2
            const Text(
              '2. Anda bertanggung jawab atas keakuratan data, termasuk ulasan dan foto, yang Anda masukkan.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Poin 3
            const Text(
              '3. Perubahan Layanan ECOWALK berhak mengubah, menambah, atau menghentikan layanan tanpa pemberitahuan sebelumnya. Pengguna bertanggung jawab atas keamanan akun mereka, termasuk kata sandi. Pengguna juga dilarang menggunakan aplikasi untuk tujuan yang dapat merugikan pihak lain.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Informasi yang diberikan oleh sumber seperti tiket atau biaya transportasi tidak akurat, dan kami tidak bertanggung jawab atas kesalahan tersebut.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            // Poin 4: Penolakan Tanggung Jawab
            const Text(
              '4. Penolakan Tanggung Jawab',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            _buildBulletItem(
              'ECOWALK hanya menyediakan informasi sebagai referensi dan bukan penyedia layanan wisata atau transportasi.',
            ),
            _buildBulletItem(
              'Kami tidak bertanggung jawab atas perubahan harga, ketersediaan tempat, atau keterlambatan transportasi.',
            ),

            const SizedBox(height: 22),

            // Paragraf Penutup
            const Text(
              'Dengan menggunakan aplikasi ini, Anda menyetujui semua ketentuan di atas.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
