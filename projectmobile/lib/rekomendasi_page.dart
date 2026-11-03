import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RekomendasiPage extends StatefulWidget {
  final String? initialOrigin;
  final String? initialDestination;

  const RekomendasiPage({
    super.key,
    this.initialOrigin,
    this.initialDestination,
  });

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  // Tema warna hijau selaras dengan mockup Ecowalk
  static const Color primaryGreen = Color(0xFF1B5E50);
  static const Color textDark = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);

  late TextEditingController _originController;
  late TextEditingController _destinationController;

  bool _isRouteSearched = true;
  String _selectedTransportFilter = 'Semua'; // 'Semua', 'Umum', 'Pribadi', 'Hemat'

  // Data Rekomendasi Moda Transportasi Pilihan yang Bisa Langsung Dipilih
  final List<Map<String, dynamic>> _transportRecommendations = [
    {
      'id': 'krl',
      'title': 'KRL Commuter Line',
      'badge': 'Termurah',
      'badgeColor': Color(0xFF10B981),
      'fare': 'Rp. 3.000 - 5.000',
      'duration': '35 Menit',
      'tag': '🌱 Ramah Lingkungan',
      'image': 'lib/images/transport_krl_hero.jpg',
      'route': '/krl',
    },
    {
      'id': 'transjakarta',
      'title': 'TransJakarta (Busway)',
      'badge': 'Tarif Flat',
      'badgeColor': primaryGreen,
      'fare': 'Rp. 3.500 Flat',
      'duration': '40 Menit',
      'tag': '🚌 Jalur Khusus Bus',
      'image': 'lib/images/transport_transjakarta_hero.jpg',
      'route': '/transjakarta',
    },
    {
      'id': 'ojek',
      'title': 'Ojek Online',
      'badge': 'Tercepat',
      'badgeColor': Color(0xFF2563EB),
      'fare': 'Rp. 18.000 - 30.000',
      'duration': '20 Menit',
      'tag': '⚡ Bebas Macet',
      'image': 'lib/images/transport_ojek_online.jpg',
      'route': '/ojek-online',
    },
    {
      'id': 'taxi',
      'title': 'Taksi / Mobil Online',
      'badge': 'Paling Nyaman',
      'badgeColor': Color(0xFF8B5CF6),
      'fare': 'Rp. 35.000 - 60.000',
      'duration': '30 Menit',
      'tag': '✨ AC & Nyaman',
      'image': 'lib/images/transport_taxi.png',
      'route': '/pemilihan-transportasi',
    },
  ];

  // Pilihan Destinasi Populer (Hanya untuk rute & transportasi, TANPA pemesanan tiket)
  final List<Map<String, dynamic>> _popularDestinations = [
    {
      'id': 'dufan',
      'title': 'Dunia Fantasi (DUFAN)',
      'location': 'Ancol, Jakarta Utara',
      'distance': '1.68 KM',
      'image': 'lib/images/dufan.png',
      'transportHint': 'KRL • TransJakarta • Ojek',
    },
    {
      'id': 'moja',
      'title': 'Moja Museum',
      'location': 'Gelora Bung Karno, Senayan',
      'distance': '3.2 KM',
      'image': 'lib/images/moja_museum.png',
      'transportHint': 'MRT • TransJakarta • Ojek',
    },
    {
      'id': 'oceanpark',
      'title': 'Ocean Park BSD City',
      'location': 'Serpong, Tangerang',
      'distance': '8.5 KM',
      'image': 'lib/images/ocean_park.png',
      'transportHint': 'KRL Commuter • Taksi',
    },
    {
      'id': 'tmii',
      'title': 'Taman Mini Indonesia Indah',
      'location': 'Cipayung, Jakarta Timur',
      'distance': '3.84 KM',
      'image': 'lib/images/tmii.png',
      'transportHint': 'LRT • TransJakarta • Ojek',
    },
  ];

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController(text: widget.initialOrigin ?? '');
    _destinationController = TextEditingController(
      text: widget.initialDestination ?? '',
    );
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _onSearchRoute() {
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();

    if (origin.isEmpty || destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan masukkan lokasi asal dan tujuan terlebih dahulu',
          ),
          backgroundColor: primaryGreen,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isRouteSearched = true;
    });

    Navigator.pushNamed(
      context,
      '/pemilihan-transportasi',
      arguments: {'origin': origin, 'destination': destination},
    );
  }

  // Navigasi langsung ke moda transportasi terpilih
  void _navigateToTransportPage(String routeName) {
    final origin = _originController.text.isNotEmpty
        ? _originController.text
        : 'Lokasi Asal';
    final destination = _destinationController.text.isNotEmpty
        ? _destinationController.text
        : 'Lokasi Tujuan';

    Navigator.pushNamed(
      context,
      routeName,
      arguments: {
        'origin': origin,
        'destination': destination,
      },
    );
  }

  // Memilih destinasi lalu langsung membuka opsi transportasi menuju ke sana
  void _selectDestinationForTransport(Map<String, dynamic> item) {
    final destinationName = '${item['title']}, ${item['location']}';
    setState(() {
      _destinationController.text = destinationName;
      _isRouteSearched = true;
    });

    final origin = _originController.text.isNotEmpty
        ? _originController.text
        : 'Lokasi Anda Saat Ini';

    Navigator.pushNamed(
      context,
      '/pemilihan-transportasi',
      arguments: {
        'origin': origin,
        'destination': destinationName,
      },
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
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // 1. HEADER: Logo Ecowalk
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'lib/images/ecowalk.png',
                              height: 28,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Text(
                                'ECOWALK',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: primaryGreen,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 2. JUDUL HALAMAN
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'MAU KEMANA HARI INI?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 3. KARTU HIJAU INPUT PENCARIAN RUTE
                      _buildSearchCard(),

                      const SizedBox(height: 14),

                      // 4. TOMBOL CARI RUTE
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: _onSearchRoute,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Cari Rute',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 5. REKOMENDASI TRANSPORTASI (Pilihan Moda yang Bisa Langsung Dipilih)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rekomendasi Transportasi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F3EF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🌱 Eco-Friendly',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Kartu Horizontal Rekomendasi Transportasi (KRL, TransJakarta, Ojek, Taksi)
                      _buildTransportHorizontalList(),

                      const SizedBox(height: 26),

                      // 6. PILIHAN DESTINASI TUJUAN (Tanpa pesan tiket, langsung pilih transportasi)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pilihan Destinasi Tujuan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            Text(
                              'Pilih untuk cari rute',
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // List Destinasi Populer untuk Rute Transportasi
                      _buildDestinationHorizontalList(),

                      const SizedBox(height: 26),

                      // 7. SECTION PILIHAN TRANSPORTASI TERINCI
                      if (_isRouteSearched) ...[_buildTransportationSection()],
                    ],
                  ),
                ),
              ),

              // 8. BOTTOM NAVIGATION BAR (Identik Mockup dengan elevated tab Rekomendasi)
              _buildBottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Kartu Hijau dengan 2 Input Pill Putih
  Widget _buildSearchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Input 1: Masukan Lokasi Asal
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black87, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _originController,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Masukan Lokasi Asal',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_originController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _originController.clear()),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Input 2: Masukan Lokasi Tujuan
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.black87,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _destinationController,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Masukan Lokasi Tujuan',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_destinationController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _destinationController.clear()),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. HORIZONTAL CARDS: REKOMENDASI TRANSPORTASI YANG BISA LANGSUNG DIPILIH
  Widget _buildTransportHorizontalList() {
    return SizedBox(
      height: 185,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _transportRecommendations.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = _transportRecommendations[index];
          return GestureDetector(
            onTap: () => _navigateToTransportPage(item['route'] as String),
            child: Container(
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar Transportasi
                    Image.asset(
                      item['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.directions_bus, size: 40, color: Color(0xFF1B5E50)),
                      ),
                    ),

                    // Gradient Bawah
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 130,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.95),
                              Colors.black.withValues(alpha: 0.65),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Badge di Pojok Kanan Atas
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (item['badgeColor'] as Color).withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          item['badge'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Informasi Transportasi
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['fare'] as String,
                            style: const TextStyle(
                              color: Color(0xFF6EE7B7),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['duration'] as String,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Pilih',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 2. HORIZONTAL LIST: PILIHAN DESTINASI TUJUAN (Langsung untuk rute, tanpa tiket)
  Widget _buildDestinationHorizontalList() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _popularDestinations.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = _popularDestinations[index];
          return GestureDetector(
            onTap: () => _selectDestinationForTransport(item),
            child: Container(
              width: 154,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar Destinasi
                    Image.asset(
                      item['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.place, color: Colors.grey, size: 40),
                      ),
                    ),

                    // Gradient Overlay Bawah
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.92),
                              Colors.black.withValues(alpha: 0.65),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Badge Jarak di Pojok Kanan Atas
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item['distance'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Informasi Destinasi & Tombol Cari Transportasi
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFFEF4444),
                                size: 11,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  item['location'] as String,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Hint Moda Transportasi
                          Text(
                            item['transportHint'] as String,
                            style: const TextStyle(
                              color: Color(0xFF6EE7B7),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Aksi: Pilih Transportasi Ke Sini
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(
                              child: Text(
                                'Pilih Transportasi ➔',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 3. SECTION DAFTAR TRANSPORTASI TERINCI (DENGAN FILTER)
  Widget _buildTransportationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Rute & Tarif Transportasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Pilih transportasi umum atau pribadi terbaik',
                    style: TextStyle(fontSize: 11.5, color: textSecondary),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Filter Kategori Transportasi
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                const SizedBox(width: 8),
                _buildFilterChip('Transportasi Umum'),
                const SizedBox(width: 8),
                _buildFilterChip('Kendaraan Pribadi'),
                const SizedBox(width: 8),
                _buildFilterChip('Paling Hemat'),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Daftar Pilihan Transportasi Terinci
          if (_selectedTransportFilter == 'Semua' ||
              _selectedTransportFilter == 'Transportasi Umum' ||
              _selectedTransportFilter == 'Paling Hemat') ...[
            // 1. KRL Commuter Line
            _buildTransportOptionCard(
              type: 'Transportasi Umum',
              icon: Icons.train_outlined,
              iconBgColor: const Color(0xFFE0E7FF),
              iconColor: const Color(0xFF4338CA),
              title: 'KRL Commuter Line',
              routeText: 'Stasiun Nambo ➔ Transit Manggarai ➔ Stasiun Palmerah',
              estimation: '42 Menit • 14.5 KM',
              costText: 'Rp. 5.000',
              badgeText: 'Paling Ramah Lingkungan',
              badgeColor: const Color(0xFF10B981),
              onTapRoute: () {
                _navigateToTransportPage('/krl');
              },
            ),
            const SizedBox(height: 10),

            // 2. TransJakarta Busway
            _buildTransportOptionCard(
              type: 'Transportasi Umum',
              icon: Icons.directions_bus_outlined,
              iconBgColor: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFD97706),
              title: 'TransJakarta (Busway)',
              routeText: 'Halte Cibubur ➔ Koridor 9 (Pluit) ➔ Halte GBK',
              estimation: '50 Menit • 16.8 KM',
              costText: 'Rp. 3.500',
              badgeText: 'Tarif Paling Hemat',
              badgeColor: primaryGreen,
              onTapRoute: () {
                _navigateToTransportPage('/transjakarta');
              },
            ),
            const SizedBox(height: 10),
          ],

          if (_selectedTransportFilter == 'Semua' ||
              _selectedTransportFilter == 'Kendaraan Pribadi') ...[
            // 3. Motor / Ojek Online
            _buildTransportOptionCard(
              type: 'Kendaraan Pribadi',
              icon: Icons.two_wheeler_outlined,
              iconBgColor: const Color(0xFFD1FAE5),
              iconColor: const Color(0xFF059669),
              title: 'Motor / Ojek Online',
              routeText:
                  'Via Jl. Raya Bogor & Jl. Gatot Subroto (Bebas Ganjil Genap)',
              estimation: '28 Menit • 13.2 KM',
              costText: 'Rp. 18.000 - 24.000',
              badgeText: 'Waktu Tercepat',
              badgeColor: const Color(0xFF2563EB),
              onTapRoute: () {
                _navigateToTransportPage('/ojek-online');
              },
            ),
            const SizedBox(height: 10),

            // 4. Mobil Pribadi / Taksi
            _buildTransportOptionCard(
              type: 'Kendaraan Pribadi',
              icon: Icons.directions_car_outlined,
              iconBgColor: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF7E22CE),
              title: 'Mobil Pribadi / Taksi Online',
              routeText: 'Via Tol Jagorawi ➔ Keluar Semanggi (AC & Nyaman)',
              estimation: '34 Menit • 17.5 KM',
              costText: 'Rp. 35.000 (Tol + BBM)',
              badgeText: 'Paling Nyaman',
              badgeColor: const Color(0xFF8B5CF6),
              onTapRoute: () {
                _navigateToTransportPage('/pemilihan-transportasi');
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedTransportFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTransportFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryGreen : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildTransportOptionCard({
    required String type,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String routeText,
    required String estimation,
    required String costText,
    required String badgeText,
    required Color badgeColor,
    VoidCallback? onTapRoute,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        Text(
                          costText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      estimation,
                      style: const TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.alt_route, size: 14, color: Color(0xFF4B5563)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    routeText,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (onTapRoute != null) {
                    onTapRoute();
                    return;
                  }
                  if (title.toLowerCase().contains('ojek') ||
                      title.toLowerCase().contains('motor')) {
                    _navigateToTransportPage('/ojek-online');
                  } else if (title.toLowerCase().contains('krl') ||
                      title.toLowerCase().contains('commuter')) {
                    _navigateToTransportPage('/krl');
                  } else if (title.toLowerCase().contains('transjakarta') ||
                      title.toLowerCase().contains('busway') ||
                      title.toLowerCase().contains('bus')) {
                    _navigateToTransportPage('/transjakarta');
                  } else {
                    _navigateToTransportPage('/pemilihan-transportasi');
                  }
                },
                child: const Row(
                  children: [
                    Text(
                      'Pilih Rute',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: primaryGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar yang persis sama dengan mockup
  Widget _buildBottomNavigationBar() {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.transparent,
      child: SizedBox(
        height: 64 + bottomPadding,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Dark Green Bar Base
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 10,
              child: Container(
                color: primaryGreen,
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Row(
                  children: [
                    // Tab 1: BERANDA
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.home_outlined,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Tab 2: REKOMENDASI (Space reserved for elevated circle)
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(top: 26),
                          child: Text(
                            'REKOMENDASI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tab 3: REVIEW / CHAT
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/reviews');
                        },
                        child: const Center(
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Tab 4: PROFIL
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: const Center(
                          child: Icon(
                            Icons.person_outline,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab 2 Elevated Floating Circle (REKOMENDASI dengan shield icon)
            Positioned(
              left: MediaQuery.of(context).size.width * 0.25 +
                  (MediaQuery.of(context).size.width * 0.25 - 54) / 2,
              top: -14,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryGreen,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.shield_outlined,
                    color: primaryGreen,
                    size: 26,
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
