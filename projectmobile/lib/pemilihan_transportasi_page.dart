import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PemilihanTransportasiPage extends StatefulWidget {
  final String? initialOrigin;
  final String? initialDestination;
  final String? selectedVehicle;

  const PemilihanTransportasiPage({
    super.key,
    this.initialOrigin,
    this.initialDestination,
    this.selectedVehicle,
  });

  @override
  State<PemilihanTransportasiPage> createState() =>
      _PemilihanTransportasiPageState();
}

class _PemilihanTransportasiPageState extends State<PemilihanTransportasiPage> {
  // Warna tema identik dengan mockup Ecowalk (#1A6556)
  static const Color primaryGreen = Color(0xFF1A6556);
  static const Color textDark = Color(0xFF111827);

  late String _origin;
  late String _destination;
  int _selectedModeIndex = 2; // Default: Motor (4 menit)
  int _selectedVehicleIndex = 0; // Default: Ojek Online

  final List<Map<String, dynamic>> _travelModes = [
    {
      'icon': Icons.directions_walk,
      'label': '13 menit',
      'mode': 'Jalan Kaki',
      'distance': '1.1 KM',
      'calories': '65 kcal',
    },
    {
      'icon': Icons.directions_car,
      'label': '5 menit',
      'mode': 'Mobil / Taksi',
      'distance': '3.2 KM',
      'route': 'Via Jl. Transyogi',
    },
    {
      'icon': Icons.two_wheeler,
      'label': '4 menit',
      'mode': 'Motor / Ojek',
      'distance': '2.8 KM',
      'route': 'Rute Tercepat',
    },
    {
      'icon': Icons.directions_bus,
      'label': '18 menit',
      'mode': 'Transportasi Umum',
      'distance': '3.5 KM',
      'route': 'Angkot / Bus Feeder',
    },
  ];

  final List<Map<String, dynamic>> _vehicleOptions = [
    {
      'id': 'ojek',
      'title': 'Ojek Online',
      'subtitle': 'Gojek, Grab, Maxim',
      'description': 'Nyaman, dan cepat',
      'image': 'lib/images/transport_ojek_online.jpg',
      'price': 'Rp. 14.000',
      'duration': '4 menit',
      'providerList': ['Gojek', 'GrabBike', 'Maxim Motor'],
    },
    {
      'id': 'umum',
      'title': 'Transportasi Umum',
      'subtitle': 'Bus, KRL, MRT, LRT',
      'description': 'Hemat, dan murah',
      'image': 'lib/images/transport_krl.jpg',
      'price': 'Rp. 3.500',
      'duration': '18 menit',
      'providerList': ['KRL Commuter', 'TransJakarta', 'LRT Jabodebek'],
    },
    {
      'id': 'taxi',
      'title': 'Taxi',
      'subtitle': 'Blue Bird, GrabCar, GoCar',
      'description': 'Efisien, dan nyaman',
      'image': 'lib/images/transport_taxi.png',
      'price': 'Rp. 28.000',
      'duration': '5 menit',
      'providerList': ['Bluebird Taxi', 'GrabCar', 'GoCar'],
    },
    {
      'id': 'bus',
      'title': 'Bus TransJakarta',
      'subtitle': 'Mikrotrans & Bus Rapid',
      'description': 'Ramah lingkungan',
      'image': 'lib/images/transport_bus.jpg',
      'price': 'Rp. 3.500',
      'duration': '20 menit',
      'providerList': ['Koridor Utama', 'RoyalTrans', 'JakLingko'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _origin = widget.initialOrigin ?? 'KLAPANUNGGAL';
    _destination = widget.initialDestination ?? 'Trans Studio Cibubur';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['origin'] != null && (args['origin'] as String).isNotEmpty) {
        _origin = args['origin'] as String;
      }
      if (args['destination'] != null &&
          (args['destination'] as String).isNotEmpty) {
        _destination = args['destination'] as String;
      }
      if (args['transport'] != null) {
        final transportName = (args['transport'] as String).toLowerCase();
        for (int i = 0; i < _vehicleOptions.length; i++) {
          if (_vehicleOptions[i]['title'].toString().toLowerCase().contains(
                transportName,
              ) ||
              transportName.contains(_vehicleOptions[i]['id'].toString())) {
            _selectedVehicleIndex = i;
            break;
          }
        }
      }
    }
  }

