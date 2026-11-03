import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Widget Maps Rute Realtime Lengkap dengan Panduan Navigasi Otentik seperti Google Maps / Waze
class RouteMapWidget extends StatefulWidget {
  final String origin;
  final String destination;
  final String mode;
  final String estimatedDuration;
  final String distance;
  final double height;
  final bool isInteractive;
  final bool showControls;
  final VoidCallback? onExpand;
  final bool isLiveNavigation;
  final double? liveProgress;
  final bool autoFollowVehicle;
  final ValueChanged<double>? onProgressChanged;
  final VoidCallback? onArrival;
  final String? speedText;

  const RouteMapWidget({
    super.key,
    required this.origin,
    required this.destination,
    this.mode = 'Motor',
    this.estimatedDuration = '28 Menit',
    this.distance = '13.2 KM',
    this.height = 220,
    this.isInteractive = true,
    this.showControls = true,
    this.onExpand,
    this.isLiveNavigation = false,
    this.liveProgress,
    this.autoFollowVehicle = true,
    this.onProgressChanged,
    this.onArrival,
    this.speedText,
  });

  @override
  State<RouteMapWidget> createState() => _RouteMapWidgetState();
}

class _RouteMapWidgetState extends State<RouteMapWidget>
    with TickerProviderStateMixin {
  static const Color primaryGreen = Color(0xFF1B5E50);

  // Zoom & Pan state
  double _zoomLevel = 1.0;
  Offset _panOffset = Offset.zero;
  Offset _lastFocalPoint = Offset.zero;

  // Pulse animation untuk sinyal radar GPS
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Internal live simulation controller jika liveProgress tidak diberikan parent
  AnimationController? _internalLiveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isLiveNavigation && widget.liveProgress == null) {
      _initInternalLiveController();
    }
  }

  void _initInternalLiveController() {
    _internalLiveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..addListener(() {
        final val = _internalLiveController?.value ?? 0.0;
        widget.onProgressChanged?.call(val);
        if (val >= 1.0) {
          widget.onArrival?.call();
        }
        setState(() {});
      });
    _internalLiveController?.forward();
  }

  @override
  void didUpdateWidget(covariant RouteMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiveNavigation != oldWidget.isLiveNavigation) {
      if (widget.isLiveNavigation && widget.liveProgress == null) {
        _internalLiveController ??= AnimationController(
          vsync: this,
          duration: const Duration(seconds: 40),
        )..addListener(() {
            final val = _internalLiveController?.value ?? 0.0;
            widget.onProgressChanged?.call(val);
            if (val >= 1.0) {
              widget.onArrival?.call();
            }
            setState(() {});
          });
        _internalLiveController?.forward(from: 0.0);
      } else {
        _internalLiveController?.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _internalLiveController?.dispose();
    super.dispose();
  }

  double get _currentProgress {
    if (widget.liveProgress != null) {
      return widget.liveProgress!.clamp(0.0, 1.0);
    }
    if (widget.isLiveNavigation && _internalLiveController != null) {
      return _internalLiveController!.value.clamp(0.0, 1.0);
    }
    return 0.0;
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.25).clamp(0.8, 3.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.25).clamp(0.8, 3.0);
    });
  }

  void _recenter() {
    setState(() {
      _zoomLevel = widget.isLiveNavigation ? 1.35 : 1.0;
      _panOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLive = widget.isLiveNavigation || _currentProgress > 0.0;

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECEF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isLive ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
          width: isLive ? 1.8 : 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 1. Interactive Canvas Map Layer (Bisa di-pan dan zoom)
            GestureDetector(
              onScaleStart: widget.isInteractive
                  ? (details) => _lastFocalPoint = details.focalPoint
                  : null,
              onScaleUpdate: widget.isInteractive
                  ? (details) {
                      setState(() {
                        _zoomLevel =
                            (_zoomLevel * details.scale).clamp(0.8, 3.0);
                        final delta = details.focalPoint - _lastFocalPoint;
                        _panOffset += delta;
                        _lastFocalPoint = details.focalPoint;
                      });
                    }
                  : null,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final double w = constraints.maxWidth;
                      final double h = constraints.maxHeight;

                      // Auto-center ke posisi kendaraan jika dalam mode navigasi aktif
                      Offset currentPan = _panOffset;
                      if (isLive && widget.autoFollowVehicle && _panOffset == Offset.zero) {
                        final vehiclePos = _AuthenticRoutePainter.calculatePosition(
                          w,
                          h,
                          _currentProgress,
                        );
                        final center = Offset(w / 2, h / 2);
                        final diff = center - vehiclePos;
                        currentPan = diff * 0.45;
                      }

                      return Transform.translate(
                        offset: currentPan,
                        child: Transform.scale(
                          scale: isLive && _zoomLevel == 1.0 ? 1.25 : _zoomLevel,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Base Map Vector/Texture
                              Image.asset(
                                'lib/images/map_route.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: const Color(0xFFE2E8F0),
                                  child: CustomPaint(
                                    painter: _GridRoadPainter(),
                                  ),
                                ),
                              ),

                              // Realtime Authentic Route & GPS Vehicle Painter
                              CustomPaint(
                                painter: _AuthenticRoutePainter(
                                  origin: widget.origin,
                                  destination: widget.destination,
                                  pulseValue: _pulseAnimation.value,
                                  duration: widget.estimatedDuration,
                                  distance: widget.distance,
                                  progress: _currentProgress,
                                  isLive: isLive,
                                  mode: widget.mode,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // 2. Badge Status Rute / GPS Realtime (Kiri Atas)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isLive ? const Color(0xFF1E3A8A) : Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLive) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'GPS AKTIF • ${widget.speedText ?? '42 km/jam'}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ] else ...[
                      const Icon(Icons.near_me, size: 13, color: Color(0xFF1B5E50)),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.mode} • ${widget.estimatedDuration}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // 3. Tombol Mode Fullscreen / Detail Peta (Kanan Atas)
            if (widget.showControls)
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: widget.onExpand ?? () => _openFullScreenMap(context),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Color(0xFF374151),
                      size: 18,
                    ),
                  ),
                ),
              ),

            // 4. Tombol Kontrol Peta: Zoom, Recenter, & Toggle Live (Kanan Bawah)
            if (widget.showControls)
              Positioned(
                bottom: 10,
                right: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Zoom In
                    _buildMapControlButton(
                      icon: Icons.add,
                      onTap: _zoomIn,
                      tooltip: 'Perbesar',
                    ),
                    const SizedBox(height: 6),
                    // Zoom Out
                    _buildMapControlButton(
                      icon: Icons.remove,
                      onTap: _zoomOut,
                      tooltip: 'Perkecil',
                    ),
                    const SizedBox(height: 6),
                    // Recenter on Vehicle / Route
                    _buildMapControlButton(
                      icon: isLive ? Icons.navigation : Icons.my_location,
                      color: isLive ? const Color(0xFF2563EB) : primaryGreen,
                      onTap: _recenter,
                      tooltip: isLive ? 'Pusatkan ke Kendaraan' : 'Pusatkan Rute',
                    ),
                  ],
                ),
              ),

            // 5. Informasi Kondisi Lalu Lintas & Estimasi Realtime (Kiri Bawah)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isLive
                          ? 'Menuju: ${widget.destination.length > 18 ? '${widget.destination.substring(0, 18)}...' : widget.destination}'
                          : 'Lalu Lintas Lancar • Rute Tercepat',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = const Color(0xFF374151),
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  void _openFullScreenMap(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/peta-rute',
      arguments: {
        'origin': widget.origin,
        'destination': widget.destination,
        'mode': widget.mode,
        'duration': widget.estimatedDuration,
        'distance': widget.distance,
        'isLiveNavigation': widget.isLiveNavigation,
      },
    );
  }
}

