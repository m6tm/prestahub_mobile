import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderDetailScreen extends StatefulWidget {
  final String providerId;
  const ProviderDetailScreen({super.key, required this.providerId});

  @override
  State<ProviderDetailScreen> createState() =>
      _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final ScrollController _scrollCtrl = ScrollController();
  double _headerOpacity = 0.0;

  static const _provider = _ProviderData(
    name: 'Jean Dupont',
    expertise: 'Plombier expert',
    rating: 4.9,
    reviewCount: 127,
    distance: '2.5 km',
    price: '35 €/h',
    initials: 'JD',
    isAvailable: true,
    completedMissions: 312,
    responseTime: '< 2h',
    bio:
        'Plombier professionnel avec plus de 15 ans d\'expérience. Dépannage d\'urgence, installation sanitaire, rénovation complète de salle de bain. Certifié RGE, assurance décennale.',
    services: [
      _ServiceData('Dépannage urgent',       Icons.water_damage_rounded,          '35 €/h',   'Intervention en moins de 2h, 7j/7'),
      _ServiceData('Rénovation salle de bain', Icons.bathtub_rounded,             'Sur devis', 'Devis gratuit, travaux clé en main'),
      _ServiceData('Installation sanitaire',  Icons.plumbing_rounded,             '35 €/h',   'Robinetterie, WC, douche, baignoire'),
      _ServiceData('Chaudière & chauffage',   Icons.local_fire_department_rounded,'45 €/h',   'Entretien, dépannage, remplacement'),
    ],
    reviews: [
      _ReviewData('Arnaud G.', 'AG', 5, 'Il y a 3 jours',    'Intervention rapide pour une fuite. Travail soigné, je recommande vivement.'),
      _ReviewData('Camille R.', 'CR', 5, 'Il y a 1 semaine', 'Très professionnel. Diagnostic immédiat, tarif respecté.'),
      _ReviewData('Théo M.',   'TM', 4, 'Il y a 2 semaines', 'Bon travail dans l\'ensemble, léger retard mais résultat nickel.'),
      _ReviewData('Isabelle K.','IK', 5, 'Il y a 1 mois',    'Chauffe-eau remplacé le jour même. Très efficace.'),
    ],
    certifications: ['RGE Qualibat', 'Assurance décennale', 'Siret vérifié'],
    languages: ['Français', 'Anglais'],
    workingHours: 'Lun – Sam : 8h – 20h\nDimanche : Sur RDV uniquement',
    zones: ['Paris 1er–10e', 'Seine-Saint-Denis', 'Val-de-Marne'],
  );

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _scrollCtrl.addListener(() {
      final op = (_scrollCtrl.offset / 120).clamp(0.0, 1.0);
      if (mounted && op != _headerOpacity) {
        setState(() => _headerOpacity = op);
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollCtrl,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeroHeader(),
                _buildProfileCard(),
                _buildTabBar(),
                _buildTabContent(),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            _buildFloatingAppBar(),
            _buildStickyCta(),
          ],
        ),
      ),
    );
  }

  // ─── Hero ─────────────────────────────────────────────────────────────────
  Widget _buildHeroHeader() {
    return SliverToBoxAdapter(
      child: Container(
        height: 240,
        color: const Color(0xFF1E1040),
        child: Stack(
          children: [
            // Fond dégradé sobre
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2D1060), Color(0xFF1E1040)],
                ),
              ),
            ),
            // Bouton retour
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
            // Avatar + nom
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Avatar
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _provider.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                      if (_provider.isAvailable)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF1E1040), width: 2.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _provider.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _provider.expertise,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.60),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Disponible maintenant',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Stats card ───────────────────────────────────────────────────────────
  Widget _buildProfileCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _StatCell('${_provider.rating}', 'Note',
                Icons.star_rounded, const Color(0xFFFBBF24)),
            _vDivider(),
            _StatCell('${_provider.reviewCount}', 'Avis',
                Icons.chat_bubble_outline_rounded, const Color(0xFF7C3AED)),
            _vDivider(),
            _StatCell('${_provider.completedMissions}', 'Missions',
                Icons.check_circle_outline_rounded, const Color(0xFF22C55E)),
            _vDivider(),
            _StatCell(_provider.responseTime, 'Réponse',
                Icons.flash_on_rounded, const Color(0xFFF59E0B)),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(
      width: 1, height: 32, color: const Color(0xFFF3F4F6));

  // ─── Tab Bar ──────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabCtrl,
          onTap: (_) => setState(() {}),
          labelStyle: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 13),
          labelColor: const Color(0xFF7C3AED),
          unselectedLabelColor: const Color(0xFF9CA3AF),
          indicatorColor: const Color(0xFF7C3AED),
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Services'),
            Tab(text: 'Avis'),
            Tab(text: 'Infos'),
          ],
        ),
      ),
    );
  }

  // ─── Tab Content ──────────────────────────────────────────────────────────
  Widget _buildTabContent() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: AnimatedBuilder(
        animation: _tabCtrl,
        builder: (context, _) {
          switch (_tabCtrl.index) {
            case 0: return _buildServicesTab();
            case 1: return _buildReviewsTab();
            case 2: return _buildInfoTab();
            default: return _buildServicesTab();
          }
        },
      ),
    );
  }

  Widget _buildServicesTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('À propos',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151))),
                const SizedBox(height: 6),
                Text(_provider.bio,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF4B5563),
                        height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Prestations',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                  letterSpacing: -0.2)),
          const SizedBox(height: 10),
          ..._provider.services.map((s) => _ServiceRow(service: s)),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingSummary(),
          const SizedBox(height: 16),
          Text('Derniers avis',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                  letterSpacing: -0.2)),
          const SizedBox(height: 10),
          ..._provider.reviews.map((r) => _ReviewRow(review: r)),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text('${_provider.rating}',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827))),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                    size: 14,
                    color: const Color(0xFFFBBF24),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text('${_provider.reviewCount} avis',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: const Color(0xFF9CA3AF))),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                _RatingBar(stars: 5, value: 0.78),
                _RatingBar(stars: 4, value: 0.15),
                _RatingBar(stars: 3, value: 0.05),
                _RatingBar(stars: 2, value: 0.01),
                _RatingBar(stars: 1, value: 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoBlock(
            title: 'Certifications',
            icon: Icons.workspace_premium_outlined,
            child: Column(
              children: _provider.certifications
                  .map((c) => _InfoLine(label: c))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _InfoBlock(
            title: 'Zones',
            icon: Icons.location_on_outlined,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _provider.zones
                  .map((z) => _Tag(label: z))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _InfoBlock(
            title: 'Horaires',
            icon: Icons.schedule_outlined,
            child: Text(_provider.workingHours,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF4B5563),
                    height: 1.6)),
          ),
          const SizedBox(height: 12),
          _InfoBlock(
            title: 'Tarif',
            icon: Icons.euro_outlined,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0xFFDDD6FE)),
                  ),
                  child: Text(_provider.price,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7C3AED))),
                ),
                const SizedBox(width: 10),
                Text('Devis gratuit',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── App bar flottante ────────────────────────────────────────────────────
  Widget _buildFloatingAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: _headerOpacity,
        child: Container(
          color: const Color(0xFF1E1040),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(_provider.name,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── CTA sticky ──────────────────────────────────────────────────────────
  Widget _buildStickyCta() {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_provider.price,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7C3AED))),
                Text('Devis gratuit',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: const Color(0xFF9CA3AF))),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text('Demander un devis',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab Bar Delegate ─────────────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool _) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          tabBar,
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}

