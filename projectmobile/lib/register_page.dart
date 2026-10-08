import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  // Warna hijau primer identik dengan splash screen & ecowalk
  static const Color primaryGreen = Color(0xFF1E604E);
  // Warna biru muda untuk teks link persetujuan & navigasi masuk
  static const Color accentBlue = Color(0xFF00B4D8);

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required Widget prefixIcon,
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 13.5,
        color: Colors.grey.shade600,
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Teks "BUAT AKUN"
                  const Text(
                    'BUAT AKUN',
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Logo ECOWALK (ECOWA + Icon + K)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'ECOWA',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: SvgPicture.asset(
                          'lib/images/Vector.svg',
                          width: 38,
                          height: 40,
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
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 38),

                  // Input: Nama Pengguna
                  TextField(
                    controller: _usernameController,
                    decoration: _buildInputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF757575),
                        size: 22,
                      ),
                      hintText: 'Nama Pengguna',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Input: Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Color(0xFF757575),
                        size: 20,
                      ),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Input: Nomor Hp
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration(
                      prefixIcon: const Icon(
                        Icons.call,
                        color: Color(0xFF757575),
                        size: 20,
                      ),
                      hintText: 'Nomor Hp',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Input: Kata Sandi
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _buildInputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF757575),
                        size: 22,
                      ),
                      hintText: 'Kata Sandi',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF757575),
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Input: Konfirmasi Kata Sandi
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: _buildInputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF757575),
                        size: 22,
                      ),
                      hintText: 'Konfirmasi Kata Sandi',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF757575),
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Checkbox Persetujuan Syarat dan Ketentuan
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreeToTerms,
                          activeColor: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF9E9E9E),
                            width: 1.5,
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreeToTerms = !_agreeToTerms;
                            });
                          },
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF6B7280),
                                height: 1.35,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Saya telah membaca dan menyetujui ',
                                ),
                                TextSpan(
                                  text: 'persyaratan dan privasi pengguna',
                                  style: TextStyle(
                                    color: accentBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tombol BUAT AKUN
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aksi saat buat akun selesai, arahkan ke verifikasi
                        Navigator.pushNamed(context, '/verification');
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
                        'BUAT AKUN',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Footer: Sudah punya akun? Masuk
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          Text(
                            'Masuk',
                            style: TextStyle(
                              color: accentBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
