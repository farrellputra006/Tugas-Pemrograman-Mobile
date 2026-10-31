import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CuacaPage extends StatelessWidget {
  final String location;
  final String date;
  final String temperature;
  final String condition;

  const CuacaPage({
    super.key,
    this.location = 'Klapanunggal, Bogor',
    this.date = 'Minggu, 16 Februari 2025',
    this.temperature = '30°C',
    this.condition = 'Cerah Berawan',
  });

  // Warna tema sesuai referensi mockup cuaca
  static const Color appColorPrimary = Color(0xFF4A8173);
  static const Color backgroundColor = Color(0xFFDCE5E0);
  static const Color cardMetricColor = Color(0xFF437A6D);
  static const Color textDark = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF374151);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: appColorPrimary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appColorPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Kembali',
          ),
          title: const Text(
            'Cuaca',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP WEATHER OVERVIEW SECTION
                _buildWeatherOverview(context),

                const SizedBox(height: 18),

                // 2. 4 METRIC CARDS (2x2 GRID)
                _buildMetricCardsGrid(),

                const SizedBox(height: 22),

                // 3. HARI INI SECTION (HOURLY FORECAST)
                _buildHourlySection(),

                const SizedBox(height: 22),

                // 4. MINGGUAN SECTION (WEEKLY FORECAST)
                _buildWeeklySection(),

                const SizedBox(height: 22),

                // 5. AKTIVITAS HARIAN SECTION
                _buildDailyActivities(context),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Top weather overview with city, temperature, condition, and sun-cloud illustration
  Widget _buildWeatherOverview(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left info texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prakiraan Cuaca',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textSecondary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                temperature,
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                condition,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
            ],
          ),
        ),

        // Right side: Weather Illustration
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Image.asset(
            'lib/images/weather_icon.png',
            width: 135,
            height: 135,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.wb_sunny_rounded,
                size: 110,
                color: Colors.amber,
              );
            },
          ),
        ),
      ],
    );
  }

  // 2. 2x2 Metric cards: Kelembapan, Kecepatan Angin, Kualitas Udara, Kecepatan Angin
  Widget _buildMetricCardsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.water_drop_outlined,
                label: 'Kelembapan',
                value: '92%',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.air,
                label: 'Kecepatan Angin',
                value: '0 Km/Jam',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.waves,
                label: 'Kualitas Udara',
                value: '39.1',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.explore_outlined,
                label: 'Kecepatan Angin',
                value: '0 Km/Jam',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardMetricColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Hourly Forecast ("Hari ini")
  Widget _buildHourlySection() {
    final hourlyItems = [
      {'time': 'Sekarang', 'temp': '30°C'},
      {'time': '07:00', 'temp': '30°C'},
      {'time': '10:00', 'temp': '31°C'},
      {'time': '13:00', 'temp': '33°C'},
      {'time': '16:00', 'temp': '31°C'},
      {'time': '19:00', 'temp': '28°C'},
      {'time': '22:00', 'temp': '26°C'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hari ini',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: hourlyItems.map((item) {
              return Container(
                width: 76,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/images/weather_icon.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.wb_sunny_rounded, size: 36, color: Colors.amber),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['temp']!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['time']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 4. Weekly Forecast ("Mingguan")
  Widget _buildWeeklySection() {
    final weeklyItems = [
      {'day': 'Hari Ini', 'condition': 'Cerah Berawan', 'range': '30°C / 20°C'},
      {'day': 'Besok', 'condition': 'Cerah Berawan', 'range': '30°C / 20°C'},
      {'day': 'Selasa', 'condition': 'Cerah Berawan', 'range': '30°C / 20°C'},
      {'day': 'Rabu', 'condition': 'Cerah Berawan', 'range': '30°C / 20°C'},
      {'day': 'Kamis', 'condition': 'Cerah Berawan', 'range': '30°C / 20°C'},
      {'day': 'Jumat', 'condition': 'Cerah Berawan', 'range': '30°C / 20°C'},
      {'day': 'Sabtu', 'condition': 'Cerah Berawan', 'range': '30°C / 20°C'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mingguan',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: weeklyItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == weeklyItems.length - 1;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 66,
                      child: Text(
                        item['day']!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'lib/images/weather_icon.png',
                      width: 26,
                      height: 26,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.wb_sunny_rounded, size: 22, color: Colors.amber),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        item['condition']!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      item['range']!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 5. Aktivitas Harian Section
  Widget _buildDailyActivities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Harian',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 14),
        // Item 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.sentiment_very_satisfied,
              size: 28,
              color: textDark,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Berjalan-jalan adalah pilihan terbaik saat ini !',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/kategori');
                    },
                    child: const Text(
                      'Lihat Destinasi Wisata',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0284C7),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Item 2
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.umbrella_outlined,
              size: 28,
              color: textDark,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Jangan lupa bawa payung untuk berjaga- jaga',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: textDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Item 3
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.video_camera_back_outlined,
              size: 28,
              color: textDark,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Aktivitas outdoor direkomendasikan',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: textDark,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