// ─── Widgets ──────────────────────────────────────────────────────────────────
class _StatCell extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color iconColor;
  const _StatCell(this.value, this.label, this.icon, this.iconColor);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827))),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10, color: const Color(0xFF9CA3AF))),
          ],
        ),
      );
}

class _ServiceRow extends StatelessWidget {
  final _ServiceData service;
  const _ServiceRow({required this.service});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(service.icon,
                  color: const Color(0xFF7C3AED), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.title,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827))),
                  Text(service.description,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: const Color(0xFF6B7280))),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(service.price,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7C3AED))),
            ),
          ],
        ),
      );
}

class _ReviewRow extends StatelessWidget {
  final _ReviewData review;
  const _ReviewRow({required this.review});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(review.initials,
                        style: const TextStyle(
                            color: Color(0xFF7C3AED),
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.authorName,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111827))),
                      Text(review.date,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF9CA3AF))),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < review.rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 12,
                      color: const Color(0xFFFBBF24),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF4B5563),
                    height: 1.5)),
          ],
        ),
      );
}

class _RatingBar extends StatelessWidget {
  final int stars;
  final double value;
  const _RatingBar({required this.stars, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text('$stars',
                style: GoogleFonts.inter(
                    fontSize: 10, color: const Color(0xFF9CA3AF))),
            const SizedBox(width: 3),
            const Icon(Icons.star_rounded,
                size: 10, color: Color(0xFFFBBF24)),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFF3F4F6),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFBBF24)),
                ),
              ),
            ),
          ],
        ),
      );
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _InfoBlock(
      {required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 15, color: const Color(0xFF7C3AED)),
              const SizedBox(width: 7),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827))),
            ]),
            const SizedBox(height: 10),
            child,
          ],
        ),
      );
}

class _InfoLine extends StatelessWidget {
  final String label;
  const _InfoLine({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 14, color: Color(0xFF22C55E)),
          const SizedBox(width: 7),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF374151))),
        ]),
      );
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFDDD6FE)),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF7C3AED))),
      );
}

// ─── Données ──────────────────────────────────────────────────────────────────
class _ProviderData {
  final String name, expertise, distance, price, initials, bio, responseTime, workingHours;
  final double rating;
  final int reviewCount, completedMissions;
  final bool isAvailable;
  final List<_ServiceData> services;
  final List<_ReviewData> reviews;
  final List<String> certifications, languages, zones;

  const _ProviderData({
    required this.name, required this.expertise, required this.rating,
    required this.reviewCount, required this.distance, required this.price,
    required this.initials, required this.isAvailable,
    required this.completedMissions, required this.responseTime,
    required this.bio, required this.services, required this.reviews,
    required this.certifications, required this.languages,
    required this.workingHours, required this.zones,
  });
}

class _ServiceData {
  final String title, price, description;
  final IconData icon;
  const _ServiceData(this.title, this.icon, this.price, this.description);
}

class _ReviewData {
  final String authorName, initials, date, comment;
  final int rating;
  const _ReviewData(
      this.authorName, this.initials, this.rating, this.date, this.comment);
}
