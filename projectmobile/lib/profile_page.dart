import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Warna hijau primer identik dengan tema Ecowalk dan desain referensi (#1A6556)
  static const Color primaryGreen = Color(0xFF1A6556);
  static const Color textDark = Color(0xFF1F2937);

  int _selectedNavIndex = 3; // Default pada tab 'AKUN'
  String _userName = 'ASEP KOPLING';
  String? _profileImagePath;

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.pushNamed(
      context,
      '/edit-profile',
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

  void _showComingSoonSnackBar(String title) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu $title segera hadir'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryGreen,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 48),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Dialog: "Keluar?"
              const Text(
                'Keluar?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // Pesan Konfirmasi: "Apakah Kamu Yakin Ingin Keluar?"
              const Text(
                'Apakah Kamu Yakin Ingin Keluar?',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 22),

              // Baris Tombol "Batal" dan "Keluar"
              Row(
                children: [
                  // Tombol "Batal" (Hijau gelap tema, tulisan putih)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Tombol "Keluar" (Latar putih, border hijau gelap, tulisan hitam)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        side: const BorderSide(
                          color: primaryGreen,
                          width: 1.5,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Bagian Atas: Header Hijau dengan Foto Profil yang tumpang-tindih (overlapping)
                    _buildHeaderWithAvatar(),

                    const SizedBox(height: 14),

                    // Nama Profil
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: textDark,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Chip Email: Badge hijau kapsul
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'asepkopling@gmail.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Daftar Menu Profil
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan',
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profil',
                      onTap: _navigateToEditProfile,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Kebijakan Privasi',
                      onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Tentang Kami',
                      onTap: () => Navigator.pushNamed(context, '/about-us'),
                    ),
                    _buildDivider(),
                    // Ketentuan Layanan (sesuai gambar referensi: tidak memakai ikon depan)
                    _buildMenuItem(
                      icon: null,
                      title: 'Ketentuan Layanan',
                      onTap: () => Navigator.pushNamed(context, '/terms-of-service'),
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Keluar',
                      onTap: _showLogoutDialog,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar Kustom persis gambar referensi
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_profileImagePath != null && _profileImagePath!.isNotEmpty) {
      if (_profileImagePath!.startsWith('assets/') || _profileImagePath!.startsWith('lib/')) {
        return Image.asset(
          _profileImagePath!,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatarImage(),
        );
      } else if (kIsWeb) {
        return Image.network(
          _profileImagePath!,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatarImage(),
        );
      } else {
        final file = File(_profileImagePath!);
        return Image.file(
          file,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatarImage(),
        );
      }
    }
    return _buildFallbackAvatarImage();
  }

  Widget _buildHeaderBackgroundImage() {
    if (_profileImagePath == null || _profileImagePath!.isEmpty) {
      return const SizedBox();
    }
    if (_profileImagePath!.startsWith('assets/') || _profileImagePath!.startsWith('lib/')) {
      return Image.asset(
        _profileImagePath!,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => const SizedBox(),
      );
    } else if (kIsWeb) {
      return Image.network(
        _profileImagePath!,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => const SizedBox(),
      );
    } else {
      final file = File(_profileImagePath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (_, __, ___) => const SizedBox(),
        );
      }
    }
    return const SizedBox();
  }

  Widget _buildFallbackAvatarImage() {
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

  // Header Hijau dengan Avatar Foto Profil Lingkaran
  Widget _buildHeaderWithAvatar() {
    const double headerHeight = 150.0;
    const double avatarRadius = 64.0;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Latar Belakang Atas (menyesuaikan hasil foto kamera bila tersedia dengan aksen tema)
        Container(
          width: double.infinity,
          height: headerHeight,
          decoration: const BoxDecoration(
            color: primaryGreen,
          ),
          child: (_profileImagePath != null && _profileImagePath!.isNotEmpty)
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildHeaderBackgroundImage(),
                    Container(
                      color: primaryGreen.withValues(alpha: 0.68),
                    ),
                  ],
                )
              : null,
        ),

        // Foto Profil Lingkaran dengan border putih
        Positioned(
          top: headerHeight - avatarRadius,
          child: GestureDetector(
            onTap: _navigateToEditProfile,
            child: Container(
              width: avatarRadius * 2,
              height: avatarRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 4.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: _buildAvatarImage(),
              ),
            ),
          ),
        ),

        // Dummy height spacing agar layout di bawah Stack berada tepat di bawah avatar
        const SizedBox(
          height: headerHeight + avatarRadius,
          width: double.infinity,
        ),
      ],
    );
  }

  // Widget Item Menu List
  Widget _buildMenuItem({
    required IconData? icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
        child: Row(
          children: [
            // Ikon atau indentasi jika tanpa ikon
            if (icon != null)
              Icon(
                icon,
                size: 24,
                color: Colors.black87,
              )
            else
              const SizedBox(width: 24),

            const SizedBox(width: 18),

            // Judul Menu
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                  letterSpacing: 0.1,
                ),
              ),
            ),

            // Ikon Chevron Kanan
            const Icon(
              Icons.chevron_right_rounded,
              size: 26,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  // Garis Pembatas Halus Antar Item Menu
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 20,
      endIndent: 20,
    );
  }

  // Bottom Navigation Bar yang identik dengan gambar referensi
  Widget _buildBottomNavigationBar() {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 64 + bottomPadding,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background Hijau Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 10,
              child: Container(
                color: primaryGreen,
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Row(
                  children: [
                    // Tab 1: Beranda
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedNavIndex = 0);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: Center(
                          child: Icon(
                            Icons.home_outlined,
                            size: 28,
                            color: _selectedNavIndex == 0
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
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

                    // Tab 3: Ulasan / Review
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/reviews');
                        },
                        child: Center(
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 25,
                            color: _selectedNavIndex == 2
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),

                    // Tab 4: AKUN (Placeholder lebar untuk menampung tombol Akun terangkat)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedNavIndex = 3);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 26),
                          child: const Text(
                            'AKUN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
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

            // Tombol AKUN Melayang / Timbul (Floating circular badge)
            Positioned(
              right: (MediaQuery.of(context).size.width / 4 - 56) / 2,
              top: -8,
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedNavIndex = 3);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryGreen,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: primaryGreen,
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
