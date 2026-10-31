import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DestinationCompareData {
  final String id;
  final String title;
  final String shortTitle;
  final String location;
  final String distance;
  final double distanceKm;
  final String ticketPrice;
  final int minPrice;
  final String rating;
  final String reviewsCount;
  final String openHours;
  final String category;
  final String zone; // Outdoor / Indoor / Mixed
  final String highlight;
  final String imagePath;
  final String heroImage;
  final String mapImage;
  final String address;
  final String description;
  final List<String> facilities;
  final String publicTransport;
  final String ojekEstimate;

  const DestinationCompareData({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.location,
    required this.distance,
    required this.distanceKm,
    required this.ticketPrice,
    required this.minPrice,
    required this.rating,
    required this.reviewsCount,
    required this.openHours,
    required this.category,
    required this.zone,
    required this.highlight,
    required this.imagePath,
    required this.heroImage,
    required this.mapImage,
    required this.address,
    required this.description,
    required this.facilities,
    required this.publicTransport,
    required this.ojekEstimate,
  });

  Map<String, dynamic> toDetailWisataArgs() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'openHours': openHours,
      'isOpen': true,
      'address': address,
      'description': description,
      'priceRange': ticketPrice,
      'distance': distance,
      'heroImage': heroImage,
      'mapImage': mapImage,
      'category': category,
    };
  }
}

class KomparasiPage extends StatefulWidget {
  final String? initialDestinationId1;
  final String? initialDestinationId2;

  const KomparasiPage({
    super.key,
    this.initialDestinationId1,
    this.initialDestinationId2,
  });

  @override
  State<KomparasiPage> createState() => _KomparasiPageState();
}

class _KomparasiPageState extends State<KomparasiPage> {
  // Theme colors consistent with Ecowalk app design system
  static const Color appColorPrimary = Color(0xFF4A8173);
  static const Color primaryGreen = Color(0xFF3B7A6C);
  static const Color bgSurface = Color(0xFFF8FAF9);
  static const Color textDark = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color borderSubtle = Color(0xFFE5E7EB);
  static const Color greenLightBg = Color(0xFFE8F3EF);
  static const Color amberBadge = Color(0xFFF59E0B);

  // Master list of available destinations for comparison
  final List<DestinationCompareData> _allDestinations = const [
    DestinationCompareData(
      id: 'dufan',
      title: 'Dunia Fantasi (DUFAN)',
      shortTitle: 'DUFAN',
      location: 'Ancol, Jakarta Utara',
      distance: '1.68 KM',
      distanceKm: 1.68,
      ticketPrice: 'Rp. 260.000',
      minPrice: 260000,
      rating: '4.75',
      reviewsCount: '24.543 Ulasan',
      openHours: '10:00 - 22:00',
      category: 'Wahana & Hiburan',
      zone: 'Luar Ruangan (Outdoor)',
      highlight: 'Sensasi Wahana Ekstrem',
      imagePath: 'lib/images/dufan.png',
      heroImage: 'lib/images/dufan_detail_hero.png',
      mapImage: 'lib/images/map_dufan.png',
      address:
          'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430',
      description:
          'Dufan (Dunia Fantasi) adalah taman hiburan outdoor terbesar di kawasan Ancol dengan beragam wahana atraktif dan menantang adrenalin.',
      facilities: ['Wahana Ekstrem', 'Restoran & Kafe', 'Mushola', 'Toilet Bersih', 'Loker', 'Parkir Luas'],
      publicTransport: 'KRL Ancol / TJ Halte Ancol',
      ojekEstimate: 'Rp. 15.000 - 22.000',
    ),
    DestinationCompareData(
      id: 'tmii',
      title: 'Taman Mini Indonesia Indah (TMII)',
      shortTitle: 'TMII',
      location: 'Cipayung, Jakarta Timur',
      distance: '3.84 KM',
      distanceKm: 3.84,
      ticketPrice: 'Mulai Rp. 25.000',
      minPrice: 25000,
      rating: '4.80',
      reviewsCount: '18.210 Ulasan',
      openHours: '06:00 - 20:00',
      category: 'Edukasi & Budaya',
      zone: 'Campuran (Indoor & Outdoor)',
      highlight: 'Wisata Budaya Nusantara',
      imagePath: 'lib/images/tmii.png',
      heroImage: 'lib/images/tmii.png',
      mapImage: 'lib/images/map_dufan.png',
      address:
          'Jl. Raya Taman Mini, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820',
      description:
          'Kawasan taman wisata bertema kebudayaan Indonesia dengan anjungan representatif seluruh nusantara, museum, dan kereta gantung modern.',
      facilities: ['Anjungan Budaya', 'Kereta Gantung', 'Museum Interaktif', 'Taman Burung', 'Food Court'],
      publicTransport: 'LRT Jabodebek TMII / JakLingko',
      ojekEstimate: 'Rp. 18.000 - 26.000',
    ),
    DestinationCompareData(
      id: 'ragunan',
      title: 'Taman Margasatwa Ragunan',
      shortTitle: 'Ragunan',
      location: 'Pasar Minggu, Jakarta Selatan',
      distance: '6.20 KM',
      distanceKm: 6.20,
      ticketPrice: 'Mulai Rp. 4.000',
      minPrice: 4000,
      rating: '4.70',
      reviewsCount: '31.020 Ulasan',
      openHours: '07:00 - 16:00',
      category: 'Alam & Satwa',
      zone: 'Luar Ruangan (Outdoor)',
      highlight: 'Sangat Hemat & Edukatif',
      imagePath: 'lib/images/dufan.png',
      heroImage: 'lib/images/dufan_detail_hero.png',
      mapImage: 'lib/images/map_dufan.png',
      address:
          'Jl. Harsono RM No.1, Ragunan, Pasar Minggu, Jakarta Selatan, DKI Jakarta 12550',
      description:
          'Kebun binatang legendaris seluas 140 hektar dengan pepohonan rindang dan ribuan satwa langka yang ramah keluarga.',
      facilities: ['Pusat Primata Schmutzer', 'Sewa Sepeda', 'Danau Perahu', 'Taman Anak', 'Mushola'],
      publicTransport: 'TJ Koridor 6 Halte Ragunan',
      ojekEstimate: 'Rp. 22.000 - 32.000',
    ),
    DestinationCompareData(
      id: 'monas',
      title: 'Monumen Nasional (MONAS)',
      shortTitle: 'MONAS',
      location: 'Gambir, Jakarta Pusat',
      distance: '4.15 KM',
      distanceKm: 4.15,
      ticketPrice: 'Mulai Rp. 15.000',
      minPrice: 15000,
      rating: '4.85',
      reviewsCount: '45.120 Ulasan',
      openHours: '08:00 - 18:00',
      category: 'Sejarah & Ikonik',
      zone: 'Campuran (Cawan & Pelataran)',
      highlight: 'Ikon Kebanggaan Nasional',
      imagePath: 'lib/images/tmii.png',
      heroImage: 'lib/images/tmii.png',
      mapImage: 'lib/images/map_dufan.png',
      address:
          'Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110',
      description:
          'Monumen peringatan setinggi 132 meter dengan museum diorama perjuangan serta puncak tugu emas dengan pemandangan 360 derajat Jakarta.',
      facilities: ['Museum Sejarah', 'Lift Puncak Monas', 'Taman Olahraga', 'Kereta Wisata Gratis', 'Pusat Kuliner'],
      publicTransport: 'TJ Halte Monas / KRL Juanda / Gambir',
      ojekEstimate: 'Rp. 16.000 - 24.000',
    ),
  ];

