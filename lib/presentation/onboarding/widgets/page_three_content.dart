import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Écran 3 — "Avis vérifiés, missions garanties"
/// Bouclier animé · Étoiles séquentielles · Cartes avis flottantes · Particules
class PageThreeContent extends StatefulWidget {
  final double pageOffset;

  const PageThreeContent({super.key, required this.pageOffset});

  @override
  State<PageThreeContent> createState() => _PageThreeContentState();
}

class _PageThreeContentState extends State<PageThreeContent>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _shieldCtrl;
  late AnimationController _starsCtrl;
  late AnimationController _glowCtrl;
  late List<AnimationController> _particleCtrl;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _shieldCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _starsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _particleCtrl = List.generate(10, (i) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2200 + i * 280),
      )..repeat();
    });

    // Séquence
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _shieldCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _starsCtrl.forward();
    });
  }

  @override
  void didUpdateWidget(PageThreeContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageOffset.abs() > 0.6 && widget.pageOffset.abs() <= 0.6) {
      _entranceCtrl.reset();
      _shieldCtrl.reset();
      _starsCtrl.reset();

      _entranceCtrl.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _shieldCtrl.forward();
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _starsCtrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _floatCtrl.dispose();
    _shieldCtrl.dispose();
    _starsCtrl.dispose();
    _glowCtrl.dispose();
    for (final c in _particleCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final p = widget.pageOffset.clamp(-1.0, 1.0);

    return Column(
      children: [
        // ── ILLUSTRATION ──────────────────────────────────────
        Expanded(
          flex: 62,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Particules flottantes (arrière-plan) ──
              ..._buildParticles(size, p),

              // ── Orbe de glow central ──
              Center(
                child: AnimatedBuilder(
                  animation: _glowCtrl,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(-p * 22, _floatCtrl.value * -6),
                      child: Container(
                        width: 160 + _glowCtrl.value * 20,
                        height: 160 + _glowCtrl.value * 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF7C3AED)
                                  .withOpacity(0.22 + _glowCtrl.value * 0.10),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Bouclier central ──
              Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([_shieldCtrl, _floatCtrl]),
                  builder: (context, child) => Transform.translate(
                    offset: Offset(-p * 22, _floatCtrl.value * -10),
                    child: Transform.scale(
                      scale: CurvedAnimation(
                        parent: _shieldCtrl,
                        curve: const ElasticOutCurve(0.80),
                      ).value,
                      child: child,
                    ),
                  ),
                  child: _ShieldBadge(glowCtrl: _glowCtrl),
                ),
              ),

              // ── Carte avis #1 — haut gauche ──
              Positioned(
                top: 14 - p * 34,
                left: 12 - p * 42,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceCtrl,
                    curve: const Interval(0.25, 0.80, curve: Curves.easeOut),
                  ),
                  child: AnimatedBuilder(
                    animation: _floatCtrl,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(
                        math.sin(_floatCtrl.value * math.pi) * 4,
                        _floatCtrl.value * -9,
                      ),
                      child: child,
                    ),
                    child: const _ReviewCard(
                      initials: 'ML',
                      name: 'Marie L.',
                      rating: '4.9',
                      comment: 'Travail impeccable !',
                    ),
                  ),
                ),
              ),

              // ── Carte avis #2 — bas droit ──
              Positioned(
                bottom: 36 + p * 20,
                right: 12 + p * 38,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceCtrl,
                    curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
                  ),
                  child: AnimatedBuilder(
                    animation: _floatCtrl,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(
                        math.sin((_floatCtrl.value + 0.5) * math.pi) * 4,
                        (_floatCtrl.value - 0.5) * -9,
                      ),
                      child: child,
                    ),
                    child: const _ReviewCard(
                      initials: 'TD',
                      name: 'Thomas D.',
                      rating: '5.0',
                      comment: 'Je recommande 👍',
                    ),
                  ),
                ),
              ),

              // ── Badge "vérifiés" flottant ──
              Positioned(
                top: size.height * 0.24 + p * 14,
                right: 20 + p * 22,
                child: AnimatedBuilder(
                  animation: _floatCtrl,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(p * 6, _floatCtrl.value * -13),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entranceCtrl,
                        curve: const Interval(0.35, 0.90),
                      ),
                      child: child,
                    ),
                  ),
                  child: const _VerifiedCountBadge(),
                ),
              ),

              // ── Étoiles animées ──
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: _AnimatedStarsRow(starsCtrl: _starsCtrl),
              ),
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
                curve: const Interval(0.40, 1.0, curve: Curves.easeOut),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFA78BFA),
                        Color(0xFFC4B5FD),
                        Color(0xFF60A5FA),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Avis vérifiés,\nmissions garanties',
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
                    'Chaque prestataire est vérifié, chaque avis est authentique. Votre satisfaction est notre priorité absolue.',
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

  List<Widget> _buildParticles(Size size, double p) {
    final rng = math.Random(77);
    return List.generate(_particleCtrl.length, (i) {
      final x = rng.nextDouble() * (size.width - 20) + 10;
      final y = rng.nextDouble() * (size.height * 0.58);
      final radius = 3.0 + rng.nextDouble() * 5.0;
      final ctrl = _particleCtrl[i];

      return Positioned(
        left: x - p * (6.0 + i * 2.5),
        top: y,
        child: AnimatedBuilder(
          animation: ctrl,
          builder: (context, _) {
            final t = ctrl.value;
            return Transform.translate(
              offset: Offset(
                math.sin(t * math.pi * 2 + i) * 9,
                -(t * 28),
              ),
              child: Opacity(
                opacity: ((1 - t) * 0.65).clamp(0.0, 1.0),
                child: Container(
                  width: radius,
                  height: radius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i.isEven
                        ? const Color(0xFFA78BFA).withOpacity(0.65)
                        : const Color(0xFF60A5FA).withOpacity(0.55),
                  ),
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
// Bouclier central
// ─────────────────────────────────────────────────────────────────────────────
class _ShieldBadge extends StatelessWidget {
  final AnimationController glowCtrl;
  const _ShieldBadge({required this.glowCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (context, child) => Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6D28D9)
                  .withOpacity(0.45 + glowCtrl.value * 0.20),
              blurRadius: 40 + glowCtrl.value * 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: child,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Reflet interne
                Positioned(
                  top: 4,
                  left: 8,
                  right: 8,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.22),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte avis
// ─────────────────────────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final String initials;
  final String name;
  final String rating;
  final String comment;

  const _ReviewCard({
    required this.initials,
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 162),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFA78BFA).withOpacity(0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9).withOpacity(0.18),
                blurRadius: 22,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        initials[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFBBF24), size: 11),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: const TextStyle(
                              color: Color(0xFFFBBF24),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                '"$comment"',
                style: GoogleFonts.inter(
                  color: const Color(0xFFC4B5FD),
                  fontSize: 11.5,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Badge compteur vérifiés
// ─────────────────────────────────────────────────────────────────────────────
class _VerifiedCountBadge extends StatelessWidget {
  const _VerifiedCountBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF4ADE80).withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4ADE80).withOpacity(0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF16A34A).withOpacity(0.15),
                blurRadius: 14,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_rounded,
                  color: Color(0xFF4ADE80), size: 14),
              const SizedBox(width: 6),
              Text(
                '1 247 vérifiés',
                style: GoogleFonts.inter(
                  color: const Color(0xFF4ADE80),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rangée d'étoiles animées (séquentielle)
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedStarsRow extends StatelessWidget {
  final AnimationController starsCtrl;
  const _AnimatedStarsRow({required this.starsCtrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return AnimatedBuilder(
          animation: starsCtrl,
          builder: (context, _) {
            final delay = i * 0.18;
            final rawT =
                ((starsCtrl.value - delay) / (1.0 - delay * 0.9)).clamp(0.0, 1.0);
            final scale = CurvedAnimation(
              parent: AlwaysStoppedAnimation(rawT),
              curve: const ElasticOutCurve(0.75),
            ).value;

            return Transform.scale(
              scale: scale,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.star_rounded,
                  color: const Color(0xFFFBBF24),
                  size: 32,
                  shadows: [
                    Shadow(
                      color: const Color(0xFFFBBF24).withOpacity(0.50),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
