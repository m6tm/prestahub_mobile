import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/translations.g.dart';
import 'provider_card.widget.dart';

/// Section listant les prestataires à proximité de l'utilisateur.
class HomeNearbyProviders extends StatelessWidget {
  const HomeNearbyProviders({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.home.nearbyProviders,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.grey, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    t.home.locationIndicator,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? PrestaHubTheme.textMutedDark : PrestaHubTheme.textMutedLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: const [
                ProviderCard(
                  name: 'Jean Dupont',
                  expertise: 'Plombier expert',
                  rating: 4.9,
                  distance: '2.5 km',
                  price: '15 €/h',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDrrcNkE6hto4xo5nLg3iQY4FbUqt_Zj1s_oY5dQVi3CfN3Sf6EtBEjY9leHDdJCnonpZik6jbQGpMf_fkI_dbiV5Y6J_Eo7G5ErikE61i0GmIBgaaOAJjydiFrLPmMwaqcaGVY7TvaWI82oYagJS1xnuEH7eaTDf3U8XkFJE3xj_3If-NfAMksmlJdlAgWVbhnUHFmhBT8zYNRv6z8_G-3KLH1AkehIbadnnNdbHDdPCYBYvT6sKZH4J4VMpQlDktSg8pBRfvDQCma',
                ),
                ProviderCard(
                  name: 'Marie Leroi',
                  expertise: 'Spécialiste Ménage',
                  rating: 4.7,
                  distance: '1.2 km',
                  price: '20 €/h',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBJkcpyXnCoJT-ARqY4Qtc4k1cafcmbqkxs2A1GrOX4bm-lLb4icwXWkVlelW7SufoCO2EvF394tFcEhI8TFaZ9JexfFSRXTvqawNFoloDOsf-Phq23RDkNgl5SDUelrlv1dJF5MoFwvyjDiBSP5K9hb7X-hr2N3Mh0ZLO7eRlBQAWSd-nJ7eFMbRM5de56V2pMwgn5YBayQNFxgiBaj4Loqq01P2vhTrJ-u_5an7ohoM0NiDcnd5evob1ldPeOAbz9vCfbsqb0CYdN',
                ),
                ProviderCard(
                  name: 'Marc Bernard',
                  expertise: 'Électricien certifié',
                  rating: 4.8,
                  distance: '3.8 km',
                  price: '35 €/h',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCwpEo_Z3KxSgyn_zPJVW0Uw1aV4SBPonnsj7l9VLKSYNt5yooHEdTI8L0-DamSldQ8iENkALdkrK9xIVSMDIORcSkKD0gyO-15p3yBM-J-E8qylH1OBHd-4xqVXPZujfVpGq6RI-GUaVKXkqUDaD29gKEHaOsPR0LSYY9PahvOF9qOL9gP899jJnLHpjgGlZX2W0Ui-srF3LPhpz5JjH155DmtbDxWZD5cGFg4JLxm1C-2i65bPdhniWZwhxfPmSEtOq4mpHcCzquC',
                ),
                SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }
}
