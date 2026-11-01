import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransjakartaPage extends StatefulWidget {
  final String? origin;
  final String? destination;

  const TransjakartaPage({
    super.key,
    this.origin,
    this.destination,
  });

  @override
  State<TransjakartaPage> createState() => _TransjakartaPageState();
}

class _TransjakartaPageState extends State<TransjakartaPage> {
  static const Color _green = Color(0xFF1B6A5A);
  static const Color _ink = Color(0xFF111827);
  static const Color _borderDark = Color(0xFF111827);

  // Status expand/collapse tiap section (default true sesuai Gambar ke-3)
  bool _isBiayaOpen = true;
  bool _isEstimasiOpen = true;
  bool _isKeberangkatanOpen = true;
  bool _isKepadatanOpen = true;
  bool _isRuteOpen = true;
  bool _isKelebihanOpen = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String displayOrigin =
        args?['origin'] as String? ?? widget.origin ?? 'Kedoya Selatan';
    final String displayDestination =
        args?['destination'] as String? ?? widget.destination ?? 'Monas';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _green,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: _green,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'Transportasi Umum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          titleSpacing: 0,
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO BANNER: Foto Bus TransJakarta + Badge "Rekomendasi"
                _buildHeroBanner(),

                const SizedBox(height: 18),

                // 2. JUDUL: TRANSJAKARTA
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'TRANSJAKARTA',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: _ink,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 3. DAFTAR ACCORDION KARTU
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // Kartu 1: Biaya
                      _buildAccordionCard(
                        title: 'Biaya',
                        isOpen: _isBiayaOpen,
                        onToggle: () =>
                            setState(() => _isBiayaOpen = !_isBiayaOpen),
                        content: const Text(
                          'Rp 3.500 (tarif flat TransJakarta)',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Kartu 2: Estimasi
                      _buildAccordionCard(
                        title: 'Estimasi',
                        isOpen: _isEstimasiOpen,
                        onToggle: () =>
                            setState(() => _isEstimasiOpen = !_isEstimasiOpen),
                        content: const Text(
                          '±60-75 menit (tergantung kondisi lalu lintas dan waktu tunggu)',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Kartu 3: Keberangkatan
                      _buildAccordionCard(
                        title: 'Keberangkatan',
                        isOpen: _isKeberangkatanOpen,
                        onToggle: () => setState(
                            () => _isKeberangkatanOpen = !_isKeberangkatanOpen),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Perkiraan keberangkatan dari Halte Duri Kepa:',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Pukul 18.00 WIB',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _ink,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Bisa berubah tergantung kepadatan lalu lintas',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 11,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/keberangkatan',
                                    arguments: {
                                      'origin': displayOrigin,
                                      'destination': displayDestination,
                                      'shelter': 'Halte Duri Kepa',
                                    },
                                  );
                                },
                                child: const Text(
                                  'Selengkapnya',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF38BDF8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Kartu 4: Informasi Kepadatan
                      _buildAccordionCard(
                        title: 'Informasi Kepadatan',
                        isOpen: _isKepadatanOpen,
                        onToggle: () => setState(
                            () => _isKepadatanOpen = !_isKepadatanOpen),
                        content: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151),
                              fontStyle: FontStyle.italic,
                            ),
                            children: [
                              TextSpan(
                                text: 'Kepadatan di Halte SSSSS tergolong ',
                              ),
                              TextSpan(
                                text: 'Rendah',
                                style: TextStyle(
                                  color: Color(0xFF16A34A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: '/'),
                              TextSpan(
                                text: 'Sedang',
                                style: TextStyle(
                                  color: Color(0xFFEAB308),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: '/'),
                              TextSpan(
                                text: 'Tinggi',
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Kartu 5: Rute yang dilalui
                      _buildAccordionCard(
                        title: 'Rute yang dilalui',
                        isOpen: _isRuteOpen,
                        onToggle: () =>
                            setState(() => _isRuteOpen = !_isRuteOpen),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dari Kedoya Selatan, naik mikrotrans atau ojek online menuju ke halte Kedoya Green Garden',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF374151),
                                height: 1.3,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 6,
                              ),
                              child: Text(
                                '⋮',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                            const Text(
                              'Naik Koridor 8 TransJakarta menuju Halte Harmoni',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF374151),
                                height: 1.3,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 6,
                              ),
                              child: Text(
                                '⋮',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                            const Text(
                              'Transit di Halte Harmoni, lalu naik ke Koridor 1 ke Halte Monas',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF374151),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Kartu 6: Kelebihan & Kekurangan (Warna Hijau Solid)
                      _buildGreenAccordionCard(
                        title: 'Kelebihan & Kekurangan',
                        isOpen: _isKelebihanOpen,
                        onToggle: () => setState(
                            () => _isKelebihanOpen = !_isKelebihanOpen),
                        content: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kelebihan',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '•  Biaya Terjangkau\n•  Jalur khusus bus mengurangi risiko terjebak macet',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Kekurangan',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '•  Perlu transit dan menunggu bus di setiap halte\n•  Kepadatan penumpang pada jam sibuk',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. TOMBOL PILIH RUTE INI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/rekap-perjalanan',
                          arguments: {
                            'title': displayDestination,
                            'origin': displayOrigin,
                            'dateTime': 'Hari ini • Segera Berangkat',
                            'address': displayDestination,
                            'distance': '16.8 KM',
                            'transport': 'TransJakarta',
                            'transportImage':
                                'lib/images/transport_transjakarta_hero.jpg',
                            'transportPrice': 'Rp. 3.500',
                            'estimatedDuration': '60-75 menit',
                          },
                        );
                      },
                      child: const Text(
                        'Pilih Rute TransJakarta • Rp. 3.500',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. HERO BANNER
  Widget _buildHeroBanner() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          height: 195,
          child: Image.asset(
            'lib/images/transport_transjakarta_hero.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.asset(
              'lib/images/transport_bus.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFE4F1E8),
                child: Center(
                  child: Icon(
                    Icons.directions_bus,
                    size: 64,
                    color: _green,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: -14,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Text(
                'Rekomendasi',
                style: TextStyle(
                  color: _green,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget Accordion Putih dengan border hitam tegas
  Widget _buildAccordionCard({
    required String title,
    required bool isOpen,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderDark, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _ink,
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _ink,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: content,
            ),
        ],
      ),
    );
  }

  // Widget Accordion Hijau Solid untuk "Kelebihan & Kekurangan"
  Widget _buildGreenAccordionCard({
    required String title,
    required bool isOpen,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: content,
            ),
        ],
      ),
    );
  }
}

