import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Warna tema identik dengan desain Ecowalk
  static const Color primaryGreen = Color(0xFF1E604E);
  static const Color paleGreenBg = Color(0xFFDEE7E2);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap masukkan kata sandi baru'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap konfirmasi kata sandi baru Anda'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi kata sandi tidak cocok'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Dialog Sukses & Arahkan kembali ke Halaman Login
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: primaryGreen, size: 28),
            SizedBox(width: 10),
            Text(
              'Berhasil!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
          ],
        ),
        content: const Text(
          'Kata sandi Anda telah berhasil diperbarui. Silakan masuk kembali menggunakan kata sandi baru Anda.',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: primaryGreen,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('MASUK SEKARANG'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background grafis diagonal lembut di bagian atas
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenSize.height * 0.45,
              child: CustomPaint(
                painter: _DiagonalBackgroundPainter(),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tombol Kembali bila ada riwayat navigasi
                    if (Navigator.canPop(context))
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: Colors.black87,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Logo ECOWALK
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'ECOWA',
                            style: TextStyle(
                              color: primaryGreen,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              height: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1.0),
                            child: SvgPicture.asset(
                              'lib/images/Vector.svg',
                              width: 36,
                              height: 38,
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
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Teks Judul "LUPA KATA SANDI"
                    const Center(
                      child: Text(
                        'LUPA KATA SANDI',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 56),

                    // Teks Sub-Judul: "Masukan Kata Sandi Baru"
                    const Text(
                      'Masukan Kata Sandi Baru',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Input 1: Kata Sandi Baru
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      cursorColor: primaryGreen,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 24,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.lock_rounded,
                            color: Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                        hintText: 'Kata Sandi Baru',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 13.5,
                          color: Colors.grey.shade600,
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF757575),
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade800,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryGreen,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Input 2: Konfirmasi Kata Sandi
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      cursorColor: primaryGreen,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 24,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.lock_rounded,
                            color: Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                        hintText: 'Konfirmasi Kata Sandi',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 13.5,
                          color: Colors.grey.shade600,
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF757575),
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade800,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryGreen,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 44),

                    // Tombol UBAH KATA SANDI
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'UBAH KATA SANDI',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter untuk melukis bentuk latar belakang diagonal berwarna sage lembut
class _DiagonalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _NewPasswordPageState.paleGreenBg
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.72)
      ..lineTo(0, size.height * 0.30)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
