import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectmobile/widgets/route_map_widget.dart';

// Top-level compile-time constants agar aman digunakan di dalam konstruktor const
const Color _primaryGreen = Color(0xFF1B5E50);
const Color _navDarkGreen = Color(0xFF0F5132);
const Color _textDark = Color(0xFF111827);
const Color _textSecondary = Color(0xFF4B5563);

class PetaNavigasiPage extends StatefulWidget {
  final String? initialOrigin;
  final String? initialDestination;
  final String? initialMode;
  final bool autoStartLive;

  const PetaNavigasiPage({
    super.key,
    this.initialOrigin,
    this.initialDestination,
    this.initialMode,
    this.autoStartLive = false,
  });

  @override
  State<PetaNavigasiPage> createState() => _PetaNavigasiPageState();
}

class _PetaNavigasiPageState extends State<PetaNavigasiPage>
    with TickerProviderStateMixin {
  late String _origin;
  late String _destination;
  int _selectedModeIndex = 0;

  // Status Mode Navigasi Realtime
  bool _isNavigating = false;
  bool _isPaused = false;
  int _speedMultiplier = 1; // 1x, 2x, 4x
  bool _isMuted = false;
  bool _autoFollow = true;
  bool _hasAutoStarted = false;
  bool _hasReachedDestination = false;

  // Realtime Simulation Controller
  late AnimationController _navController;
  Timer? _speedJitterTimer;
  double _currentSpeed = 44.0; // km/jam

  static const List<Map<String, dynamic>> _modes = [
    {
      'name': 'Motor',
      'icon': Icons.two_wheeler,
      'duration': '24 Menit',
      'distance': '12.8 KM',
      'numericDistanceKm': 12.8,
      'numericDurationMin': 24,
      'routeVia': 'Via Jl. Raya Alternatif (Bebas Ganjil Genap)',
    },
    {
      'name': 'Mobil',
      'icon': Icons.directions_car,
      'duration': '34 Menit',
      'distance': '16.5 KM',
      'numericDistanceKm': 16.5,
      'numericDurationMin': 34,
      'routeVia': 'Via Jalur Tol & Flyover',
    },
    {
      'name': 'Transit/KRL',
      'icon': Icons.train,
      'duration': '42 Menit',
      'distance': '14.2 KM',
      'numericDistanceKm': 14.2,
      'numericDurationMin': 42,
      'routeVia': 'Via Jalur Rel KRL Commuter Line',
    },
    {
      'name': 'Jalan Kaki',
      'icon': Icons.directions_walk,
      'duration': '1 Jam 15 Mnt',
      'distance': '5.8 KM',
      'numericDistanceKm': 5.8,
      'numericDurationMin': 75,
      'routeVia': 'Via Trotoar Pejalan Kaki & JPO',
    },
  ];

  @override
  void initState() {
    super.initState();
    _origin = widget.initialOrigin ?? 'Klapanunggal, Bogor';
    _destination = widget.initialDestination ?? 'Trans Studio Cibubur';

    if (widget.initialMode != null) {
      final modeName = widget.initialMode!.toLowerCase();
      for (int i = 0; i < _modes.length; i++) {
        if (_modes[i]['name'].toString().toLowerCase().contains(modeName)) {
          _selectedModeIndex = i;
          break;
        }
      }
    }

    _navController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _onDestinationReached();
        }
      });

    // Simulasi getaran dinamis kecepatan (speedometer)
    _speedJitterTimer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (_isNavigating && !_isPaused) {
        setState(() {
          final randOffset = (math.Random().nextDouble() * 6.0) - 3.0;
          _currentSpeed = (44.0 + randOffset).clamp(32.0, 58.0);
        });
      }
    });

    if (widget.autoStartLive) {
      _hasAutoStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startLiveNavigation();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['origin'] != null && (args['origin'] as String).isNotEmpty) {
        _origin = args['origin'] as String;
      }
      if (args['destination'] != null && (args['destination'] as String).isNotEmpty) {
        _destination = args['destination'] as String;
      }
      if (args['mode'] != null) {
        final modeName = (args['mode'] as String).toLowerCase();
        for (int i = 0; i < _modes.length; i++) {
          if (_modes[i]['name'].toString().toLowerCase().contains(modeName)) {
            _selectedModeIndex = i;
            break;
          }
        }
      }
      if (args['isLiveNavigation'] == true && !_isNavigating && !_hasAutoStarted) {
        _hasAutoStarted = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _startLiveNavigation();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _navController.dispose();
    _speedJitterTimer?.cancel();
    super.dispose();
  }

  void _startLiveNavigation() {
    if (!mounted) return;
    setState(() {
      _isNavigating = true;
      _isPaused = false;
      _autoFollow = true;
      _hasReachedDestination = false;
    });
    _setSimulationSpeed(_speedMultiplier);
    _navController.forward(from: 0.0);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.navigation, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Panduan navigasi GPS aktif dimulai. Ikuti rute garis biru pada peta.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: _navDarkGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _stopLiveNavigation() {
    _navController.stop();
    setState(() {
      _isNavigating = false;
      _isPaused = false;
      _autoFollow = true;
      _hasReachedDestination = false;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _navController.stop();
      } else {
        _navController.forward();
      }
    });
  }

  void _cycleSpeedMultiplier() {
    setState(() {
      if (_speedMultiplier == 1) {
        _speedMultiplier = 2;
      } else if (_speedMultiplier == 2) {
        _speedMultiplier = 4;
      } else {
        _speedMultiplier = 1;
      }
    });
    _setSimulationSpeed(_speedMultiplier);
  }

  void _setSimulationSpeed(int multiplier) {
    const baseSeconds = 40;
    final newSeconds = (baseSeconds / multiplier).round().clamp(5, 60);
    final currentProgress = _navController.value;
    _navController.duration = Duration(seconds: newSeconds);
    if (_isNavigating && !_isPaused) {
      _navController.forward(from: currentProgress);
    }
  }

  void _onDestinationReached() {
    if (_hasReachedDestination || !mounted) return;
    _hasReachedDestination = true;
    _navController.stop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _buildArrivalSheet(ctx),
      );
    });
  }

  // Perhitungan Data Realtime
  double get _progress => _navController.value;

  String get _currentRemainingDistance {
    final mode = _modes[_selectedModeIndex];
    final totalKm = (mode['numericDistanceKm'] as num).toDouble();
    final rem = totalKm * (1.0 - _progress);
    if (rem < 1.0) {
      final meters = (rem * 1000).round();
      return meters <= 20 ? 'Tiba di Lokasi' : '$meters M';
    }
    return '${rem.toStringAsFixed(1)} KM';
  }

  String get _currentRemainingDuration {
    final mode = _modes[_selectedModeIndex];
    final totalMin = (mode['numericDurationMin'] as num).toInt();
    final rem = (totalMin * (1.0 - _progress)).round();
    if (rem <= 1) {
      return '< 1 Menit';
    }
    return '$rem Menit';
  }

  String get _currentEta {
    final mode = _modes[_selectedModeIndex];
    final totalMin = (mode['numericDurationMin'] as num).toInt();
    final rem = (totalMin * (1.0 - _progress)).round();
    final now = DateTime.now().add(Duration(minutes: rem));
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour.$minute WIB';
  }

  // Turn-By-Turn Navigation Guidance
  Map<String, dynamic> get _currentManeuver {
    final t = _progress;
    if (t < 0.20) {
      final distM = ((0.20 - t) / 0.20 * 350).round();
      return {
        'icon': Icons.turn_right,
        'distance': distM > 30 ? 'Dalam $distM m' : 'Belok kanan sekarang',
        'title': 'Belok kanan ke Jl. Alternatif Transyogi',
        'sub': 'Lalu masuki gerbang Tol Jagorawi',
      };
    } else if (t < 0.48) {
      final distM = ((0.48 - t) / 0.28 * 900).round();
      return {
        'icon': Icons.straight,
        'distance': distM > 50 ? 'Lurus sejauh $distM m' : 'Tetap di lajur kanan',
        'title': 'Masuk Tol Jagorawi (Arah Cawang)',
        'sub': 'Gunakan 2 lajur kanan untuk keluar Semanggi',
      };
    } else if (t < 0.72) {
      final distM = ((0.72 - t) / 0.24 * 550).round();
      return {
        'icon': Icons.turn_slight_right,
        'distance': distM > 30 ? 'Dalam $distM m' : 'Ambil jalur keluar',
        'title': 'Ambil jalur kanan menuju Flyover Semanggi',
        'sub': 'Lalu belok kiri ke Jl. Jend. Sudirman',
      };
    } else if (t < 0.90) {
      final distM = ((0.90 - t) / 0.18 * 300).round();
      return {
        'icon': Icons.turn_left,
        'distance': distM > 25 ? 'Dalam $distM m' : 'Belok kiri sekarang',
        'title': 'Belok kiri ke area parkir & lobby',
        'sub': 'Tujuan berada di sebelah kiri jalan',
      };
    } else {
      return {
        'icon': Icons.place,
        'distance': 'Tiba di tujuan',
        'title': 'Tiba di $_destination',
        'sub': 'Perjalanan Anda telah selesai dengan aman',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = _modes[_selectedModeIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: _isNavigating ? _navDarkGreen : _primaryGreen,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _isNavigating
            ? null
            : AppBar(
                backgroundColor: _primaryGreen,
                elevation: 0,
                leading: IconButton(
                  tooltip: 'Kembali',
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.maybePop(context),
                ),
                title: const Text(
                  'Peta Rute Navigasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                titleSpacing: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    tooltip: 'Bagikan Rute',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tautan rute berhasil disalin ke clipboard.'),
                          backgroundColor: _primaryGreen,
                          duration: Duration(milliseconds: 1200),
                        ),
                      );
                    },
                  ),
                ],
              ),
        body: SafeArea(
          top: !_isNavigating,
          child: Column(
            children: [
              if (!_isNavigating) ...[
                // 1. KARTU TITIK AWAL & TITIK AKHIR DI ATAS
                _buildOriginDestinationBanner(),

                // 2. PILIHAN MODA NAVIGASI
                _buildModeSelector(),
              ] else ...[
                // TOP TURN-BY-TURN GUIDANCE HUD (Google Maps Style)
                _buildTurnByTurnHeader(),
              ],

              // 3. MAP AREA LENGKAP DENGAN GARIS RUTE ASLI & KENDARAAN REALTIME
              Expanded(
                child: Stack(
                  children: [
                    RouteMapWidget(
                      origin: _origin,
                      destination: _destination,
                      mode: currentMode['name'] as String,
                      estimatedDuration: _isNavigating ? _currentRemainingDuration : currentMode['duration'] as String,
                      distance: _isNavigating ? _currentRemainingDistance : currentMode['distance'] as String,
                      height: double.infinity,
                      isInteractive: true,
                      showControls: true,
                      isLiveNavigation: _isNavigating,
                      liveProgress: _isNavigating ? _progress : null,
                      autoFollowVehicle: _autoFollow,
                      speedText: '${_currentSpeed.round()} km/jam',
                      onArrival: _onDestinationReached,
                    ),

                    // Floating GPS Overlay Controls saat Mode Navigasi Aktif
                    if (_isNavigating) ...[
                      // Speedometer Widget (Kiri Atas Peta)
                      Positioned(
                        top: 14,
                        left: 14,
                        child: _buildSpeedometerBadge(),
                      ),

                      // Floating Quick Controls (Kanan Tengah): Speed 1x/2x/4x, Voice, Pause
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Column(
                          children: [
                            // Sound/Voice guidance toggle
                            _buildCircleButton(
                              icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: _isMuted ? Colors.red : _navDarkGreen,
                              onTap: () {
                                setState(() => _isMuted = !_isMuted);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_isMuted
                                        ? 'Suara panduan navigasi dibisukan'
                                        : 'Suara panduan navigasi aktif'),
                                    duration: const Duration(milliseconds: 900),
                                  ),
                                );
                              },
                              tooltip: 'Suara Panduan',
                            ),
                            const SizedBox(height: 8),

                            // Multiplier Speed 1x / 2x / 4x
                            _buildCircleButton(
                              label: '${_speedMultiplier}x',
                              color: const Color(0xFF2563EB),
                              onTap: _cycleSpeedMultiplier,
                              tooltip: 'Kecepatan Simulasi',
                            ),
                            const SizedBox(height: 8),

                            // Pause / Resume Simulation
                            _buildCircleButton(
                              icon: _isPaused ? Icons.play_arrow : Icons.pause,
                              color: _isPaused ? Colors.green : const Color(0xFF4B5563),
                              onTap: _togglePause,
                              tooltip: _isPaused ? 'Lanjutkan' : 'Jeda',
                            ),
                            const SizedBox(height: 8),

                            // Recenter Camera to Vehicle
                            _buildCircleButton(
                              icon: Icons.my_location,
                              color: const Color(0xFF0284C7),
                              onTap: () {
                                setState(() => _autoFollow = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pusatkan kamera ke kendaraan GPS'),
                                    duration: Duration(milliseconds: 800),
                                  ),
                                );
                              },
                              tooltip: 'Pusatkan ke Kendaraan',
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Floating Bottom Navigation HUD
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: _isNavigating
                          ? _buildActiveNavigationBottomHud()
                          : _buildBottomTripSheet(currentMode),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TOP TURN-BY-TURN HUD (Google Maps Navigation Style)
  Widget _buildTurnByTurnHeader() {
    final maneuver = _currentManeuver;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        14,
      ),
      decoration: BoxDecoration(
        color: _navDarkGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Big Maneuver Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  maneuver['icon'] as IconData,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),

              // Distance & Turn Direction
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maneuver['distance'] as String,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      maneuver['title'] as String,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD1FAE5),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Close / Stop Navigation Cross Button
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                tooltip: 'Hentikan Navigasi',
                onPressed: _showExitConfirmation,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Sub Instruction (Lalu Belok ...)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.subdirectory_arrow_right, size: 14, color: Color(0xFF6EE7B7)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    maneuver['sub'] as String,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFFE5E7EB),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Speedometer Badge di Pojok Peta
  Widget _buildSpeedometerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_currentSpeed.round()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                  height: 1.0,
                ),
              ),
              const Text(
                'km/jam',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Batas Kecepatan 60
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Center(
              child: Text(
                '60',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Floating Circle Button Helper
  Widget _buildCircleButton({
    IconData? icon,
    String? label,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: color, size: 20)
                : Text(
                    label ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Bottom HUD saat Navigasi Aktif (ETA, Remaining Distance, Selesai Button)
  Widget _buildActiveNavigationBottomHud() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ETA & Remaining Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _currentRemainingDuration,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($_currentRemainingDistance)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Perkiraan Tiba: $_currentEta',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Tombol Merah Hentikan Navigasi
              ElevatedButton.icon(
                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                label: const Text(
                  'Berhenti',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: _showExitConfirmation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hentikan Navigasi?'),
        content: const Text(
          'Apakah Anda ingin keluar dari panduan rute realtime saat ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Lanjutkan Navigasi'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(ctx);
              _stopLiveNavigation();
            },
            child: const Text('Hentikan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Modal Dialog "Tiba di Tujuan"
  Widget _buildArrivalSheet(BuildContext ctx) {
    final mode = _modes[_selectedModeIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF10B981),
              size: 40,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Anda Telah Sampai di Tujuan!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: _textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            _destination,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _primaryGreen,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // Ringkasan Perjalanan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('Jarak', mode['distance'] as String),
                Container(height: 24, width: 1, color: Colors.grey.shade300),
                _buildSummaryStat('Waktu', mode['duration'] as String),
                Container(height: 24, width: 1, color: Colors.grey.shade300),
                _buildSummaryStat('Moda', mode['name'] as String),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tombol Tindakan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
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
                    'title': _destination,
                    'origin': _origin,
                    'dateTime': 'Hari ini • Selesai',
                    'address': _destination,
                    'distance': mode['distance'],
                    'transport': mode['name'],
                    'estimatedDuration': mode['duration'],
                  },
                );
              },
              child: const Text(
                'Lihat Rekap Perjalanan Lengkap',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _stopLiveNavigation();
            },
            child: const Text('Tutup dan Kembali ke Peta'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildOriginDestinationBanner() {
    return Container(
      color: _primaryGreen,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Titik Asal
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lokasi Asal',
                        style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                      ),
                      Text(
                        _origin,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Divider(height: 1, color: Colors.grey.shade200),
            ),

            // Titik Tujuan
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFEF4444),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lokasi Tujuan',
                        style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                      ),
                      Text(
                        _destination,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      color: const Color(0xFFF3F4F6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_modes.length, (index) {
          final mode = _modes[index];
          final isSelected = _selectedModeIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedModeIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _primaryGreen : const Color(0xFFE5E7EB),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    mode['icon'] as IconData,
                    size: 15,
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mode['name'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomTripSheet(Map<String, dynamic> currentMode) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        currentMode['duration'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${currentMode['distance']})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentMode['routeVia'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3EF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, size: 12, color: _primaryGreen),
                    SizedBox(width: 3),
                    Text(
                      'Tercepat',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: _primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.navigation, color: Colors.white, size: 18),
              label: const Text(
                'Mulai Panduan Rute Realtime',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: _startLiveNavigation,
            ),
          ),
        ],
      ),
    );
  }
}
