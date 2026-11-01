import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeberangkatanPage extends StatelessWidget {
  final String? origin;
  final String? destination;
  final String? shelter;

  const KeberangkatanPage({
    super.key,
    this.origin,
    this.destination,
    this.shelter,
  });

  static const Color _green = Color(0xFF1B6A5A);
  static const Color _ink = Color(0xFF111827);
  static const Color _badgeOrange = Color(0xFFF59E0B);
  static const Color _redAlert = Color(0xFFEF4444);

  final List<Map<String, dynamic>> _departures = const [
    {
      'isLive': true,
      'badgeText': 'Koridor',
      'routeText': 'Ta ➔ Kota',
      'timeValue': '11',
      'timeUnit': 'mnt',
      'statusText': 'Terlambat 11 mnt',
      'isDelayed': true,
    },
    {
      'isLive': false,
      'badgeText': 'Bus 2',
      'routeText': 'lorem ipsum ➔ blablabla',
      'timeValue': '23.23',
      'timeUnit': null,
      'statusText': 'Dijadwalkan',
      'isDelayed': false,
    },
    {
      'isLive': false,
      'badgeText': 'Bus 2',
      'routeText': 'lorem ipsum ➔ blablabla',
      'timeValue': '23.23',
      'timeUnit': null,
      'statusText': 'Dijadwalkan',
      'isDelayed': false,
    },
    {
      'isLive': false,
      'badgeText': 'Bus 2',
      'routeText': 'lorem ipsum ➔ blablabla',
      'timeValue': '23.23',
      'timeUnit': null,
      'statusText': 'Dijadwalkan',
      'isDelayed': false,
    },
    {
      'isLive': false,
      'badgeText': 'Bus 2',
      'routeText': 'lorem ipsum ➔ blablabla',
      'timeValue': '23.23',
      'timeUnit': null,
      'statusText': 'Dijadwalkan',
      'isDelayed': false,
    },
    {
      'isLive': false,
      'badgeText': 'Bus 2',
      'routeText': 'lorem ipsum ➔ blablabla',
      'timeValue': '23.23',
      'timeUnit': null,
      'statusText': 'Dijadwalkan',
      'isDelayed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: _green,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _green,
        appBar: AppBar(
          backgroundColor: _green,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text(
            'Keberangkatan',
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
              children: [
                // 1. PETA RUTE KEBERANGKATAN
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.asset(
                    'lib/images/map_keberangkatan.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Image.asset(
                      'lib/images/map_route.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFE5E7EB),
                        child: const Center(
                          child: Icon(
                            Icons.map,
                            size: 60,
                            color: _green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. DAFTAR KARTU KEBERANGKATAN (Sesuai Layout Gambar ke-2)
                Transform.translate(
                  offset: const Offset(0, -12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: List.generate(_departures.length, (index) {
                        final item = _departures[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildDepartureCard(context, item, index),
                        );
                      }),
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

  Widget _buildDepartureCard(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    final bool isLive = item['isLive'] as bool;
    final String timeValue = item['timeValue'] as String;
    final String? timeUnit = item['timeUnit'] as String?;
    final String badgeText = item['badgeText'] as String;
    final String routeText = item['routeText'] as String;
    final String statusText = item['statusText'] as String;
    final bool isDelayed = item['isDelayed'] as bool;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Jadwal $badgeText ($routeText) dipilih: $timeValue ${timeUnit ?? 'WIB'}',
              ),
              backgroundColor: _green,
              duration: const Duration(milliseconds: 1400),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x25000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris 1: "Keberangkatan" dan Waktu (11 mnt / 23.23)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keberangkatan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _ink,
                    ),
                  ),
                  if (timeUnit != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timeValue,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _ink,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          timeUnit,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      timeValue,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _ink,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 6),

              // Baris 2: Badge Oranye ("Koridor" / "Bus 2") + Rute Teks
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeOrange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: _ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      routeText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: _ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Baris 3: Status ("Terlambat 11 mnt" / "Dijadwalkan")
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isDelayed ? FontWeight.bold : FontWeight.w500,
                  color: isDelayed ? _redAlert : const Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 3),

              // Baris 4: Catatan Peringatan Lalu Lintas
              const Text(
                'Bisa berubah tergantung kepadatan lalu lintas',
                style: TextStyle(
                  fontSize: 10.5,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFF87171),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

