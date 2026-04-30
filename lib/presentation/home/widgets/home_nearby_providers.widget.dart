import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import 'provider_card.widget.dart';

/// Section "Prestataires à proximité" — liste de ProviderCard glassmorphiques.
class HomeNearbyProviders extends StatelessWidget {
  const HomeNearbyProviders({super.key});

  static const _providers = [
    _ProviderData(
      name: 'Jean Dupont',
      expertise: 'Plombier expert',
      rating: 4.9,
      reviewCount: 127,
      distance: '2.5 km',
      price: '35 €/h',
      initials: 'JD',
      isAvailable: true,
    ),
    _ProviderData(
      name: 'Marie Leroi',
      expertise: 'Spécialiste ménage',
      rating: 4.7,
      reviewCount: 89,
      distance: '1.2 km',
      price: '20 €/h',
      initials: 'ML',
      isAvailable: true,
    ),
    _ProviderData(
      name: 'Marc Bernard',
      expertise: 'Électricien certifié',
      rating: 4.8,
      reviewCount: 214,
      distance: '3.8 km',
      price: '45 €/h',
      initials: 'MB',
      isAvailable: false,
    ),
    _ProviderData(
      name: 'Sophie Blanc',
      expertise: 'Peintre décorateur',
      rating: 4.6,
      reviewCount: 58,
      distance: '0.8 km',
      price: '30 €/h',
      initials: 'SB',
      isAvailable: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de section
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Près de chez vous',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                    letterSpacing: -0.3,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF7C3AED),
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Paris',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF7C3AED),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Liste des cartes prestataires
          ..._providers.map(
            (p) => ProviderCard(
              name: p.name,
              expertise: p.expertise,
              rating: p.rating,
              reviewCount: p.reviewCount,
              distance: p.distance,
              price: p.price,
              initials: p.initials,
              isVerified: true,
              isAvailable: p.isAvailable,
              onTap: () => context.push(
                AppConstants.routeClientProviderDetail.replaceFirst(':id', p.name.toLowerCase().replaceAll(' ', '_')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderData {
  final String name;
  final String expertise;
  final double rating;
  final int reviewCount;
  final String distance;
  final String price;
  final String initials;
  final bool isAvailable;

  const _ProviderData({
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
