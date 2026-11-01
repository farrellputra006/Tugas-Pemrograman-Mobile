import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KrlPage extends StatelessWidget {
  const KrlPage({super.key, this.origin, this.destination});

  final String? origin;
  final String? destination;

  static const Color _green = Color(0xFF1B6A5A);
  static const Color _ink = Color(0xFF111827);
  static const Color _muted = Color(0xFF4B5563);
  static const Color _cardBg = Color(0xFFF9FAFB);
  static const Color _borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String displayOrigin =
        args?['origin'] as String? ?? origin ?? 'Lokasi Asal';
    final String displayDestination =
        args?['destination'] as String? ?? destination ?? 'Lokasi Tujuan';

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
            'Rekomendasi',
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
                // 1. HERO BANNER: Foto Kereta KRL Commuter Line + Badge "Termurah"
                const _KrlHero(),

                const SizedBox(height: 18),

                // 2. JUDUL TRANSPORTASI UMUM + HARGA & ESTIMASI WAKTU
                const _KrlSummary(),

                const SizedBox(height: 18),

                // 3. PETA / MAP
                _KrlMap(onPressed: () => _showMapMessage(context)),

                const SizedBox(height: 20),

                // 4. ANALISIS PERJALANAN (Naik Ojek Online & Taxi)
                const _KrlAnalysis(),

                const SizedBox(height: 20),

                // 5. SECTION: OPSI TRANSPORTASI UMUM
                _PublicTransportOptions(
                  onDetail: (name, duration, fare) => _showTransportDetail(
                    context,
                    name,
                    duration,
                    fare,
                    displayOrigin,
                    displayDestination,
                  ),
                ),

                const SizedBox(height: 20),

                // 6. TOMBOL PILIH TRANSPORTASI UMUM
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
                            'distance': '14.5 KM',
                            'transport': 'KRL Commuter Line',
                            'transportImage':
                                'lib/images/transport_krl_hero.jpg',
                            'transportPrice': 'Rp. 3.000 - 5.000',
                            'estimatedDuration': '35 Menit',
                          },
                        );
                      },
                      child: const Text(
                        'Pilih KRL Commuter Line • Rp. 5.000',
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

  void _showMapMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lokasi rute perjalanan transportasi umum siap dibuka.'),
        backgroundColor: _green,
        duration: Duration(milliseconds: 1400),
      ),
    );
  }

  void _showTransportDetail(
    BuildContext context,
    String name,
    String duration,
    String fare,
    String origin,
    String destination,
  ) {
    if (name.toLowerCase().contains('transjakarta')) {
      Navigator.pushNamed(
        context,
        '/transjakarta',
        arguments: {'origin': origin, 'destination': destination},
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _ink,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: _green),
                const SizedBox(width: 8),
                Text(
                  'Estimasi: $duration',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _green,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.payments_outlined, size: 16, color: _ink),
                const SizedBox(width: 8),
                Text(
                  'Tarif: $fare',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: _green, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pilihan ramah lingkungan dari $origin menuju $destination.',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: _green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    '/rekap-perjalanan',
                    arguments: {
                      'title': destination,
                      'origin': origin,
                      'dateTime': 'Hari ini • Segera Berangkat',
                      'address': destination,
                      'distance': '12.0 KM',
                      'transport': name,
                      'transportImage': 'lib/images/transport_krl_hero.jpg',
                      'transportPrice': fare,
                      'estimatedDuration': duration,
                    },
                  );
                },
                child: Text('Pilih $name'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. HERO BANNER dengan gambar KRL + chip "Termurah"
class _KrlHero extends StatelessWidget {
  const _KrlHero();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          height: 195,
          child: Image.asset(
            'lib/images/transport_krl_hero.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.asset(
              'lib/images/transport_krl.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFE4F1E8),
                child: Center(
                  child: Icon(Icons.train, size: 64, color: KrlPage._green),
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
                'Termurah',
                style: TextStyle(
                  color: KrlPage._green,
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
}

// 2. JUDUL TRANSPORTASI UMUM + HARGA & ESTIMASI WAKTU
class _KrlSummary extends StatelessWidget {
  const _KrlSummary();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRANSPORTASI UMUM',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: KrlPage._ink,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 8),
          _KrlInfoLine(
            icon: Icons.payments_outlined,
            text: 'Rp. 0 - 20.000',
          ),
          SizedBox(height: 5),
          _KrlInfoLine(
            icon: Icons.access_time_outlined,
            text: '1 Jam 45 Menit',
          ),
        ],
      ),
    );
  }
}

class _KrlInfoLine extends StatelessWidget {
  const _KrlInfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: KrlPage._ink),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: KrlPage._ink,
          ),
        ),
      ],
    );
  }
}