  void _navigateToRekapPerjalanan() {
    final chosenVehicle = _vehicleOptions[_selectedVehicleIndex];

    // Jika Ojek Online dipilih, navigasi ke halaman detail Ojek Online
    if (chosenVehicle['id'] == 'ojek') {
      Navigator.pushNamed(
        context,
        '/ojek-online',
        arguments: {'origin': _origin, 'destination': _destination},
      );
      return;
    }

    if (chosenVehicle['id'] == 'umum') {
      Navigator.pushNamed(
        context,
        '/krl',
        arguments: {'origin': _origin, 'destination': _destination},
      );
      return;
    }

    if (chosenVehicle['id'] == 'bus' ||
        chosenVehicle['title'].toString().toLowerCase().contains('transjakarta') ||
        chosenVehicle['title'].toString().toLowerCase().contains('bus')) {
      Navigator.pushNamed(
        context,
        '/transjakarta',
        arguments: {'origin': _origin, 'destination': _destination},
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/rekap-perjalanan',
      arguments: {
        'id': 'trans_studio',
        'title': _destination,
        'origin': _origin,
        'dateTime': 'Hari ini • Segera Berangkat',
        'address': 'Jl. Alternatif Cibubur No.230, Harjamukti, Kec. Cimanggis, Kota Depok',
        'distance': _travelModes[_selectedModeIndex]['distance'] ?? '2.8 KM',
        'transport': chosenVehicle['title'],
        'transportImage': chosenVehicle['image'],
        'transportPrice': chosenVehicle['price'],
        'estimatedDuration': chosenVehicle['duration'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: primaryGreen,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryGreen,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Kembali',
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
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. KARTU TITIK AWAL & TITIK AKHIR (HIJAU MOCKUP)
                _buildOriginDestinationCard(),

                const SizedBox(height: 12),

                // 2. LOGO ECOWALK
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'lib/images/ecowalk.png',
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Text(
                      'ECOWALK',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: primaryGreen,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 3. BARIS CHIP ESTIMASI WAKTU MODA TRANSPORTASI (Walking, Car, Motor, Bus)
                _buildTravelModesChips(),

                const SizedBox(height: 14),

                // 4. MAPS / PETA RUTE
                _buildMapContainer(),

                const SizedBox(height: 18),

                // 5. SECTION: OPSI KENDARAAN
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Opsi Kendaraan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Kartu Pilihan Kendaraan (Ojek Online, Transportasi Umum, Taxi)
                _buildVehicleOptionsList(),

                const SizedBox(height: 18),

                // 6. TIPS BANNER HIJAU (Mau cepat & murah, dll.)
                _buildTipsBanner(),

                const SizedBox(height: 16),

                // 7. TOMBOL AKSI: PESAN / PILIH RUTE SEKARANG
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _navigateToRekapPerjalanan,
                      child: Text(
                        'Pilih ${_vehicleOptions[_selectedVehicleIndex]['title']} • ${_vehicleOptions[_selectedVehicleIndex]['price']}',
                        style: const TextStyle(
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

  // 1. KARTU TITIK AWAL & TITIK AKHIR
  Widget _buildOriginDestinationCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Garis Indikator Rute (Titik Putih, Garis Putus-putus, Ikon Pin)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 3),
              CustomPaint(
                size: const Size(2, 24),
                painter: _DottedLinePainter(),
              ),
              const SizedBox(height: 3),
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),

          const SizedBox(width: 14),

          // Teks Titik Awal & Titik Akhir
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titik Awal
                const Text(
                  'Titik Awal',
                  style: TextStyle(color: Colors.white70, fontSize: 9.5),
                ),
                const SizedBox(height: 1),
                Text(
                  _origin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Garis Pembatas Putih
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.35),
                ),

                const SizedBox(height: 8),

                // Titik Akhir
                const Text(
                  'Titik Akhir',
                  style: TextStyle(color: Colors.white70, fontSize: 9.5),
                ),
                const SizedBox(height: 1),
                Text(
                  _destination,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. BARIS CHIP MODA TRANSPORTASI
  Widget _buildTravelModesChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_travelModes.length, (index) {
          final mode = _travelModes[index];
          final isSelected = _selectedModeIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedModeIndex = index;
                  // Auto sync kendaraan yang cocok jika motor/mobil/bus dipilih
                  if (index == 2) _selectedVehicleIndex = 0; // Motor
                  if (index == 1) _selectedVehicleIndex = 2; // Mobil/Taxi
                  if (index == 3) _selectedVehicleIndex = 1; // Bus/KRL
                });
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: index < _travelModes.length - 1 ? 6 : 0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE8F3EF)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? primaryGreen : const Color(0xFFE5E7EB),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      mode['icon'] as IconData,
                      size: 15,
                      color: isSelected ? primaryGreen : Colors.black87,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        mode['label'] as String,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected ? primaryGreen : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 4. MAPS PETA RUTE
  Widget _buildMapContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Gambar Peta Monas/Gambir sesuai mockup
            Image.asset(
              'lib/images/map_route.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 200,
                color: const Color(0xFFE5E7EB),
                child: const Center(
                  child: Icon(Icons.map, size: 50, color: Colors.grey),
                ),
              ),
            ),

            // Badge rute aktif di pojok kiri atas
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.near_me, size: 12, color: primaryGreen),
                    const SizedBox(width: 4),
                    Text(
                      '${_travelModes[_selectedModeIndex]['mode']} • ${_travelModes[_selectedModeIndex]['label']}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol Perbesar / Navigasi di pojok kanan bawah
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Membuka mode peta navigasi rute...'),
                      backgroundColor: primaryGreen,
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
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
                    color: primaryGreen,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 5. LIST KARTU OPSI KENDARAAN (Ojek Online, Transportasi Umum, Taxi)
  Widget _buildVehicleOptionsList() {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _vehicleOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _vehicleOptions[index];
          final isSelected = _selectedVehicleIndex == index;

          return GestureDetector(
            onTap: () {
              // Jika sudah terpilih dan tap lagi → langsung navigasi ke detail
              if (item['id'] == 'ojek') {
                Navigator.pushNamed(
                  context,
                  '/ojek-online',
                  arguments: {'origin': _origin, 'destination': _destination},
                );
                return;
              }
              if (item['id'] == 'umum') {
                Navigator.pushNamed(
                  context,
                  '/krl',
                  arguments: {'origin': _origin, 'destination': _destination},
                );
                return;
              }
              if (item['id'] == 'bus' ||
                  item['title'].toString().toLowerCase().contains('transjakarta')) {
                Navigator.pushNamed(
                  context,
                  '/transjakarta',
                  arguments: {'origin': _origin, 'destination': _destination},
                );
                return;
              }
              setState(() {
                _selectedVehicleIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 116,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? primaryGreen : Colors.transparent,
                  width: isSelected ? 2.5 : 0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? primaryGreen.withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar Kendaraan
                    Image.asset(
                      item['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: Colors.grey.shade400,
                        child: const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Gradient Overlay Bawah untuk keterbacaan teks
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 85,
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

                    // Teks Info Kendaraan persis pada mockup
                    Positioned(
                      left: 7,
                      right: 7,
                      bottom: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            item['subtitle'] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item['description'] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 7.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Checklist badge jika terpilih
                    if (isSelected)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 11,
                          ),
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

  // 6. TIPS BANNER HIJAU
  Widget _buildTipsBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTipRow('Mau cepat & murah?', 'Ojek Online', 0),
          const SizedBox(height: 8),
          _buildTipRow('Mau murah banget?', 'Kendaraan Umum', 1),
          const SizedBox(height: 8),
          _buildTipRow('Mau nyaman & santai?', 'Taksi', 2),
        ],
      ),
    );
  }

  Widget _buildTipRow(
    String question,
    String recommendation,
    int vehicleIndex,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedVehicleIndex = vehicleIndex;
        });
        // Jika Ojek Online, navigasi langsung ke detail
        if (vehicleIndex == 0) {
          Navigator.pushNamed(
            context,
            '/ojek-online',
            arguments: {'origin': _origin, 'destination': _destination},
          );
        } else if (vehicleIndex == 1) {
          Navigator.pushNamed(
            context,
            '/krl',
            arguments: {'origin': _origin, 'destination': _destination},
          );
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Expanded(
              flex: 11,
              child: Text(
                question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Text('👉', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 8),
            Expanded(
              flex: 10,
              child: Text(
                recommendation,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter untuk Garis Titik-titik Penghubung (Dotted Line)
class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const double dashHeight = 3.5;
    const double dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