/// Custom Painter untuk Menggambar Rute Otentik, Simpul Pin A & B, serta Posisi Kendaraan Realtime
class _AuthenticRoutePainter extends CustomPainter {
  final String origin;
  final String destination;
  final double pulseValue;
  final String duration;
  final String distance;
  final double progress;
  final bool isLive;
  final String mode;

  _AuthenticRoutePainter({
    required this.origin,
    required this.destination,
    required this.pulseValue,
    required this.duration,
    required this.distance,
    this.progress = 0.0,
    this.isLive = false,
    this.mode = 'Motor',
  });

  static List<Offset> getRouteNodes(double w, double h) {
    return [
      Offset(w * 0.18, h * 0.72), // 0: Start Point
      Offset(w * 0.28, h * 0.70), // 1: Turn 1
      Offset(w * 0.38, h * 0.48), // 2: Turn 2
      Offset(w * 0.52, h * 0.46), // 3: Turn 3
      Offset(w * 0.64, h * 0.32), // 4: Turn 4
      Offset(w * 0.82, h * 0.28), // 5: End Destination
    ];
  }

  static Offset calculatePosition(double w, double h, double t) {
    final nodes = getRouteNodes(w, h);
    if (t <= 0.0) return nodes.first;
    if (t >= 1.0) return nodes.last;

    List<double> segmentLengths = [];
    double totalLength = 0;
    for (int i = 0; i < nodes.length - 1; i++) {
      final len = (nodes[i + 1] - nodes[i]).distance;
      segmentLengths.add(len);
      totalLength += len;
    }

    double targetDist = t * totalLength;
    double accumulated = 0;
    for (int i = 0; i < segmentLengths.length; i++) {
      if (accumulated + segmentLengths[i] >= targetDist) {
        double segT = (targetDist - accumulated) / segmentLengths[i];
        return Offset.lerp(nodes[i], nodes[i + 1], segT)!;
      }
      accumulated += segmentLengths[i];
    }
    return nodes.last;
  }