// 3. MAP CONTAINER
class _KrlMap extends StatelessWidget {
  const _KrlMap({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KrlPage._borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'lib/images/map_route.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: Color(0xFFE4F1E8),
                    child: Center(
                      child: Icon(
                        Icons.map_outlined,
                        size: 56,
                        color: KrlPage._green,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: KrlPage._green,
                      size: 16,
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
}

// 4. ANALISIS PERJALANAN
class _KrlAnalysis extends StatelessWidget {
  const _KrlAnalysis();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      decoration: BoxDecoration(
        color: KrlPage._cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KrlPage._borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analisis Perjalanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: KrlPage._ink,
            ),
          ),
          SizedBox(height: 16),
          _KrlComparison(
            title: 'Dibandingkan Naik Ojek Online',
            rows: [
              ['Waktu', '30 mnt Lebih lambat'],
              ['Hemat', 'Kendaraan Umum'],
              ['Kenyamanan', 'Taxi'],
            ],
          ),
          SizedBox(height: 12),
          Divider(height: 1, color: KrlPage._borderColor),
          SizedBox(height: 12),
          _KrlComparison(
            title: 'Dibandingkan Taxi',
            rows: [
              ['Waktu', '20-40 mnt Lebih cepat'],
              ['Hemat', 'Kendaraan Umum'],
              ['Kenyamanan', 'Taxi'],
            ],
          ),
        ],
      ),
    );
  }
}

class _KrlComparison extends StatelessWidget {
  const _KrlComparison({required this.title, required this.rows});

  final String title;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13.5,
            color: KrlPage._green,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        for (final row in rows) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  row[0],
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: KrlPage._muted,
                  ),
                ),
                Text(
                  row[1],
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: KrlPage._ink,
                  ),
                ),
              ],
            ),
          ),
          if (row != rows.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

// 5. OPSI TRANSPORTASI UMUM (TransJakarta, MRT, LRT, KRL, Mikrotrans)
class _PublicTransportOptions extends StatelessWidget {
  const _PublicTransportOptions({required this.onDetail});

  final Function(String name, String duration, String fare) onDetail;

  static const _items = [
    (
      'TransJakarta',
      '± 40 menit',
      'Rp. 3.500',
      Icons.directions_bus_rounded,
      Color(0xFF0284C7),
    ),
    (
      'MRT Jakarta',
      '± 25 menit',
      'Rp. 4.000 - 14.000',
      Icons.directions_subway_rounded,
      Color(0xFFE11D48),
    ),
    (
      'LRT Jabodetabek',
      '± 30 menit',
      'Rp. 5.000 - 20.000',
      Icons.tram_rounded,
      Color(0xFFD97706),
    ),
    (
      'KRL Commuter Line',
      '± 35 menit',
      'Rp. 3.000 - 5.000',
      Icons.train_rounded,
      Color(0xFF1B6A5A),
    ),
    (
      'Mikrotrans (JakLingko)',
      '± 50 menit',
      'Rp. 0 (Gratis)',
      Icons.airport_shuttle_rounded,
      Color(0xFF059669),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opsi Transportasi Umum',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: KrlPage._ink,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: KrlPage._cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KrlPage._borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < _items.length; i++) ...[
                  _TransportOption(item: _items[i], onDetail: onDetail),
                  if (i < _items.length - 1)
                    const Divider(height: 1, color: KrlPage._borderColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransportOption extends StatelessWidget {
  const _TransportOption({required this.item, required this.onDetail});

  final (String, String, String, IconData, Color) item;
  final Function(String name, String duration, String fare) onDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onDetail(item.$1, item.$2, item.$3),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.$4, color: item.$5, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: KrlPage._ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.$2,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: KrlPage._green,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onDetail(item.$1, item.$2, item.$3),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
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