  late DestinationCompareData _dest1;
  late DestinationCompareData _dest2;

  @override
  void initState() {
    super.initState();
    _dest1 = _allDestinations.firstWhere(
      (d) => d.id == widget.initialDestinationId1,
      orElse: () => _allDestinations[0], // DUFAN
    );
    _dest2 = _allDestinations.firstWhere(
      (d) => d.id == widget.initialDestinationId2 && d.id != _dest1.id,
      orElse: () => _allDestinations[1], // TMII
    );
  }

  void _swapDestinations() {
    setState(() {
      final temp = _dest1;
      _dest1 = _dest2;
      _dest2 = temp;
    });
  }

  void _selectDestinationForSlot(int slotIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih Destinasi untuk Posisi ${slotIndex == 1 ? "Kiri" : "Kanan"}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pilih tempat wisata yang ingin Anda bandingkan secara langsung.',
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _allDestinations.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final item = _allDestinations[idx];
                    final isCurrent1 = item.id == _dest1.id;
                    final isCurrent2 = item.id == _dest2.id;
                    final isSelectedHere = (slotIndex == 1 && isCurrent1) || (slotIndex == 2 && isCurrent2);

                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          if (slotIndex == 1) {
                            if (item.id == _dest2.id) {
                              _dest2 = _dest1;
                            }
                            _dest1 = item;
                          } else {
                            if (item.id == _dest1.id) {
                              _dest1 = _dest2;
                            }
                            _dest2 = item;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelectedHere ? greenLightBg : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelectedHere ? primaryGreen : borderSubtle,
                            width: isSelectedHere ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item.imagePath,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 44,
                                  height: 44,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isSelectedHere ? primaryGreen : textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.distance} • ${item.ticketPrice}',
                                    style: const TextStyle(fontSize: 11, color: textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelectedHere)
                              const Icon(Icons.check_circle, color: primaryGreen, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openDetailWisata(DestinationCompareData item) {
    Navigator.pushNamed(
      context,
      '/detail-wisata',
      arguments: item.toDetailWisataArgs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: appColorPrimary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgSurface,
        appBar: AppBar(
          backgroundColor: appColorPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Kembali',
          ),
          title: const Text(
            'Perbandingan Destinasi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.swap_horiz, color: Colors.white),
              onPressed: _swapDestinations,
              tooltip: 'Tukar Posisi Destinasi',
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Visual Comparison Card Header
                _buildComparisonHeaderCards(),

                const SizedBox(height: 18),

                // Verdict Banner
                _buildQuickVerdictBanner(),

                const SizedBox(height: 20),

                // Section 1: Biaya & Tiket Masuk
                _buildComparisonSectionTitle(
                  icon: Icons.payments_outlined,
                  title: 'Biaya & Tiket Masuk',
                ),
                const SizedBox(height: 10),
                _buildRowComparison(
                  label: 'Harga Tiket',
                  val1: _dest1.ticketPrice,
                  val2: _dest2.ticketPrice,
                  val1Highlight: _dest1.minPrice < _dest2.minPrice ? 'Lebih Hemat' : null,
                  val2Highlight: _dest2.minPrice < _dest1.minPrice ? 'Lebih Hemat' : null,
                ),
                _buildRowComparison(
                  label: 'Estimasi Ojek Online',
                  val1: _dest1.ojekEstimate,
                  val2: _dest2.ojekEstimate,
                ),

                const SizedBox(height: 20),

                // Section 2: Jarak & Aksesibilitas
                _buildComparisonSectionTitle(
                  icon: Icons.place_outlined,
                  title: 'Jarak & Aksesibilitas',
                ),
                const SizedBox(height: 10),
                _buildRowComparison(
                  label: 'Jarak dari Anda',
                  val1: _dest1.distance,
                  val2: _dest2.distance,
                  val1Highlight: _dest1.distanceKm < _dest2.distanceKm ? 'Lebih Dekat' : null,
                  val2Highlight: _dest2.distanceKm < _dest1.distanceKm ? 'Lebih Dekat' : null,
                ),
                _buildRowComparison(
                  label: 'Transportasi Publik',
                  val1: _dest1.publicTransport,
                  val2: _dest2.publicTransport,
                ),
                _buildRowComparison(
                  label: 'Jam Operasional',
                  val1: _dest1.openHours,
                  val2: _dest2.openHours,
                ),

                const SizedBox(height: 20),

                // Section 3: Pengalaman & Suasana
                _buildComparisonSectionTitle(
                  icon: Icons.explore_outlined,
                  title: 'Pengalaman & Tema',
                ),
                const SizedBox(height: 10),
                _buildRowComparison(
                  label: 'Rating Pengunjung',
                  val1: '⭐ ${_dest1.rating} (${_dest1.reviewsCount})',
                  val2: '⭐ ${_dest2.rating} (${_dest2.reviewsCount})',
                ),
                _buildRowComparison(
                  label: 'Kategori / Tema',
                  val1: _dest1.category,
                  val2: _dest2.category,
                ),
                _buildRowComparison(
                  label: 'Suasana / Area',
                  val1: _dest1.zone,
                  val2: _dest2.zone,
                ),
                _buildFacilitiesComparison(),

                const SizedBox(height: 24),

                // Action Buttons at bottom
                _buildBottomActionButtons(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonHeaderCards() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: borderSubtle),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Destination 1 Card
              Expanded(
                child: _buildDestHeaderCard(_dest1, 1),
              ),

              // VS Badge in Center with Swap button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 28),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _swapDestinations,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.swap_horiz, size: 16, color: textSecondary),
                      ),
                    ),
                  ],
                ),
              ),

