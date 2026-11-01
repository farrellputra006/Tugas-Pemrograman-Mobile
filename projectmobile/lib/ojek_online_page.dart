import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OjekOnlinePage extends StatelessWidget {
  const OjekOnlinePage({super.key, this.origin, this.destination});

  final String? origin;
  final String? destination;

  static const _green = Color(0xFF1B6A5A);
  static const _ink = Color(0xFF111111);
  static const _muted = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          titleSpacing: 0,
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeroImage(),
                const SizedBox(height: 13),
                const _TripSummary(),
                const SizedBox(height: 24),
                _MapPreview(onPressed: () => _showMapMessage(context)),
                const SizedBox(height: 31),
                const _TravelAnalysis(),
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
        content: Text('Lokasi perjalanan siap dilihat di peta.'),
        duration: Duration(milliseconds: 1400),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          height: 180,
          child: Image.asset(
            'lib/images/transport_ojek_online.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: Color(0xFFE4F1E8),
              child: Center(
                child: Icon(
                  Icons.two_wheeler,
                  size: 64,
                  color: OjekOnlinePage._green,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: -15,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Tercepat',
                style: TextStyle(
                  color: OjekOnlinePage._green,
                  fontSize: 12,
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

class _TripSummary extends StatelessWidget {
  const _TripSummary();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OJEK ONLINE',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: OjekOnlinePage._ink,
            ),
          ),
          SizedBox(height: 9),
          _InfoLine(icon: Icons.payments_outlined, text: 'Rp. 30.000 - 45.000'),
          SizedBox(height: 4),
          _InfoLine(icon: Icons.access_time_outlined, text: '20 Menit'),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: OjekOnlinePage._ink),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: OjekOnlinePage._ink),
        ),
      ],
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: double.infinity,
            height: 208,
            child: Image.asset(
              'lib/images/map_route.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFE4F1E8),
                child: Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 56,
                    color: OjekOnlinePage._green,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TravelAnalysis extends StatelessWidget {
  const _TravelAnalysis();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 17),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 4,
            offset: Offset(0, 3),
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
              fontWeight: FontWeight.w700,
              color: OjekOnlinePage._ink,
            ),
          ),
          SizedBox(height: 18),
          _Comparison(
            title: 'Dibandingkan Naik Taxi',
            rows: [
              ['Waktu', '5 mnt Lebih cepat'],
              ['Hemat', 'Ojek Online'],
              ['Kenyamanan', 'Taxi'],
            ],
          ),
          Divider(height: 18, color: Color(0xFFD3D3D3)),
          _Comparison(
            title: 'Dibandingkan Kendaraan Umum',
            rows: [
              ['Waktu', '15 mnt Lebih lambat'],
              ['Hemat', 'Kendaraan Umum'],
              ['Kenyamanan', 'Taxi'],
            ],
          ),
        ],
      ),
    );
  }
}

class _Comparison extends StatelessWidget {
  const _Comparison({required this.title, required this.rows});

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
            fontSize: 14,
            color: OjekOnlinePage._green,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        for (final row in rows) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row[0],
                style: const TextStyle(
                  fontSize: 14,
                  color: OjekOnlinePage._muted,
                ),
              ),
              Flexible(
                child: Text(
                  row[1],
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    color: OjekOnlinePage._ink,
                  ),
                ),
              ),
            ],
          ),
          if (row != rows.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}