  static double calculateBearing(double w, double h, double t) {
    final nodes = getRouteNodes(w, h);
    if (t >= 1.0) {
      final pLast = nodes[nodes.length - 1];
      final pPrev = nodes[nodes.length - 2];
      return math.atan2(pLast.dy - pPrev.dy, pLast.dx - pPrev.dx);
    }

    List<double> segmentLengths = [];
    double totalLength = 0;
    for (int i = 0; i < nodes.length - 1; i++) {
      final len = (nodes[i + 1] - nodes[i]).distance;
      segmentLengths.add(len);
      totalLength += len;
    }

    double targetDist = t * totalLength;
    double accumulated = 0;
    for (int i = 0; i < segmentLengths.length; i++) {
      if (accumulated + segmentLengths[i] >= targetDist) {
        return math.atan2(
          nodes[i + 1].dy - nodes[i].dy,
          nodes[i + 1].dx - nodes[i].dx,
        );
      }
      accumulated += segmentLengths[i];
    }
    return 0.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final nodes = getRouteNodes(w, h);

    final startPoint = nodes[0];
    final endPoint = nodes.last;

    // 1. RUTE ALTERNATIF (Garis Abu-abu tipis seperti Google Maps)
    final altPath = Path();
    altPath.moveTo(startPoint.dx, startPoint.dy);
    altPath.lineTo(w * 0.22, h * 0.85);
    altPath.lineTo(w * 0.55, h * 0.78);
    altPath.lineTo(w * 0.74, h * 0.55);
    altPath.lineTo(endPoint.dx, endPoint.dy);

    final altPaint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.6)
      ..strokeWidth = 3.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(altPath, altPaint);

    // 2. PEMISAHAN RUTE: Bagian Terlewati (Past Path) vs Sisa Rute (Remaining Path)
    final currentPos = calculatePosition(w, h, progress);
    final double bearing = calculateBearing(w, h, progress);

    if (progress > 0.01) {
      // 2a. Garis Rute yang Sudah Dilewati (Warna Abu-abu / Muted Blue)
      final pastPath = Path();
      pastPath.moveTo(startPoint.dx, startPoint.dy);

      double targetDist = progress * _getTotalDistance(nodes);
      double acc = 0;
      bool reached = false;

      for (int i = 0; i < nodes.length - 1; i++) {
        final segLen = (nodes[i + 1] - nodes[i]).distance;
        if (!reached) {
          if (acc + segLen >= targetDist) {
            pastPath.lineTo(currentPos.dx, currentPos.dy);
            reached = true;
          } else {
            pastPath.lineTo(nodes[i + 1].dx, nodes[i + 1].dy);
            acc += segLen;
          }
        }
      }

      final pastPaint = Paint()
        ..color = const Color(0xFF64748B).withValues(alpha: 0.55)
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(pastPath, pastPaint);
    }

    // 2b. Garis Rute Sisa Menuju Tujuan (Vibrant Google Maps Blue)
    final remainingPath = Path();
    remainingPath.moveTo(currentPos.dx, currentPos.dy);

    double targetDist = progress * _getTotalDistance(nodes);
    double acc = 0;
    bool pastCurrent = false;

    for (int i = 0; i < nodes.length - 1; i++) {
      final segLen = (nodes[i + 1] - nodes[i]).distance;
      if (acc + segLen >= targetDist) {
        if (!pastCurrent) {
          pastCurrent = true;
        }
        remainingPath.lineTo(nodes[i + 1].dx, nodes[i + 1].dy);
      }
      acc += segLen;
    }

    // Outer Glow Biru Rute
    final outerGlowPaint = Paint()
      ..color = const Color(0xFF1E40AF).withValues(alpha: 0.35)
      ..strokeWidth = 9.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(remainingPath, outerGlowPaint);

