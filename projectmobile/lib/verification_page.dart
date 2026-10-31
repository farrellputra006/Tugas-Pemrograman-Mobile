import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  // Mode verifikasi: false = No. Hp, true = Email
  bool _isEmail = false;
  String? _destination;
  bool _isResetPassword = false;
  bool _isChangePhone = false;
  bool _isChangeEmail = false;
  bool _isInit = false;

  // 4 Controller dan FocusNode untuk masing-masing kotak OTP
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  // Warna tema identik dengan seluruh alur aplikasi
  static const Color primaryGreen = Color(0xFF1E604E);
  static const Color accentBlue = Color(0xFF00B4D8);
  static const Color paleGreenBg = Color(0xFFDEE7E2);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        if (args['isEmail'] != null) {
          _isEmail = args['isEmail'] as bool;
        }
        if (args['destination'] != null) {
          _destination = args['destination'] as String;
        }
        if (args['isResetPassword'] != null) {
          _isResetPassword = args['isResetPassword'] as bool;
        }
        if (args['isChangePhone'] != null) {
          _isChangePhone = args['isChangePhone'] as bool;
        }
        if (args['isChangeEmail'] != null) {
          _isChangeEmail = args['isChangeEmail'] as bool;
        }
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
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
            // Background grafis diagonal di bagian atas
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
                    const SizedBox(height: 30),

                    // Logo ECOWALK di bagian atas tengah
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

                    const SizedBox(height: 70),

                    // Header: Ikon centang + Teks VERIFIKASI
                    Row(
                      children: const [
                        Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'VERIFIKASI',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Baris Ikon HP Pesan + Deskripsi Tujuan Verifikasi
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'lib/images/phone_verification_icon.svg',
                          width: 24,
                          height: 30,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade900,
                                height: 1.35,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      'Periksa dan ketik kode verifikasi yang telah dikirimkan ke ',
                                ),
                                TextSpan(
                                  text: _destination != null &&
                                          _destination!.isNotEmpty
                                      ? _destination!
                                      : (_isEmail
                                          ? 'contohsample@gmail.com'
                                          : '+6212371923719238'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // 4 Kotak Input OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        return Container(
                          width: (screenSize.width - 48 - (3 * 12)) / 4,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFD1D5DB),
                              width: 1.2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) => _onOtpChanged(value, index),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // Teks Ganti Metode Verifikasi (No. HP <-> Email)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEmail = !_isEmail;
                          // Bersihkan OTP input saat ganti metode
                          for (final controller in _otpControllers) {
                            controller.clear();
                          }
                          _focusNodes[0].requestFocus();
                        });
                      },
                      child: Text(
                        _isEmail
                            ? 'Verifikasi menggunakan No. Hp'
                            : 'Verifikasi menggunakan Email',
                        style: const TextStyle(
                          color: accentBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tombol KIRIM
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isResetPassword) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/new-password',
                            );
                          } else if (_isChangePhone) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nomor telepon berhasil diverifikasi dan diubah'),
                                backgroundColor: primaryGreen,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          } else if (_isChangeEmail) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email berhasil diverifikasi dan diubah'),
                                backgroundColor: primaryGreen,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          } else {
                            // Arahkan ke Beranda setelah verifikasi registrasi berhasil
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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

                    const SizedBox(height: 20),

                    // Teks Kirim Ulang Kode
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Tindakan kirim ulang kode
                        },
                        child: const Text(
                          'Kirim Ulang Kode',
                          style: TextStyle(
                            color: primaryGreen,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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
      ..color = _VerificationPageState.paleGreenBg
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
