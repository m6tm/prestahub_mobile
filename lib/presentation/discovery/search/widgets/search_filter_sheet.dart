import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFilters {
  final double maxDistance;
  final double minRating;
  final double minPrice;
  final double maxPrice;
  final bool availableOnly;
  final bool verifiedOnly;

  const SearchFilters({
    this.maxDistance = 20,
    this.minRating = 0,
    this.minPrice = 0,
    this.maxPrice = 150,
    this.availableOnly = false,
    this.verifiedOnly = false,
  });

  SearchFilters copyWith({
    double? maxDistance,
    double? minRating,
    double? minPrice,
    double? maxPrice,
    bool? availableOnly,
    bool? verifiedOnly,
  }) =>
      SearchFilters(
        maxDistance: maxDistance ?? this.maxDistance,
        minRating: minRating ?? this.minRating,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        availableOnly: availableOnly ?? this.availableOnly,
        verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      );

  bool get hasActiveFilters =>
      maxDistance < 20 ||
      minRating > 0 ||
      minPrice > 0 ||
      maxPrice < 150 ||
      availableOnly ||
      verifiedOnly;
}

class SearchFilterSheet extends StatefulWidget {
  final SearchFilters initialFilters;
  const SearchFilterSheet({super.key, required this.initialFilters});

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late SearchFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Titre
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                Text(
                  'Filtres',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () =>
                      setState(() => _filters = const SearchFilters()),
                  child: Text(
                    'Réinitialiser',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF7C3AED),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Distance maximale'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1 km', style: _hintStyle),
                      Text(
                        '${_filters.maxDistance.toInt()} km',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                      Text('50 km', style: _hintStyle),
                    ],
                  ),
                  _buildSlider(
                    value: _filters.maxDistance,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    onChanged: (v) => setState(
                        () => _filters = _filters.copyWith(maxDistance: v)),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 16),

                  _sectionLabel('Note minimale'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [0.0, 3.0, 3.5, 4.0, 4.5].map((r) {
                      final sel = _filters.minRating == r;
                      return GestureDetector(
                        onTap: () => setState(
                            () => _filters = _filters.copyWith(minRating: r)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: sel
                                ? const Color(0xFF7C3AED)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? const Color(0xFF7C3AED)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Text(
                            r == 0 ? 'Tout' : '${r.toStringAsFixed(1)}★',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: sel
                                  ? Colors.white
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 16),

                  _sectionLabel('Tarif horaire'),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0 €/h', style: _hintStyle),
                      Text(
                        '${_filters.minPrice.toInt()} – ${_filters.maxPrice.toInt()} €/h',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                      Text('150 €/h', style: _hintStyle),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF7C3AED),
                      inactiveTrackColor: const Color(0xFFE5E7EB),
                      thumbColor: const Color(0xFF7C3AED),
                      overlayColor:
                          const Color(0xFF7C3AED).withOpacity(0.10),
                      trackHeight: 3,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 7),
                    ),
                    child: RangeSlider(
                      values: RangeValues(
                          _filters.minPrice, _filters.maxPrice),
                      min: 0,
                      max: 150,
                      divisions: 30,
                      activeColor: const Color(0xFF7C3AED),
                      inactiveColor: const Color(0xFFE5E7EB),
                      onChanged: (r) => setState(() {
                        _filters = _filters.copyWith(
                            minPrice: r.start, maxPrice: r.end);
                      }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 12),

                  _FilterToggle(
                    label: 'Disponible maintenant',
                    subtitle: 'Uniquement les prestataires disponibles',
                    value: _filters.availableOnly,
                    onChanged: (v) => setState(
                        () => _filters = _filters.copyWith(availableOnly: v)),
                  ),
                  const SizedBox(height: 10),
                  _FilterToggle(
                    label: 'Prestataire vérifié',
                    subtitle: 'Identité et diplômes contrôlés',
                    value: _filters.verifiedOnly,
                    onChanged: (v) => setState(
                        () => _filters = _filters.copyWith(verifiedOnly: v)),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: const Color(0xFF7C3AED),
        inactiveTrackColor: const Color(0xFFE5E7EB),
        thumbColor: const Color(0xFF7C3AED),
        overlayColor: const Color(0xFF7C3AED).withOpacity(0.10),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPad),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Center(
                  child: Text(
                    'Annuler',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => Navigator.pop(context, _filters),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Appliquer',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF374151),
        ),
      );

  TextStyle get _hintStyle => GoogleFonts.inter(
        fontSize: 11,
        color: const Color(0xFF9CA3AF),
      );
}

// ─── Toggle ───────────────────────────────────────────────────────────────────
class _FilterToggle extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FilterToggle({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                    fontSize: 11, color: const Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF7C3AED),
          activeTrackColor: const Color(0xFFEDE9FE),
          inactiveThumbColor: const Color(0xFFD1D5DB),
          inactiveTrackColor: const Color(0xFFF3F4F6),
        ),
      ],
    );
  }
}