              // Destination 2 Card
              Expanded(
                child: _buildDestHeaderCard(_dest2, 2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestHeaderCard(DestinationCompareData item, int slotIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.imagePath,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () => _selectDestinationForSlot(slotIndex),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 10),
                      SizedBox(width: 2),
                      Text('Ganti', style: TextStyle(color: Colors.white, fontSize: 9.5)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: textDark,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.location,
          style: const TextStyle(fontSize: 10.5, color: textMuted),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildQuickVerdictBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC7E2D8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tips_and_updates, color: primaryGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kesimpulan Rekomendasi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• ${_dest1.shortTitle}: ${_dest1.highlight}\n• ${_dest2.shortTitle}: ${_dest2.highlight}',
                  style: const TextStyle(fontSize: 11, color: textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: primaryGreen),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRowComparison({
    required String label,
    required String val1,
    required String val2,
    String? val1Highlight,
    String? val2Highlight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      val1,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    if (val1Highlight != null) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: greenLightBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          val1Highlight,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 26,
                color: borderSubtle,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      val2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    if (val2Highlight != null) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: greenLightBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          val2Highlight,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesComparison() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fasilitas Utama',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _dest1.facilities.map((f) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        f,
                        style: const TextStyle(fontSize: 10, color: textDark),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: borderSubtle,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _dest2.facilities.map((f) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        f,
                        style: const TextStyle(fontSize: 10, color: textDark),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _openDetailWisata(_dest1),
            child: Text(
              'Detail ${_dest1.shortTitle}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryGreen,
              side: const BorderSide(color: primaryGreen, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _openDetailWisata(_dest2),
            child: Text(
              'Detail ${_dest2.shortTitle}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

