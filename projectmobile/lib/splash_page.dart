import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Berpindah ke halaman login setelah 3 detik jika SplashPage masih aktif
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna background hijau sesuai desain gambar
    const Color backgroundColor = Color(0xFF1E604E);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ECOWALK
                Image.asset(
                  'lib/images/ecowalk.png',
                  height: 44,
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 14),
                // Tagline
                const Text(
                  '"Bandingkan, pilih, liburan tanpa ragu !"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
