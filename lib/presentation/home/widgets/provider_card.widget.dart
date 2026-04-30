import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Carte prestataire — design épuré, palette neutre
class ProviderCard extends StatelessWidget {
  final String name;
  final String expertise;
  final double rating;
  final int reviewCount;
  final String distance;
  final String price;
  final String initials;
  final bool isVerified;
  final bool isAvailable;
  final VoidCallback? onTap;

  const ProviderCard({
    super.key,
    required this.name,
    required this.expertise,
    required this.rating,
    this.reviewCount = 0,
    required this.distance,
    required this.price,
    required this.initials,
    this.isVerified = true,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo()),
            _buildCta(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF7C3AED),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (isAvailable)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified_rounded,
                  size: 13, color: Color(0xFF7C3AED)),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          expertise,
          style: GoogleFonts.inter(
              fontSize: 12, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star_rounded,
                color: Color(0xFFFBBF24), size: 13),
            const SizedBox(width: 3),
            Text(
              rating.toStringAsFixed(1),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
            if (reviewCount > 0)
              Text(
                ' ($reviewCount)',
                style: GoogleFonts.inter(
                    fontSize: 11, color: const Color(0xFF9CA3AF)),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.location_on_rounded,
                color: Color(0xFF9CA3AF), size: 12),
            const SizedBox(width: 2),
            Text(
              distance,
              style: GoogleFonts.inter(
                  fontSize: 11, color: const Color(0xFF6B7280)),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7C3AED),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCta() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(9),
        ),
        child: const Icon(Icons.arrow_forward_ios_rounded,
            color: Color(0xFF7C3AED), size: 13),
      ),
    );
  }
}
