import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Mode verifikasi: true = Email, false = Nomor Hp
  bool _isEmail = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Warna tema identik dengan desain Ecowalk
  static const Color primaryGreen = Color(0xFF1E604E);
  static const Color accentBlue = Color(0xFF00B4D8);
  static const Color paleGreenBg = Color(0xFFDEE7E2);

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final destination = _isEmail
        ? _emailController.text.trim()
        : _phoneController.text.trim();

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEmail
                ? 'Harap masukkan alamat email terlebih dahulu'
                : 'Harap masukkan nomor HP terlebih dahulu',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Arahkan ke halaman verifikasi dengan membawa data tujuan & metode
    Navigator.pushNamed(
      context,
      '/verification',
      arguments: {
        'isEmail': _isEmail,
        'destination': destination,
        'isResetPassword': true,
      },
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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

                    const SizedBox(height: 60),

                    // Baris Ikon Lonceng Notifikasi + Deskripsi Petunjuk
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notifications_none_outlined,
                          size: 26,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isEmail
                                ? 'Periksa dan masukan alamat Email untuk mendapatkan kode verifikasi'
                                : 'Periksa dan masukan Nomor Hp untuk mendapatkan kode verifikasi',
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Colors.black87,
                              height: 1.35,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Label Input
                    Text(
                      _isEmail ? 'Alamat Email' : 'Nomor Hp',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Field Input dengan Underline Border
                    TextField(
                      controller: _isEmail ? _emailController : _phoneController,
                      keyboardType: _isEmail
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                      cursorColor: primaryGreen,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
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

                    const SizedBox(height: 24),

                    // Opsi Ganti Metode Verifikasi (Gunakan Nomor Hp / Gunakan Email)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _isEmail = !_isEmail;
                        });
                      },
                      child: Text(
                        _isEmail ? 'Gunakan Nomor Hp' : 'Gunakan Email',
                        style: const TextStyle(
                          color: accentBlue,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tombol KIRIM
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
                          'KIRIM',
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
      ..color = _ForgotPasswordPageState.paleGreenBg
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
