import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  static const _categories = [
    _CatData('Plomberie',     Icons.plumbing_rounded,            48),
    _CatData('Électricité',   Icons.bolt_rounded,                62),
    _CatData('Ménage',        Icons.cleaning_services_rounded,   91),
    _CatData('Peinture',      Icons.format_paint_rounded,        35),
    _CatData('Jardinage',     Icons.yard_rounded,                27),
    _CatData('Déménagement',  Icons.local_shipping_rounded,      19),
    _CatData('Rénovation',    Icons.construction_rounded,        53),
    _CatData('Serrurerie',    Icons.lock_rounded,                22),
    _CatData('Climatisation', Icons.ac_unit_rounded,             31),
    _CatData('Informatique',  Icons.computer_rounded,            44),
    _CatData('Cuisine',       Icons.restaurant_rounded,          16),
    _CatData('Livraison',     Icons.delivery_dining_rounded,     38),
  ];

  List<_CatData> get _filtered {
    if (_query.isEmpty) return _categories;
    final q = _query.toLowerCase();
    return _categories
        .where((c) => c.label.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            const SizedBox(height: 8),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: Color(0xFF374151)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catégories',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    '${_categories.length} catégories disponibles',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: const Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v),
          style: GoogleFonts.inter(
              fontSize: 14, color: const Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: 'Rechercher une catégorie…',
            hintStyle: GoogleFonts.inter(
                fontSize: 14, color: const Color(0xFF9CA3AF)),
            prefixIcon: const Icon(Icons.search_rounded,
                color: Color(0xFF9CA3AF), size: 20),
            suffixIcon: _query.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      setState(() => _query = '');
                    },
                    child: const Icon(Icons.close_rounded,
                        color: Color(0xFF9CA3AF), size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final items = _filtered;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 44, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 12),
            Text(
              'Aucune catégorie trouvée',
              style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF), fontSize: 15),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _CategoryGridCard(cat: items[i]),
    );
  }
}

// ─── Carte catégorie ──────────────────────────────────────────────────────────
class _CategoryGridCard extends StatelessWidget {
  final _CatData cat;
  const _CategoryGridCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppConstants.routeClientSearch,
        extra: {'category': cat.label},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(cat.icon,
                  color: const Color(0xFF7C3AED), size: 22),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                cat.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${cat.providerCount} presta.',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatData {
  final String label;
  final IconData icon;
  final int providerCount;
  const _CatData(this.label, this.icon, this.providerCount);
}
