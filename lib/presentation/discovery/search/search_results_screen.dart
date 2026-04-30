import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../home/widgets/provider_card.widget.dart';
import 'widgets/search_filter_sheet.dart';

class SearchResultsScreen extends StatefulWidget {
  final String? initialQuery;
  final String? category;

  const SearchResultsScreen({
    super.key,
    this.initialQuery,
    this.category,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchCtrl;
  SearchFilters _filters = const SearchFilters();
  String _sortBy = 'Pertinence';

  static const _sortOptions = ['Pertinence', 'Note', 'Distance', 'Prix'];

  static const _mockResults = [
    _ProviderResult(name: 'Jean Dupont',    expertise: 'Plombier expert',       rating: 4.9, reviewCount: 127, distance: '2.5 km', price: '35 €/h', initials: 'JD', isAvailable: true),
    _ProviderResult(name: 'Marie Leroi',    expertise: 'Plombière certifiée',   rating: 4.7, reviewCount: 89,  distance: '3.1 km', price: '30 €/h', initials: 'ML', isAvailable: true),
    _ProviderResult(name: 'Robert Morin',   expertise: 'Maître plombier',       rating: 4.8, reviewCount: 214, distance: '4.2 km', price: '45 €/h', initials: 'RM', isAvailable: false),
    _ProviderResult(name: 'Sophie Blanc',   expertise: 'Plombière sanitaire',   rating: 4.6, reviewCount: 58,  distance: '1.8 km', price: '28 €/h', initials: 'SB', isAvailable: true),
    _ProviderResult(name: 'Karim Ould',     expertise: 'Plombier chauffagiste', rating: 4.5, reviewCount: 143, distance: '5.0 km', price: '40 €/h', initials: 'KO', isAvailable: true),
    _ProviderResult(name: 'Laura Petit',    expertise: 'Plombière polyvalente', rating: 4.4, reviewCount: 37,  distance: '6.3 km', price: '25 €/h', initials: 'LP', isAvailable: false),
  ];

  List<_ProviderResult> get _filtered {
    var results = _mockResults.where((p) {
      if (_filters.availableOnly && !p.isAvailable) return false;
      if (_filters.minRating > 0 && p.rating < _filters.minRating) return false;
      final priceVal = double.tryParse(
              p.price.replaceAll(' €/h', '').replaceAll(' ', '')) ?? 0;
      if (priceVal < _filters.minPrice || priceVal > _filters.maxPrice) return false;
      return true;
    }).toList();

    if (_sortBy == 'Note') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Prix') {
      results.sort((a, b) {
        final ap = double.tryParse(a.price.replaceAll(' €/h', '')) ?? 0;
        final bp = double.tryParse(b.price.replaceAll(' €/h', '')) ?? 0;
        return ap.compareTo(bp);
      });
    }
    return results;
  }

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(
        text: widget.initialQuery ?? widget.category ?? '');
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SearchFilterSheet(initialFilters: _filters),
      ),
    );
    if (result != null && mounted) setState(() => _filters = result);
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
            _buildActiveFiltersRow(),
            _buildSortRow(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final hasActive = _filters.hasActiveFilters;
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
                    widget.category ?? 'Résultats de recherche',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    '${_filtered.length} prestataire${_filtered.length > 1 ? 's' : ''} trouvé${_filtered.length > 1 ? 's' : ''}',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: const Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            // Bouton filtre
            GestureDetector(
              onTap: _openFilters,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: hasActive
                      ? const Color(0xFF7C3AED)
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasActive
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Icon(Icons.tune_rounded,
                    size: 18,
                    color: hasActive
                        ? Colors.white
                        : const Color(0xFF374151)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Search Bar ──────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: TextField(
          controller: _searchCtrl,
          style: GoogleFonts.inter(
              fontSize: 14, color: const Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: 'Plombier, électricien, ménage…',
            hintStyle: GoogleFonts.inter(
                fontSize: 14, color: const Color(0xFF9CA3AF)),
            prefixIcon: const Icon(Icons.search_rounded,
                color: Color(0xFF9CA3AF), size: 20),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      setState(() {});
                    },
                    child: const Icon(Icons.close_rounded,
                        color: Color(0xFF9CA3AF), size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  // ─── Filtres actifs ──────────────────────────────────────────────────────────
  Widget _buildActiveFiltersRow() {
    final chips = <Widget>[];
    if (_filters.maxDistance < 20) {
      chips.add(_Chip(
        label: '≤ ${_filters.maxDistance.toInt()} km',
        onRemove: () => setState(
            () => _filters = _filters.copyWith(maxDistance: 20)),
      ));
    }
    if (_filters.minRating > 0) {
      chips.add(_Chip(
        label: '${_filters.minRating.toStringAsFixed(1)} ★ min',
        onRemove: () =>
            setState(() => _filters = _filters.copyWith(minRating: 0)),
      ));
    }
    if (_filters.minPrice > 0 || _filters.maxPrice < 150) {
      chips.add(_Chip(
        label:
            '${_filters.minPrice.toInt()}–${_filters.maxPrice.toInt()} €/h',
        onRemove: () => setState(
            () => _filters = _filters.copyWith(minPrice: 0, maxPrice: 150)),
      ));
    }
    if (_filters.availableOnly) {
      chips.add(_Chip(
        label: 'Disponible',
        onRemove: () => setState(
            () => _filters = _filters.copyWith(availableOnly: false)),
      ));
    }
    if (_filters.verifiedOnly) {
      chips.add(_Chip(
        label: 'Vérifié',
        onRemove: () => setState(
            () => _filters = _filters.copyWith(verifiedOnly: false)),
      ));
    }

    if (chips.isEmpty) return const SizedBox(height: 8);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
        children: chips
            .expand((c) => [c, const SizedBox(width: 8)])
            .toList()
          ..removeLast(),
      ),
    );
  }

  // ─── Tri ─────────────────────────────────────────────────────────────────────
  Widget _buildSortRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          Text(
            'Trier :',
            style: GoogleFonts.inter(
                fontSize: 12, color: const Color(0xFF9CA3AF)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _sortOptions.map((opt) {
                  final isSelected = _sortBy == opt;
                  return GestureDetector(
                    onTap: () => setState(() => _sortBy = opt),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7C3AED)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Text(
                        opt,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Liste des résultats ─────────────────────────────────────────────────────
  Widget _buildList() {
    final items = _filtered;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 48, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 12),
            Text(
              'Aucun prestataire trouvé',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 6),
            Text(
              'Essayez de modifier vos filtres',
              style: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFFD1D5DB)),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () =>
                  setState(() => _filters = const SearchFilters()),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF7C3AED)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Réinitialiser',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, i) => ProviderCard(
        name: items[i].name,
        expertise: items[i].expertise,
        rating: items[i].rating,
        reviewCount: items[i].reviewCount,
        distance: items[i].distance,
        price: items[i].price,
        initials: items[i].initials,
        isVerified: true,
        isAvailable: items[i].isAvailable,
        onTap: () => context.push(
          AppConstants.routeClientProviderDetail
              .replaceFirst(':id', items[i].name.toLowerCase().replaceAll(' ', '_')),
        ),
      ),
    );
  }
}

// ─── Chip filtre actif ────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _Chip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded,
                size: 13, color: Color(0xFF7C3AED)),
          ),
        ],
      ),
    );
  }
}

// ─── Données ──────────────────────────────────────────────────────────────────
class _ProviderResult {
  final String name, expertise, distance, price, initials;
  final double rating;
  final int reviewCount;
  final bool isAvailable;

  const _ProviderResult({
    required this.name,
    required this.expertise,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.price,
    required this.initials,
    required this.isAvailable,
  });
}
