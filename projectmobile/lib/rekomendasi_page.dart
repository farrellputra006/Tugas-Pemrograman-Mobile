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
  String _selectedTransportFilter =
      'Semua'; // 'Semua', 'Umum', 'Pribadi', 'Hemat'

  final List<Map<String, dynamic>> _destinationRecommendations = [
    {
      'id': 'moja',
      'title': 'Moja Museum',
      'location': 'Jakarta Pusat',
      'price': 'Mulai dari Rp. 136.500',
      'rating': 4.5,
      'image': 'lib/images/moja_museum.png',
      'address': 'Gelora Bung Karno, Main Stadium, Jl. Gerbang Pemuda No.1, Jakarta Pusat',
      'description': 'Moja Museum adalah ruang seni interaktif kekinian dengan instalasi visual estetik, roller skating (RoJA by MoJA), dan spot foto menarik untuk anak muda dan keluarga.',
      'openHours': '11:00 - 19:30',
      'distance': '3.2 KM',
    },
    {
      'id': 'oceanpark',
      'title': 'Ocean Park BSD City Serpong',
      'location': 'Tangerang',
      'price': 'Mulai dari Rp. 65.000',
      'rating': 4.5,
      'image': 'lib/images/ocean_park.png',
      'address': 'CBD Area, Jl. Pahlawan Seribu, Lengkong Gudang, Kec. Serpong, Tangerang Selatan 15310',
      'description': 'Ocean Park Water Adventure BSD City adalah taman rekreasi air tematik dengan wahana kolam ombak, seluncuran air menantang, kolam arus, dan area bermain anak.',
      'openHours': '11:00 - 16:00',
      'distance': '8.5 KM',
    },
    {
      'id': 'dufan',
      'title': 'Dunia Fantasi (DUFAN)',
      'location': 'Ancol, Jakarta Utara',
      'price': 'Mulai dari Rp. 200.000',
      'rating': 4.8,
      'image': 'lib/images/dufan.png',
      'address': 'Jl. Lodan Timur No.7, Ancol, Pademangan, Jakarta Utara',
      'description': 'Taman hiburan outdoor terbesar dengan beragam wahana atraktif dan menantang adrenalin seperti Halilintar, Tornado, Kora-kora, dan Bianglala.',
      'openHours': '10:00 - 22:00',
      'distance': '1.68 KM',
    },
    {
      'id': 'tmii',
      'title': 'Taman Mini Indonesia Indah',
      'location': 'Jakarta Timur',
      'price': 'Mulai dari Rp. 25.000',
      'rating': 4.8,
      'image': 'lib/images/tmii.png',
      'address': 'Jl. Raya Taman Mini, Cipayung, Jakarta Timur',
      'description': 'Kawasan taman wisata bertema budaya Indonesia dengan anjungan daerah representatif seluruh nusantara, museum, dan kereta gantung.',
      'openHours': '06:00 - 20:00',
      'distance': '3.84 KM',
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

  void _selectDestinationFromCard(Map<String, dynamic> item) {
    setState(() {
      _destinationController.text = '${item['title']}, ${item['location']}';
      _isRouteSearched = true;
    });
  }

  void _openDetailWisata(Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/detail-wisata',
      arguments: {
        'id': item['id'],
        'title': item['title'],
        'rating': '${item['rating']}',
        'reviewsCount': '12.450 Ulasan',
        'openHours': item['openHours'] ?? '10:00 - 20:00',
        'isOpen': true,
        'address': item['address'] ?? item['location'],
        'description': item['description'] ?? '',
        'priceRange': item['price'],
        'distance': item['distance'] ?? '3.5 KM',
        'heroImage': item['image'],
        'mapImage': 'lib/images/map_dufan.png',
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

                      const SizedBox(height: 26),

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

                      // 5. SECTION REKOMENDASI TUJUAN
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Rekomendasi Tujuan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // List Horizontal Kartu Rekomendasi
                      _buildDestinationHorizontalList(),

                      const SizedBox(height: 28),

                      // 6. SECTION REKOMENDASI TRANSPORTASI (UMUM VS PRIBADI)
                      if (_isRouteSearched) ...[_buildTransportationSection()],
                    ],
                  ),
                ),
              ),

              // 7. BOTTOM NAVIGATION BAR (Identik Mockup dengan elevated tab Rekomendasi)
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

  // Horizontal Card List: Moja Museum & Ocean Park BSD City Serpong
  Widget _buildDestinationHorizontalList() {
    return SizedBox(
      height: 228,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _destinationRecommendations.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = _destinationRecommendations[index];
          return _buildDestinationCard(item);
        },
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _openDetailWisata(item),
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
                  child: const Icon(Icons.image, color: Colors.grey, size: 40),
                ),
              ),

              // Gradient Overlay Bawah untuk keterbacaan teks
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

              // Informasi Kartu
              Positioned(
                left: 10,
                right: 10,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul Destinasi
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

                    // Lokasi (Pin merah)
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

                    const SizedBox(height: 2),

                    // Harga Mulai
                    Text(
                      item['price'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Rating Bintang & Link Lebih Lanjut
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Bintang Kuning
                        Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFBBF24),
                                size: 11,
                              ),
                            const Icon(
                              Icons.star_half,
                              color: Color(0xFFFBBF24),
                              size: 11,
                            ),
                          ],
                        ),

                        // Tombol "Lebih Lanjut >"
                        GestureDetector(
                          onTap: () => _openDetailWisata(item),
                          child: const Text(
                            'Lebih Lanjut ›',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tombol Pin Cepat untuk pasang ke rute tujuan
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _selectDestinationFromCard(item),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.navigation,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Rekomendasi Pilihan Transportasi Umum dan Pribadi
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
                    'Pilihan Transportasi',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

          // Daftar Pilihan Transportasi
          if (_selectedTransportFilter == 'Semua' ||
              _selectedTransportFilter == 'Transportasi Umum' ||
              _selectedTransportFilter == 'Paling Hemat') ...[
            // 1. KRL Commuter Line / MRT
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
                Navigator.pushNamed(
                  context,
                  '/krl',
                  arguments: {
                    'origin': _originController.text.isNotEmpty
                        ? _originController.text
                        : 'Lokasi Asal',
                    'destination': _destinationController.text.isNotEmpty
                        ? _destinationController.text
                        : 'Lokasi Tujuan',
                  },
                );
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
                Navigator.pushNamed(
                  context,
                  '/transjakarta',
                  arguments: {
                    'origin': _originController.text.isNotEmpty
                        ? _originController.text
                        : 'Lokasi Asal',
                    'destination': _destinationController.text.isNotEmpty
                        ? _destinationController.text
                        : 'Lokasi Tujuan',
                  },
                );
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
                Navigator.pushNamed(
                  context,
                  '/ojek-online',
                  arguments: {
                    'origin': _originController.text.isNotEmpty
                        ? _originController.text
                        : 'Lokasi Asal',
                    'destination': _destinationController.text.isNotEmpty
                        ? _destinationController.text
                        : 'Lokasi Tujuan',
                  },
                );
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
                const Icon(Icons.alt_route, size: 14, color: textSecondary),
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
                  // Khusus Motor/Ojek Online → halaman detail ojek online
                  if (title.toLowerCase().contains('ojek') ||
                      title.toLowerCase().contains('motor')) {
                    Navigator.pushNamed(
                      context,
                      '/ojek-online',
                      arguments: {
                        'origin': _originController.text.isNotEmpty
                            ? _originController.text
                            : 'Lokasi Asal',
                        'destination': _destinationController.text.isNotEmpty
                            ? _destinationController.text
                            : 'Lokasi Tujuan',
                      },
                    );
                  } else if (title.toLowerCase().contains('krl') ||
                      title.toLowerCase().contains('commuter')) {
                    Navigator.pushNamed(
                      context,
                      '/krl',
                      arguments: {
                        'origin': _originController.text.isNotEmpty
                            ? _originController.text
                            : 'Lokasi Asal',
                        'destination': _destinationController.text.isNotEmpty
                            ? _destinationController.text
                            : 'Lokasi Tujuan',
                      },
                    );
                  } else if (title.toLowerCase().contains('transjakarta') ||
                      title.toLowerCase().contains('busway') ||
                      title.toLowerCase().contains('bus')) {
                    Navigator.pushNamed(
                      context,
                      '/transjakarta',
                      arguments: {
                        'origin': _originController.text.isNotEmpty
                            ? _originController.text
                            : 'Lokasi Asal',
                        'destination': _destinationController.text.isNotEmpty
                            ? _destinationController.text
                            : 'Lokasi Tujuan',
                      },
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      '/pemilihan-transportasi',
                      arguments: {
                        'origin': _originController.text,
                        'destination': _destinationController.text,
                        'transport': title,
                      },
                    );
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

  // Bottom Navigation Bar yang persis sama dengan gambar referensi
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
              left:
                  MediaQuery.of(context).size.width * 0.25 +
                  (MediaQuery.of(context).size.width * 0.25 - 54) / 2,
              top: -14,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryGreen, width: 4),
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
