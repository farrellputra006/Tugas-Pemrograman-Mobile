import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewModel {
  final String id;
  final String name;
  final double rating;
  final String comment;
  final String date;
  final List<String> images;

  ReviewModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
    required this.images,
  });
}

class ReviewsPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const ReviewsPage({super.key, this.data});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  // Theme color matching design screenshot (#3B7A6C)
  static const Color primaryGreen = Color(0xFF3B7A6C);
  static const Color darkGreen = Color(0xFF1E604E);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color linkBlue = Color(0xFF00B4D8);

  String _activeFilter = 'Semua'; // 'Semua', 'Dengan Foto', 'Bintang'
  int? _selectedStarFilter; // null or 1..5

  late final Map<String, dynamic> _item;
  late List<ReviewModel> _reviews;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _item = args;
    } else if (widget.data != null) {
      _item = widget.data!;
    } else {
      _item = {
        'id': 'dufan',
        'title': 'Dunia Fantasi (DUFAN)',
        'rating': '4.75',
        'reviewsCount': '24.543 Ulasan',
      };
    }
  }

  @override
  void initState() {
    super.initState();

    _reviews = [
      ReviewModel(
        id: 'rev-1',
        name: 'Kaisyarani Zahra',
        rating: 5.0,
        comment:
            'pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik',
        date: 'Diulas pada 12 Febuari 2025',
        images: [],
      ),
      ReviewModel(
        id: 'rev-2',
        name: 'Kaisyarani Zahra',
        rating: 5.0,
        comment:
            'pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik',
        date: 'Diulas pada 12 Febuari 2025',
        images: ['lib/images/dufan.png', 'lib/images/dufan_detail_hero.png'],
      ),
      ReviewModel(
        id: 'rev-3',
        name: 'Kaisyarani Zahra',
        rating: 5.0,
        comment:
            'pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik',
        date: 'Diulas pada 12 Febuari 2025',
        images: [],
      ),
      ReviewModel(
        id: 'rev-4',
        name: 'Kaisyarani Zahra',
        rating: 5.0,
        comment:
            'pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik pokoknya sngat bagus makcik',
        date: 'Diulas pada 12 Febuari 2025',
        images: [],
      ),
    ];
  }

  List<ReviewModel> get _filteredReviews {
    if (_activeFilter == 'Dengan Foto') {
      return _reviews.where((r) => r.images.isNotEmpty).toList();
    }
    if (_activeFilter == 'Bintang' && _selectedStarFilter != null) {
      return _reviews.where((r) => r.rating.toInt() == _selectedStarFilter).toList();
    }
    return _reviews;
  }

  void _showStarFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Berdasarkan Bintang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [5, 4, 3, 2, 1].map((stars) {
                    final isSelected =
                        _activeFilter == 'Bintang' && _selectedStarFilter == stars;
                    return ActionChip(
                      avatar: const Icon(Icons.star, color: Colors.amber, size: 16),
                      label: Text('$stars Bintang'),
                      backgroundColor:
                          isSelected ? primaryGreen.withValues(alpha: 0.15) : null,
                      side: BorderSide(
                        color: isSelected ? primaryGreen : Colors.grey.shade300,
                      ),
                      onPressed: () {
                        setState(() {
                          _activeFilter = 'Bintang';
                          _selectedStarFilter = stars;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImagePreviewDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Container(
                  width: 260,
                  height: 260,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 48, color: textMuted),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToRatingPage() async {
    final result = await Navigator.pushNamed(
      context,
      '/rating-wisata',
      arguments: _item,
    );

    if (result != null && result is Map<String, dynamic>) {
      if (!mounted) return;
      setState(() {
        _reviews.insert(
          0,
          ReviewModel(
            id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
            name: result['isAnonymous'] == true ? 'Pengguna Anonim' : 'Kaisyarani Zahra',
            rating: (result['rating'] as num?)?.toDouble() ?? 5.0,
            comment: result['comment'] ?? '',
            date: 'Diulas baru saja',
            images: List<String>.from(result['images'] ?? []),
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasanmu telah ditambahkan ke daftar!'),
          backgroundColor: primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReviews;

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
            'Nilai & Ulasan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          titleSpacing: 0,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // 1. TOP RATING & ECOWALK LOGO ROW
            _buildRatingHeader(),

            const SizedBox(height: 16),

            // 2. FILTER PILLS ROW ("Semua", "Dengan Foto", "Bintang v")
            _buildFilterRow(),

            const SizedBox(height: 18),

            // 3. REVIEWS LIST
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: const Text(
                  'Belum ada ulasan untuk filter ini.',
                  style: TextStyle(color: textMuted, fontSize: 13),
                ),
              )
            else
              ...filtered.map((rev) => _buildReviewCard(rev)),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          onPressed: _navigateToRatingPage,
          icon: const Icon(Icons.edit_note_rounded),
          label: const Text(
            'Beri Ulasan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 1. RATING SUMMARY HEADER WITH ECOWALK LOGO
  Widget _buildRatingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Score 4.75, Stars, and 24.543 Ulasan
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '4.75',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    if (index < 4) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(Icons.star, color: Color(0xFFFFB800), size: 19),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(Icons.star_half_rounded, color: Color(0xFFFFB800), size: 19),
                      );
                    }
                  }),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Text(
                  '24.543',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  'Ulasan',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right: ECOWALK Brand Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ECOWA',
              style: TextStyle(
                color: darkGreen,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                height: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: SvgPicture.asset(
                'lib/images/Vector.svg',
                width: 14,
                height: 16,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  darkGreen,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Text(
              'K',
              style: TextStyle(
                color: darkGreen,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                height: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. FILTER PILLS
  Widget _buildFilterRow() {
    return Row(
      children: [
        // "Semua" Chip
        GestureDetector(
          onTap: () {
            setState(() {
              _activeFilter = 'Semua';
              _selectedStarFilter = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: _activeFilter == 'Semua' ? primaryGreen : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _activeFilter == 'Semua' ? primaryGreen : Colors.grey.shade300,
              ),
            ),
            child: Text(
              'Semua',
              style: TextStyle(
                color: _activeFilter == 'Semua' ? Colors.white : textDark,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // "Dengan Foto" Chip
        GestureDetector(
          onTap: () {
            setState(() {
              _activeFilter = 'Dengan Foto';
              _selectedStarFilter = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: _activeFilter == 'Dengan Foto' ? primaryGreen : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _activeFilter == 'Dengan Foto' ? primaryGreen : Colors.grey.shade300,
              ),
            ),
            child: Text(
              'Dengan Foto',
              style: TextStyle(
                color: _activeFilter == 'Dengan Foto' ? Colors.white : textDark,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // "Bintang v" Chip
        GestureDetector(
          onTap: () => _showStarFilterMenu(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: _activeFilter == 'Bintang' ? primaryGreen : primaryGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedStarFilter != null
                      ? '$_selectedStarFilter Bintang'
                      : 'Bintang',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToDetailUlasan(ReviewModel rev) {
    Navigator.pushNamed(
      context,
      '/detail-ulasan',
      arguments: {
        'id': rev.id,
        'name': rev.name,
        'rating': rev.rating,
        'comment': rev.comment,
        'date': rev.date,
        'images': rev.images,
      },
    );
  }

  // 3. REVIEW CARD WIDGET
  Widget _buildReviewCard(ReviewModel rev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToDetailUlasan(rev),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Avatar, Name, Rating Pill
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1D5DB),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        rev.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${rev.rating.toStringAsFixed(1)} / 5.0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Comment Text
                Text(
                  rev.comment,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF374151),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 4),

                // "Selengkapnya" Link -> Navigasi ke Halaman Detail Ulasan
                GestureDetector(
                  onTap: () => _navigateToDetailUlasan(rev),
                  child: const Text(
                    'Selengkapnya',
                    style: TextStyle(
                      color: linkBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

          // Photos Row if available (Matching mockup with two placeholder or photo squares)
          if (rev.images.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: rev.images.take(3).map((img) {
                return GestureDetector(
                  onTap: () => _showImagePreviewDialog(img),
                  child: Container(
                    width: 72,
                    height: 72,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: (img.startsWith('lib/')
                                ? AssetImage(img)
                                : AssetImage('lib/images/dufan.png'))
                            as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 6),

          // Date Right Aligned
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              rev.date,
              style: const TextStyle(
                fontSize: 8.5,
                color: Color(0xFF9CA3AF),
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
}
