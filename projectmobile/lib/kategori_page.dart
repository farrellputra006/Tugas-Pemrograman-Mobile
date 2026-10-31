import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KategoriDestinationModel {
  final String id;
  final String title;
  final double rating;
  final String openHours;
  final String location;
  final String priceText;
  final int minPrice;
  final int maxPrice;
  final String category;
  final String imagePath;
  final double distanceKm;
  final String distance;
  final String popularLocation; // 'Blok M', 'Gelora Bung Karno', 'Senayan', 'Citra Delapan', 'Ancol', etc.
  final String zone; // 'Dalam Ruangan', 'Luar Ruangan'
  final String description;

  const KategoriDestinationModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.openHours,
    required this.location,
    required this.priceText,
    required this.minPrice,
    required this.maxPrice,
    required this.category,
    required this.imagePath,
    required this.distanceKm,
    required this.distance,
    required this.popularLocation,
    required this.zone,
    required this.description,
  });
}

class KategoriPage extends StatefulWidget {
  final String? initialCategory;

  const KategoriPage({super.key, this.initialCategory});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  // Theme color matching design screenshot (#3B7A6C)
  static const Color primaryGreen = Color(0xFF3B7A6C);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);

  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Semua';
  String _sortBy = 'default'; // 'default', 'price_asc', 'price_desc', 'rating_desc'

  // Filter state matching the design
  String? _selectedDistanceQuick = '500 M'; // '500 M', 'Terdekat', 'Terjauh'
  double _distanceSliderKm = 0.5; // in kilometers (0.5 to 25.0)

  int _minPrice = 100000;
  int _maxPrice = 99999999;
  String? _selectedQuickPrice; // '< Rp 50.000,00', '< Rp 100.000,00', '< Rp 300.000,00', 'Gratis'

  String? _selectedPopularLocation; // 'Blok M', 'Gelora Bung Karno', 'Senayan', 'Citra Delapan'
  String? _selectedZone; // 'Dalam Ruangan', 'Luar Ruangan'

  final List<String> _categories = const [
    'Semua',
    'Kuliner',
    'Sejarah',
    'Alam',
    'Religi',
    'Seni',
  ];

  late final List<KategoriDestinationModel> _allDestinations;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null && _categories.contains(widget.initialCategory)) {
      _selectedCategory = widget.initialCategory!;
    }

    _allDestinations = const [
      KategoriDestinationModel(
        id: 'dufan',
        title: 'Dunia Fantasi (DUFAN)',
        rating: 4.75,
        openHours: 'Open 10:00 - 22:00',
        location: 'Ancol, Jakarta utara',
        priceText: 'Mulai dari Rp. 200.000',
        minPrice: 200000,
        maxPrice: 400000,
        category: 'Alam',
        imagePath: 'lib/images/dufan.png',
        distanceKm: 1.68,
        distance: '1.68 KM',
        popularLocation: 'Citra Delapan',
        zone: 'Luar Ruangan',
        description:
            'Taman hiburan outdoor terbesar dengan beragam wahana atraktif dan menantang adrenalin.',
      ),
      KategoriDestinationModel(
        id: 'tmii',
        title: 'Taman Mini Indonesia Indah (TMII)',
        rating: 4.80,
        openHours: 'Open 08:00 - 20:00',
        location: 'Cipayung, Jakarta Timur',
        priceText: 'Mulai dari Rp. 25.000',
        minPrice: 25000,
        maxPrice: 100000,
        category: 'Sejarah',
        imagePath: 'lib/images/tmii.png',
        distanceKm: 3.84,
        distance: '3.84 KM',
        popularLocation: 'Gelora Bung Karno',
        zone: 'Luar Ruangan',
        description:
            'Kawasan taman wisata bertema budaya Indonesia dengan anjungan daerah seluruh provinsi.',
      ),
      KategoriDestinationModel(
        id: 'gbk',
        title: 'Hutan Kota Gelora Bung Karno',
        rating: 4.85,
        openHours: 'Open 06:00 - 18:00',
        location: 'Senayan, Jakarta Pusat',
        priceText: 'Gratis',
        minPrice: 0,
        maxPrice: 0,
        category: 'Alam',
        imagePath: 'lib/images/dufan.png',
        distanceKm: 0.50,
        distance: '500 M',
        popularLocation: 'Gelora Bung Karno',
        zone: 'Luar Ruangan',
        description: 'Taman hijau asri berlatar gedung bertingkat di jantung Gelora Bung Karno.',
      ),
      KategoriDestinationModel(
        id: 'mbloc',
        title: 'M Bloc Space & Kuliner Kreatif',
        rating: 4.78,
        openHours: 'Open 10:00 - 22:00',
        location: 'Panglima Polim, Blok M',
        priceText: 'Mulai dari Rp. 20.000',
        minPrice: 20000,
        maxPrice: 85000,
        category: 'Kuliner',
        imagePath: 'lib/images/tmii.png',
        distanceKm: 1.20,
        distance: '1.20 KM',
        popularLocation: 'Blok M',
        zone: 'Luar Ruangan',
        description: 'Pusat kreatif milenial dengan beragam kuliner kekinian dan panggung musik.',
      ),
      KategoriDestinationModel(
        id: 'senayan_park',
        title: 'Senayan Park Skywalk (SPARK)',
        rating: 4.82,
        openHours: 'Open 10:00 - 22:00',
        location: 'Gelora, Senayan',
        priceText: 'Gratis',
        minPrice: 0,
        maxPrice: 0,
        category: 'Alam',
        imagePath: 'lib/images/dufan.png',
        distanceKm: 0.90,
        distance: '900 M',
        popularLocation: 'Senayan',
        zone: 'Luar Ruangan',
        description: 'Area rekreasi tepi danau dengan jembatan layang kaca skywalk estetik.',
      ),
      KategoriDestinationModel(
        id: 'citra8',
        title: 'Sunset Avenue Citra 8',
        rating: 4.72,
        openHours: 'Open 07:00 - 22:00',
        location: 'Pegadungan, Kalideres',
        priceText: 'Mulai dari Rp. 15.000',
        minPrice: 15000,
        maxPrice: 70000,
        category: 'Kuliner',
        imagePath: 'lib/images/tmii.png',
        distanceKm: 5.40,
        distance: '5.40 KM',
        popularLocation: 'Citra Delapan',
        zone: 'Luar Ruangan',
        description: 'Kawasan kuliner tepi danau dengan pemandangan matahari terbenam.',
      ),
      KategoriDestinationModel(
        id: 'galeri_seni',
        title: 'Museum Macan & Galeri Seni Modern',
        rating: 4.88,
        openHours: 'Open 10:00 - 18:00',
        location: 'Kebon Jeruk, Jakarta Barat',
        priceText: 'Mulai dari Rp. 70.000',
        minPrice: 70000,
        maxPrice: 120000,
        category: 'Seni',
        imagePath: 'lib/images/dufan.png',
        distanceKm: 3.10,
        distance: '3.10 KM',
        popularLocation: 'Blok M',
        zone: 'Dalam Ruangan',
        description: 'Museum seni modern dan kontemporer dengan instalasi visual kelas dunia.',
      ),
      KategoriDestinationModel(
        id: 'monas',
        title: 'Monumen Nasional (MONAS)',
        rating: 4.70,
        openHours: 'Open 08:00 - 18:00',
        location: 'Gambir, Jakarta Pusat',
        priceText: 'Mulai dari Rp. 15.000',
        minPrice: 15000,
        maxPrice: 25000,
        category: 'Sejarah',
        imagePath: 'lib/images/dufan.png',
        distanceKm: 4.15,
        distance: '4.15 KM',
        popularLocation: 'Senayan',
        zone: 'Luar Ruangan',
        description: 'Tugu peringatan kemerdekaan Indonesia dengan cawan dan puncak emas.',
      ),
      KategoriDestinationModel(
        id: 'istiqlal',
        title: 'Masjid Istiqlal',
        rating: 4.90,
        openHours: 'Open 04:00 - 21:00',
        location: 'Sawah Besar, Jakarta Pusat',
        priceText: 'Gratis',
        minPrice: 0,
        maxPrice: 0,
        category: 'Religi',
        imagePath: 'lib/images/tmii.png',
        distanceKm: 4.50,
        distance: '4.50 KM',
        popularLocation: 'Gelora Bung Karno',
        zone: 'Dalam Ruangan',
        description: 'Masjid megah terbesar di Asia Tenggara dengan arsitektur modern tropis.',
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      if (args is String && _categories.contains(args)) {
        setState(() {
          _selectedCategory = args;
        });
      } else if (args is Map<String, dynamic> && args['category'] != null) {
        final cat = args['category'] as String;
        if (_categories.contains(cat)) {
          setState(() {
            _selectedCategory = cat;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters {
    return _selectedPopularLocation != null ||
        _selectedZone != null ||
        _selectedQuickPrice != null ||
        _distanceSliderKm != 0.5 ||
        _minPrice != 100000 ||
        _maxPrice != 99999999;
  }

  List<KategoriDestinationModel> get _filteredList {
    final query = _searchController.text.trim().toLowerCase();

    List<KategoriDestinationModel> list = _allDestinations.where((item) {
      // 1. Filter by category
      final matchCategory = _selectedCategory == 'Semua' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();

      // 2. Filter by search query
      final matchQuery = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query);

      // 3. Filter by distance slider
      final matchDistance = item.distanceKm <= (_distanceSliderKm * 1.5 + 1.0);

      // 4. Filter by popular location if chosen
      final matchPopularLocation = _selectedPopularLocation == null ||
          item.popularLocation.toLowerCase() == _selectedPopularLocation!.toLowerCase() ||
          item.location.toLowerCase().contains(_selectedPopularLocation!.toLowerCase());

      // 5. Filter by zone if chosen
      final matchZone = _selectedZone == null ||
          item.zone.toLowerCase() == _selectedZone!.toLowerCase();

      // 6. Filter by quick price
      bool matchQuickPrice = true;
      if (_selectedQuickPrice == '< Rp 50.000,00') {
        matchQuickPrice = item.minPrice < 50000;
      } else if (_selectedQuickPrice == '< Rp 100.000,00') {
        matchQuickPrice = item.minPrice < 100000;
      } else if (_selectedQuickPrice == '< Rp 300.000,00') {
        matchQuickPrice = item.minPrice < 300000;
      } else if (_selectedQuickPrice == 'Gratis') {
        matchQuickPrice = item.minPrice == 0;
      }

      return matchCategory &&
          matchQuery &&
          matchDistance &&
          matchPopularLocation &&
          matchZone &&
          matchQuickPrice;
    }).toList();

    // Sorting
    if (_sortBy == 'price_asc') {
      list.sort((a, b) => a.minPrice.compareTo(b.minPrice));
    } else if (_sortBy == 'price_desc') {
      list.sort((a, b) => b.minPrice.compareTo(a.minPrice));
    } else if (_sortBy == 'rating_desc') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }

  String _formatRupiah(int val) {
    final s = val.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Urutkan Berdasarkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.star_rounded, color: primaryGreen),
                  title: const Text('Rating Tertinggi'),
                  trailing: _sortBy == 'rating_desc'
                      ? const Icon(Icons.check, color: primaryGreen)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = 'rating_desc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_upward, color: primaryGreen),
                  title: const Text('Harga Terendah'),
                  trailing: _sortBy == 'price_asc'
                      ? const Icon(Icons.check, color: primaryGreen)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = 'price_asc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward, color: primaryGreen),
                  title: const Text('Harga Tertinggi'),
                  trailing: _sortBy == 'price_desc'
                      ? const Icon(Icons.check, color: primaryGreen)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = 'price_desc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restore, color: primaryGreen),
                  title: const Text('Reset Urutan (Default)'),
                  trailing: _sortBy == 'default'
                      ? const Icon(Icons.check, color: primaryGreen)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = 'default');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // FILTER MODAL EXACTLY MATCHING THE MOCKUP
  void _showFilterModal() {
    // Temporary variables for the sheet
    String? tempDistanceQuick = _selectedDistanceQuick;
    double tempDistanceSlider = _distanceSliderKm;
    int tempMinPrice = _minPrice;
    int tempMaxPrice = _maxPrice;
    String? tempQuickPrice = _selectedQuickPrice;
    String? tempPopularLocation = _selectedPopularLocation;
    String? tempZone = _selectedZone;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.88,
              maxChildSize: 0.95,
              minChildSize: 0.6,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Handle Bar at Top
                    const SizedBox(height: 12),
                    Container(
                      width: 52,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                    // Header: "Filter", "Reset", and "X" Close Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 16, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setSheetState(() {
                                    tempDistanceQuick = '500 M';
                                    tempDistanceSlider = 0.5;
                                    tempMinPrice = 100000;
                                    tempMaxPrice = 99999999;
                                    tempQuickPrice = null;
                                    tempPopularLocation = null;
                                    tempZone = null;
                                  });
                                },
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Color(0xFF00B4D8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20, color: textDark),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Filter Sections
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. RENTANG JARAK SECTION
                            const Text(
                              'Rentang Jarak',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Distance Quick Pills ('500 M', 'Terdekat', 'Terjauh')
                            Row(
                              children: ['500 M', 'Terdekat', 'Terjauh'].map((pill) {
                                final isSel = tempDistanceQuick == pill;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setSheetState(() {
                                        tempDistanceQuick = pill;
                                        if (pill == '500 M') {
                                          tempDistanceSlider = 0.5;
                                        } else if (pill == 'Terdekat') {
                                          tempDistanceSlider = 2.0;
                                        } else if (pill == 'Terjauh') {
                                          tempDistanceSlider = 10.0;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSel ? primaryGreen : const Color(0xFF4B7970),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        pill,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 14),

                            // Distance Slider
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: primaryGreen,
                                inactiveTrackColor: const Color(0xFFD1D5DB),
                                thumbColor: primaryGreen,
                                overlayColor: primaryGreen.withValues(alpha: 0.15),
                                trackHeight: 3.5,
                                thumbShape:
                                    const RoundSliderThumbShape(enabledThumbRadius: 7.5),
                              ),
                              child: Slider(
                                value: tempDistanceSlider,
                                min: 0.5,
                                max: 15.0,
                                onChanged: (val) {
                                  setSheetState(() {
                                    tempDistanceSlider = val;
                                    tempDistanceQuick = null;
                                  });
                                },
                              ),
                            ),

                            // Slider Labels (Terdekat, Terjauh)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Terdekat',
                                    style: TextStyle(fontSize: 9.5, color: textMuted),
                                  ),
                                  Text(
                                    'Terjauh',
                                    style: TextStyle(fontSize: 9.5, color: textMuted),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // 2. RENTANG HARGA SECTION
                            const Text(
                              'Rentang Harga',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Minimal and Maksimal Boxes
                            Row(
                              children: [
                                // Minimal Box
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF437C72),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Minimal',
                                          style: TextStyle(color: Colors.white70, fontSize: 9.5),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp  ${_formatRupiah(tempMinPrice)},00',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // Maksimal Box
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF437C72),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Maksimal',
                                          style: TextStyle(color: Colors.white70, fontSize: 9.5),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp  ${_formatRupiah(tempMaxPrice)},00',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // 4 Quick Price Pills (2 rows of 2)
                            Row(
                              children: [
                                _buildQuickPricePill(
                                  label: '< Rp  50.000,00',
                                  isSelected: tempQuickPrice == '< Rp 50.000,00',
                                  onTap: () {
                                    setSheetState(() {
                                      tempQuickPrice = '< Rp 50.000,00';
                                      tempMinPrice = 0;
                                      tempMaxPrice = 50000;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                _buildQuickPricePill(
                                  label: '< Rp  100.000,00',
                                  isSelected: tempQuickPrice == '< Rp 100.000,00',
                                  onTap: () {
                                    setSheetState(() {
                                      tempQuickPrice = '< Rp 100.000,00';
                                      tempMinPrice = 0;
                                      tempMaxPrice = 100000;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildQuickPricePill(
                                  label: '< Rp  300.000,00',
                                  isSelected: tempQuickPrice == '< Rp 300.000,00',
                                  onTap: () {
                                    setSheetState(() {
                                      tempQuickPrice = '< Rp 300.000,00';
                                      tempMinPrice = 0;
                                      tempMaxPrice = 300000;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                _buildQuickPricePill(
                                  label: 'Gratis',
                                  isSelected: tempQuickPrice == 'Gratis',
                                  onTap: () {
                                    setSheetState(() {
                                      tempQuickPrice = 'Gratis';
                                      tempMinPrice = 0;
                                      tempMaxPrice = 0;
                                    });
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(color: Color(0xFFE5E7EB)),
                            const SizedBox(height: 10),

                            // 3. LOKASI POPULER SECTION
                            const Text(
                              'Lokasi Populer',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 10),

                            ...['Blok M', 'Gelora Bung Karno', 'Senayan', 'Citra Delapan'].map((loc) {
                              final isSelected = tempPopularLocation == loc;
                              return GestureDetector(
                                onTap: () {
                                  setSheetState(() {
                                    tempPopularLocation = isSelected ? null : loc;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        loc,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: textDark,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? primaryGreen
                                                : const Color(0xFF9CA3AF),
                                            width: 1.5,
                                          ),
                                          color: isSelected ? primaryGreen : Colors.transparent,
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                size: 12,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 16),

                            // 4. ZONA SECTION
                            const Text(
                              'Zona',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                // Dalam Ruangan Card
                                GestureDetector(
                                  onTap: () {
                                    setSheetState(() {
                                      tempZone = tempZone == 'Dalam Ruangan'
                                          ? null
                                          : 'Dalam Ruangan';
                                    });
                                  },
                                  child: Container(
                                    width: 72,
                                    height: 64,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: tempZone == 'Dalam Ruangan'
                                          ? primaryGreen.withValues(alpha: 0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: tempZone == 'Dalam Ruangan'
                                            ? primaryGreen
                                            : const Color(0xFFD1D5DB),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.roofing_rounded,
                                          size: 22,
                                          color: textDark,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Dalam Ruangan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7.5,
                                            fontWeight: FontWeight.bold,
                                            color: textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Luar Ruangan Card
                                GestureDetector(
                                  onTap: () {
                                    setSheetState(() {
                                      tempZone = tempZone == 'Luar Ruangan'
                                          ? null
                                          : 'Luar Ruangan';
                                    });
                                  },
                                  child: Container(
                                    width: 72,
                                    height: 64,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: tempZone == 'Luar Ruangan'
                                          ? primaryGreen.withValues(alpha: 0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: tempZone == 'Luar Ruangan'
                                            ? primaryGreen
                                            : const Color(0xFFD1D5DB),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.sports_soccer_rounded,
                                          size: 22,
                                          color: textDark,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Luar Ruangan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 7.5,
                                            fontWeight: FontWeight.bold,
                                            color: textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Terapkan Filter Button
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedDistanceQuick = tempDistanceQuick;
                                    _distanceSliderKm = tempDistanceSlider;
                                    _minPrice = tempMinPrice;
                                    _maxPrice = tempMaxPrice;
                                    _selectedQuickPrice = tempQuickPrice;
                                    _selectedPopularLocation = tempPopularLocation;
                                    _selectedZone = tempZone;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Terapkan Filter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickPricePill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryGreen.withValues(alpha: 0.12) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? primaryGreen : const Color(0xFF374151),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryGreen : textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(KategoriDestinationModel item) {
    Navigator.pushNamed(
      context,
      '/detail-wisata',
      arguments: {
        'id': item.id,
        'title': item.title,
        'rating': item.rating.toString(),
        'reviewsCount': '24.543 Ulasan',
        'openHours': item.openHours.replaceFirst('Open ', ''),
        'isOpen': true,
        'address': item.id == 'dufan'
            ? 'Jl. Lodan Timur No.7, Ancol, Kec. Pademangan, Jkt Utara, Daerah Khusus Ibukota Jakarta 14430'
            : '${item.title}, ${item.location}',
        'description': item.description,
        'priceRange': item.priceText.contains('200')
            ? 'Rp. 190.000 - Rp. 400.000'
            : item.priceText,
        'distance': item.distance,
        'heroImage': item.id == 'dufan' ? 'lib/images/dufan_detail_hero.png' : item.imagePath,
        'mapImage': 'lib/images/map_dufan.png',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
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
          ),
          title: const Text(
            'Kategori',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          titleSpacing: 0,
        ),
        body: Column(
          children: [
            // 1. SEARCH BAR & ACTION BUTTONS ROW (FILTER & URUTKAN)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  // Rounded Search Bar
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontSize: 13, color: textDark),
                        decoration: InputDecoration(
                          hintText: 'Cari destinasi wisata',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12.5,
                            color: Colors.grey.shade500,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF6B7280)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Filter Button (Highlights with dot or colored badge when filter is active)
                  GestureDetector(
                    onTap: _showFilterModal,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: _hasActiveFilters ? primaryGreen : const Color(0xFF374151),
                            ),
                            if (_hasActiveFilters)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: _hasActiveFilters ? primaryGreen : const Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Urutkan Button
                  GestureDetector(
                    onTap: _showSortModal,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swap_vert_rounded,
                          size: 20,
                          color: _sortBy != 'default' ? primaryGreen : const Color(0xFF374151),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Urutkan',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: _sortBy != 'default' ? primaryGreen : const Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. HORIZONTAL CATEGORIES TAB WITH GREEN UNDERLINE
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected ? primaryGreen : Colors.transparent,
                              width: 2.2,
                            ),
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? textDark : const Color(0xFF4B5563),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // 3. DESTINATION ITEMS LIST
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          const Text(
                            'Tidak ada destinasi cocok dengan filter',
                            style: TextStyle(color: textMuted, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedDistanceQuick = '500 M';
                                _distanceSliderKm = 0.5;
                                _minPrice = 100000;
                                _maxPrice = 99999999;
                                _selectedQuickPrice = null;
                                _selectedPopularLocation = null;
                                _selectedZone = null;
                                _searchController.clear();
                              });
                            },
                            child: const Text('Reset Filter', style: TextStyle(color: primaryGreen)),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFE5E7EB),
                      ),
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return _buildDestinationTile(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ITEM TILE MATCHING MOCKUP
  Widget _buildDestinationTile(KategoriDestinationModel item) {
    return InkWell(
      onTap: () => _navigateToDetail(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Grey / Photo Avatar (radius matching mockup)
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(item.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Middle Column Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Rating + Status/Hours
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        item.rating.toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '| ${item.openHours}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Location
                  Text(
                    item.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: textMuted,
                    ),
                  ),

                  const SizedBox(height: 1),

                  // Price
                  Text(
                    item.priceText,
                    style: const TextStyle(
                      fontSize: 10,
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron Right Arrow
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: textDark,
            ),
          ],
        ),
      ),
    );
  }
}
