import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Écran 1 — "Découvrez les meilleurs prestataires"
/// Parallaxe · Glassmorphism · Cartes flottantes · Chips services
class PageOneContent extends StatefulWidget {
  final double pageOffset;

  const PageOneContent({super.key, required this.pageOffset});

  @override
  State<PageOneContent> createState() => _PageOneContentState();
}

class _PageOneContentState extends State<PageOneContent>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _shimmerCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void didUpdateWidget(PageOneContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageOffset.abs() > 0.6 && widget.pageOffset.abs() <= 0.6) {
      _entranceCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final p = widget.pageOffset.clamp(-1.0, 1.0); // parallax factor

    return Column(
      children: [
        // ── ILLUSTRATION ──────────────────────────────────────
        Expanded(
          flex: 62,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Carte prestataire centrale (couche du milieu) ──
              Positioned(
                left: size.width * 0.08 - p * 35,
                right: size.width * 0.08 + p * 35,
                top: 36,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: AnimatedBuilder(
                      animation: _floatCtrl,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(p * 8, _floatCtrl.value * -10),
                        child: child,
                      ),
                      child: _ProviderCard(shimmerCtrl: _shimmerCtrl),
                    ),
                  ),
                ),
              ),

              // ── Chip Plomberie — haut gauche (couche avant) ──
              Positioned(
                top: 12 - p * 55,
                left: 16 - p * 28,
                child: _FloatingChip(
                  floatCtrl: _floatCtrl,
                  phaseShift: 0.0,
                  entranceCtrl: _entranceCtrl,
                  entranceInterval: const Interval(0.1, 0.6),
                  parallaxFactor: p * 1.6,
                  emoji: '🔧',
                  label: 'Plomberie',
                  color: const Color(0xFF60A5FA),
                ),
              ),

              // ── Chip Électricité — haut droit ──
              Positioned(
                top: 60 + p * 30,
                right: 14 + p * 20,
                child: _FloatingChip(
                  floatCtrl: _floatCtrl,
                  phaseShift: 0.25,
                  entranceCtrl: _entranceCtrl,
                  entranceInterval: const Interval(0.2, 0.7),
                  parallaxFactor: p * -1.4,
                  emoji: '⚡',
                  label: 'Électricité',
                  color: const Color(0xFFFBBF24),
                ),
              ),

              // ── Chip Jardinage — bas gauche ──
              Positioned(
                bottom: 54 + p * 18,
                left: 22 - p * 22,
                child: _FloatingChip(
                  floatCtrl: _floatCtrl,
                  phaseShift: 0.5,
                  entranceCtrl: _entranceCtrl,
                  entranceInterval: const Interval(0.3, 0.8),
                  parallaxFactor: p * 1.2,
                  emoji: '🌿',
                  label: 'Jardinage',
                  color: const Color(0xFF4ADE80),
                ),
              ),

              // ── Chip Ménage — bas droit ──
              Positioned(
                bottom: 20 - p * 12,
                right: 20 + p * 18,
                child: _FloatingChip(
                  floatCtrl: _floatCtrl,
                  phaseShift: 0.75,
                  entranceCtrl: _entranceCtrl,
                  entranceInterval: const Interval(0.4, 0.9),
                  parallaxFactor: p * -1.1,
                  emoji: '🏠',
                  label: 'Ménage',
                  color: const Color(0xFFF87171),
                ),
              ),

              // ── Étoiles / sparkles (couche de fond) ──
              ..._buildSparkles(size, p),
            ],
          ),
        ),

        // ── TEXTE ─────────────────────────────────────────────
        Expanded(
          flex: 38,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _entranceCtrl,
                curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF7C3AED),
                        Color(0xFFA78BFA),
                        Color(0xFF60A5FA),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Découvrez les meilleurs\nprestataires',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Trouvez des professionnels vérifiés près de chez vous pour tous vos besoins du quotidien.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      color: const Color(0xFFC4B5FD),
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSparkles(Size size, double p) {
    final positions = [
      [0.12, 0.08],
      [0.88, 0.12],
      [0.07, 0.62],
      [0.92, 0.55],
      [0.50, 0.03],
      [0.30, 0.85],
    ];

    return List.generate(positions.length, (i) {
      return Positioned(
        left: size.width * positions[i][0] - p * (8.0 + i * 4.0),
        top: size.height * 0.55 * positions[i][1],
        child: AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (context, _) {
            final pulse =
                math.sin((_pulseCtrl.value + i * 0.18) * math.pi);
            return Opacity(
              opacity: (0.35 + pulse * 0.5).clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.65 + pulse * 0.38,
                child: Icon(
                  i.isEven ? Icons.star_rounded : Icons.auto_awesome_rounded,
                  size: 13.0 + i * 1.8,
                  color: const Color(0xFFA78BFA).withValues(alpha: 0.85),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte Prestataire (glass)
// ─────────────────────────────────────────────────────────────────────────────
class _ProviderCard extends StatelessWidget {
  final AnimationController shimmerCtrl;

  const _ProviderCard({required this.shimmerCtrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFA78BFA).withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9).withValues(alpha: 0.28),
                blurRadius: 36,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.04),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildStats(),
              const SizedBox(height: 16),
              _buildTags(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'AB',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Antoine B.',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 7),
                  _VerifiedBadge(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Plombier · Île-de-France',
                style: GoogleFonts.inter(
                  color: const Color(0xFFC4B5FD),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        // Étoile note rapide
        Column(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 20),
            Text(
              '4.9',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFBBF24),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            _StatCell(value: '127', label: 'Missions'),
            _VertDivider(),
            _StatCell(value: '98%', label: 'Satisfaction'),
            _VertDivider(),
            _StatCell(value: '< 2h', label: 'Réponse'),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: ['Urgence 24h', 'Devis gratuit', 'Certifié RGE'].map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFA78BFA).withValues(alpha: 0.22),
            ),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: Color(0xFFC4B5FD),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF4ADE80).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF4ADE80),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'Vérifié',
            style: TextStyle(
              color: Color(0xFF4ADE80),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFA78BFA),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip flottant (glassmorphism)
// ─────────────────────────────────────────────────────────────────────────────
class _FloatingChip extends StatelessWidget {
  final AnimationController floatCtrl;
  final AnimationController entranceCtrl;
  final Interval entranceInterval;
  final double phaseShift;
  final double parallaxFactor;
  final String emoji;
  final String label;
  final Color color;

  const _FloatingChip({
    required this.floatCtrl,
    required this.entranceCtrl,
    required this.entranceInterval,
    required this.phaseShift,
    required this.parallaxFactor,
    required this.emoji,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: entranceCtrl, curve: entranceInterval),
      child: AnimatedBuilder(
        animation: floatCtrl,
        builder: (context, child) {
          final t = floatCtrl.value + phaseShift;
          return Transform.translate(
            offset: Offset(
              math.sin(t * math.pi) * 4 + parallaxFactor * 6,
              math.cos(t * math.pi * 0.7) * 6,
            ),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.28)),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 15)),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