    // Garis Utama Biru Terang
    final mainRoutePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 5.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(remainingPath, mainRoutePaint);

    // Panah Arah Jalur (Chevron di rute tersisa)
    if (progress < 0.25) _drawRouteArrow(canvas, nodes[1], nodes[2]);
    if (progress < 0.65) _drawRouteArrow(canvas, nodes[3], nodes[4]);

    // 3. FLOATING BADGE DURASI DI TENGAH RUTE (Jika belum lewat)
    if (progress < 0.45) {
      final midPoint = Offset((nodes[2].dx + nodes[3].dx) / 2, (nodes[2].dy + nodes[3].dy) / 2 - 12);
      _drawPillBadge(canvas, midPoint, '$duration ($distance)');
    }

    // 4. TITIK AWAL (START / PIN A - Hijau dengan Pulse Efek)
    _drawStartNode(canvas, startPoint, origin);

    // 5. TITIK AKHIR (DESTINATION / PIN B - Merah dengan Ikon Pin)
    _drawDestinationPin(canvas, endPoint, destination);

    // 6. KENDARAAN REALTIME / GPS MARKER AKTIF (Berjalan Sepanjang Rute)
    if (isLive || progress > 0.0) {
      _drawLiveGpsVehicle(canvas, currentPos, bearing);
    }
  }

  double _getTotalDistance(List<Offset> nodes) {
    double total = 0;
    for (int i = 0; i < nodes.length - 1; i++) {
      total += (nodes[i + 1] - nodes[i]).distance;
    }
    return total;
  }

  /// Menggambar Marker Kendaraan Realtime Otentik seperti Google Maps
  void _drawLiveGpsVehicle(Canvas canvas, Offset pos, double bearing) {
    // 1. Radar Pulse Gelombang Luar
    final double radarRadius = 16.0 * pulseValue;
    canvas.drawCircle(
      pos,
      radarRadius,
      Paint()
        ..color = const Color(0xFF38BDF8).withValues(alpha: (0.45 / pulseValue).clamp(0.0, 1.0)),
    );

    // 2. Heading Cone (Sinar Sorot Sudut Pandang Arah Kendaraan)
    final conePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF38BDF8).withValues(alpha: 0.5),
          const Color(0xFF38BDF8).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: pos, radius: 26));

    final conePath = Path();
    const double coneAngle = math.pi / 4;
    const double coneDist = 26.0;
    conePath.moveTo(pos.dx, pos.dy);
    conePath.lineTo(
      pos.dx + coneDist * math.cos(bearing - coneAngle / 2),
      pos.dy + coneDist * math.sin(bearing - coneAngle / 2),
    );
    conePath.arcTo(
      Rect.fromCircle(center: pos, radius: coneDist),
      bearing - coneAngle / 2,
      coneAngle,
      false,
    );
    conePath.close();
    canvas.drawPath(conePath, conePaint);

    // 3. Lingkaran Dasar Putih (Border Luar Marker)
    canvas.drawCircle(
      pos,
      10.5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      pos,
      10.5,
      Paint()
        ..color = const Color(0xFF0284C7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // 4. Lingkaran Biru Navigasi
    canvas.drawCircle(
      pos,
      8.0,
      Paint()..color = const Color(0xFF0284C7),
    );

    // 5. Panah Arah 3D (Navigation Arrow Heading Pointer)
    final arrowPath = Path();
    const double arrowSize = 6.0;
    final tip = Offset(
      pos.dx + arrowSize * math.cos(bearing),
      pos.dy + arrowSize * math.sin(bearing),
    );
    final leftCorner = Offset(
      pos.dx + (arrowSize * 0.8) * math.cos(bearing + 2.5),
      pos.dy + (arrowSize * 0.8) * math.sin(bearing + 2.5),
    );
    final rightCorner = Offset(
      pos.dx + (arrowSize * 0.8) * math.cos(bearing - 2.5),
      pos.dy + (arrowSize * 0.8) * math.sin(bearing - 2.5),
    );

    arrowPath.moveTo(tip.dx, tip.dy);
    arrowPath.lineTo(leftCorner.dx, leftCorner.dy);
    arrowPath.lineTo(pos.dx, pos.dy);
    arrowPath.lineTo(rightCorner.dx, rightCorner.dy);
    arrowPath.close();

    canvas.drawPath(arrowPath, Paint()..color = Colors.white);
  }

  void _drawRouteArrow(Canvas canvas, Offset p1, Offset p2) {
    final double angle = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);

    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final arrowPath = Path();
    const double arrowSize = 4.5;
    arrowPath.moveTo(
      mid.dx - arrowSize * math.cos(angle - math.pi / 4),
      mid.dy - arrowSize * math.sin(angle - math.pi / 4),
    );
    arrowPath.lineTo(mid.dx, mid.dy);
    arrowPath.lineTo(
      mid.dx - arrowSize * math.cos(angle + math.pi / 4),
      mid.dy - arrowSize * math.sin(angle + math.pi / 4),
    );

    canvas.drawPath(arrowPath, arrowPaint);
  }

  void _drawPillBadge(Canvas canvas, Offset center, String text) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: Color(0xFF1E3A8A),
        fontSize: 9.5,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: textPainter.width + 14,
        height: textPainter.height + 6,
      ),
      const Radius.circular(10),
    );

    // Shadow
    canvas.drawRRect(
      rect.shift(const Offset(0, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );

    // Background Putih
    canvas.drawRRect(rect, Paint()..color = Colors.white);
    // Border tipis biru
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFF3B82F6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  void _drawStartNode(Canvas canvas, Offset point, String label) {
    // Pulse Ring Luar
    canvas.drawCircle(
      point,
      12.0 * pulseValue,
      Paint()..color = const Color(0xFF10B981).withValues(alpha: (0.35 / pulseValue).clamp(0.0, 1.0)),
    );

    // Lingkaran Hijau
    canvas.drawCircle(
      point,
      7.0,
      Paint()..color = const Color(0xFF10B981),
    );

    // Titik Putih Tengah
    canvas.drawCircle(
      point,
      3.2,
      Paint()..color = Colors.white,
    );

    // Label Titik Awal (Kotak Putih Kecil)
    final labelSpan = TextSpan(
      text: label.length > 14 ? '${label.substring(0, 14)}...' : label,
      style: const TextStyle(
        fontSize: 8.5,
        fontWeight: FontWeight.bold,
        color: Color(0xFF065F46),
      ),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        point.dx - labelPainter.width / 2 - 4,
        point.dy + 10,
        labelPainter.width + 8,
        labelPainter.height + 4,
      ),
      const Radius.circular(5),
    );

    canvas.drawRRect(
      labelRect,
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );
    canvas.drawRRect(
      labelRect,
      Paint()
        ..color = const Color(0xFF10B981)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    labelPainter.paint(canvas, Offset(point.dx - labelPainter.width / 2, point.dy + 12));
  }

  void _drawDestinationPin(Canvas canvas, Offset point, String label) {
    final pinPaint = Paint()..color = const Color(0xFFEF4444);

    final path = Path();
    path.moveTo(point.dx, point.dy);
    path.cubicTo(
      point.dx - 9,
      point.dy - 12,
      point.dx - 8,
      point.dy - 22,
      point.dx,
      point.dy - 22,
    );
    path.cubicTo(
      point.dx + 8,
      point.dy - 22,
      point.dx + 9,
      point.dy - 12,
      point.dx,
      point.dy,
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(point.dx, point.dy + 2), width: 10, height: 4),
      Paint()..color = Colors.black.withValues(alpha: 0.25),
    );

    canvas.drawPath(path, pinPaint);

    canvas.drawCircle(
      Offset(point.dx, point.dy - 14),
      3.2,
      Paint()..color = Colors.white,
    );

    final labelSpan = TextSpan(
      text: label.length > 14 ? '${label.substring(0, 14)}...' : label,
      style: const TextStyle(
        fontSize: 8.5,
        fontWeight: FontWeight.bold,
        color: Color(0xFF991B1B),
      ),
    );
    final labelPainter = TextPainter(
      text: labelSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        point.dx - labelPainter.width / 2 - 4,
        point.dy - 38,
        labelPainter.width + 8,
        labelPainter.height + 4,
      ),
      const Radius.circular(5),
    );

    canvas.drawRRect(
      labelRect,
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );
    canvas.drawRRect(
      labelRect,
      Paint()
        ..color = const Color(0xFFEF4444)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    labelPainter.paint(canvas, Offset(point.dx - labelPainter.width / 2, point.dy - 36));
  }

  @override
  bool shouldRepaint(covariant _AuthenticRoutePainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.progress != progress ||
        oldDelegate.isLive != isLive ||
        oldDelegate.origin != origin ||
        oldDelegate.destination != destination;
  }
}

/// Fallback Grid Road Painter jika gambar map tidak ditemukan
class _GridRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF1F5F9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0;

    for (double i = 20; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), roadPaint);
    }
    for (double i = 20; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), roadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
