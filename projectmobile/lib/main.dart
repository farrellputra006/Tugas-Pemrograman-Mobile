import 'package:flutter/material.dart';
import 'package:projectmobile/about_us_page.dart';
import 'package:projectmobile/change_email_page.dart';
import 'package:projectmobile/change_password_page.dart';
import 'package:projectmobile/change_phone_page.dart';
import 'package:projectmobile/cuaca_page.dart';
import 'package:projectmobile/detail_ulasan_page.dart';
import 'package:projectmobile/detail_wisata_page.dart';
import 'package:projectmobile/edit_profile_page.dart';
import 'package:projectmobile/forgot_password_page.dart';
import 'package:projectmobile/home_page.dart';
import 'package:projectmobile/keberangkatan_page.dart';
import 'package:projectmobile/krl_page.dart';
import 'package:projectmobile/pemilihan_transportasi_page.dart';
import 'package:projectmobile/image_validation_page.dart';
import 'package:projectmobile/kategori_page.dart';
import 'package:projectmobile/komparasi_page.dart';
import 'package:projectmobile/login_page.dart';
import 'package:projectmobile/new_password_page.dart';
import 'package:projectmobile/notifikasi_page.dart';
import 'package:projectmobile/privacy_policy_page.dart';
import 'package:projectmobile/profile_page.dart';
import 'package:projectmobile/rating_wisata_page.dart';
import 'package:projectmobile/register_page.dart';
import 'package:projectmobile/ojek_online_page.dart';
import 'package:projectmobile/rekap_perjalanan_page.dart';
import 'package:projectmobile/rekomendasi_page.dart';
import 'package:projectmobile/reviews_page.dart';
import 'package:projectmobile/settings_page.dart';
import 'package:projectmobile/splash_page.dart';
import 'package:projectmobile/terakhir_dilihat_page.dart';
import 'package:projectmobile/terms_of_service_page.dart';
import 'package:projectmobile/transjakarta_page.dart';
import 'package:projectmobile/verification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecowalk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E604E)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/pemilihan-transportasi': (context) =>
            const PemilihanTransportasiPage(),
        '/': (context) => const SplashPage(),
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/lupa-password': (context) => const ForgotPasswordPage(),
        '/new-password': (context) => const NewPasswordPage(),
        '/reset-password': (context) => const NewPasswordPage(),
        '/verification': (context) => const VerificationPage(),
        '/home': (context) => const HomePage(),
        '/beranda': (context) => const HomePage(),
        '/detail-wisata': (context) => const DetailWisataPage(),
        '/detail': (context) => const DetailWisataPage(),
        '/rating-wisata': (context) => const RatingWisataPage(),
        '/beri-ulasan': (context) => const RatingWisataPage(),
        '/nilai-ulasan': (context) => const ReviewsPage(),
        '/reviews': (context) => const ReviewsPage(),
        '/ulasan': (context) => const ReviewsPage(),
        '/lihat-rating': (context) => const ReviewsPage(),
        '/detail-ulasan': (context) => const DetailUlasanPage(),
        '/detail-review': (context) => const DetailUlasanPage(),
        '/kategori': (context) => const KategoriPage(),
        '/category': (context) => const KategoriPage(),
        '/komparasi': (context) => const KomparasiPage(),
        '/perbandingan': (context) => const KomparasiPage(),
        '/bandingkan': (context) => const KomparasiPage(),
        '/compare': (context) => const KomparasiPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit-profile': (context) => const EditProfilePage(),
        '/image-validation': (context) => const ImageValidationPage(),
        '/validasi-gambar': (context) => const ImageValidationPage(),
        '/settings': (context) => const SettingsPage(),
        '/pengaturan': (context) => const SettingsPage(),
        '/change-phone': (context) => const ChangePhonePage(),
        '/ubah-nomor-hp': (context) => const ChangePhonePage(),
        '/change-email': (context) => const ChangeEmailPage(),
        '/ubah-email': (context) => const ChangeEmailPage(),
        '/change-password': (context) => const ChangePasswordPage(),
        '/ubah-kata-sandi': (context) => const ChangePasswordPage(),
        '/terms-of-service': (context) => const TermsOfServicePage(),
        '/ketentuan-layanan': (context) => const TermsOfServicePage(),
        '/privacy-policy': (context) => const PrivacyPolicyPage(),
        '/kebijakan-privasi': (context) => const PrivacyPolicyPage(),
        '/about-us': (context) => const AboutUsPage(),
        '/tentang-kami': (context) => const AboutUsPage(),
        '/cuaca': (context) => const CuacaPage(),
        '/weather': (context) => const CuacaPage(),
        '/notifikasi': (context) => const NotifikasiPage(),
        '/notification': (context) => const NotifikasiPage(),
        '/notifications': (context) => const NotifikasiPage(),
        '/ojek-online': (context) => const OjekOnlinePage(),
        '/transportasi-ojek': (context) => const OjekOnlinePage(),
        '/krl': (context) => const KrlPage(),
        '/krl-commuter': (context) => const KrlPage(),
        '/transportasi-krl': (context) => const KrlPage(),
        '/transportasi-umum': (context) => const KrlPage(),
        '/commuter-line': (context) => const KrlPage(),
        '/transjakarta': (context) => const TransjakartaPage(),
        '/trans-jakarta': (context) => const TransjakartaPage(),
        '/busway': (context) => const TransjakartaPage(),
        '/transportasi-bus': (context) => const TransjakartaPage(),
        '/keberangkatan': (context) => const KeberangkatanPage(),
        '/jadwal-keberangkatan': (context) => const KeberangkatanPage(),
        '/rekap-perjalanan': (context) => const RekapPerjalananPage(),
        '/rekap': (context) => const RekapPerjalananPage(),
        '/trip-summary': (context) => const RekapPerjalananPage(),
        '/detail-selesai': (context) => const RekapPerjalananPage(),
        '/terakhir-dilihat': (context) => const TerakhirDilihatPage(),
        '/recent': (context) => const TerakhirDilihatPage(),
        '/recently-viewed': (context) => const TerakhirDilihatPage(),
        '/rekomendasi': (context) => const RekomendasiPage(),
        '/recommendation': (context) => const RekomendasiPage(),
        '/rute': (context) => const RekomendasiPage(),
        '/cari-rute': (context) => const RekomendasiPage(),
      },
    );
  }
}
