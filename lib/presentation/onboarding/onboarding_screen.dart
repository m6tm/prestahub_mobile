import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestahub/core/constants/app_constants.dart';
import 'package:prestahub/core/services/onboarding_prefs_service.dart';
import 'package:prestahub/presentation/onboarding/widgets/page_one_content.dart';
import 'package:prestahub/presentation/onboarding/widgets/page_two_content.dart';
import 'package:prestahub/presentation/onboarding/widgets/page_three_content.dart';

/// Écran d'onboarding principal.
///
/// Architecture :
/// - Fond dégradé sombre permanent avec 3 orbes lumineux animés (floating)
/// - PageView de 3 pages entièrement custom (glassmorphism + parallaxe)
/// - Indicateurs de page en pilule (AnimatedContainer)
/// - Bouton CTA avec dégradé + glow pulsant
/// - Bouton "Ignorer" glass top-right
/// - Logo PrestaHub top-left
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── PageController ────────────────────────────────────────────────────────
  final PageController _pageCtrl = PageController();
  double _pageValue = 0.0; // valeur continue pour les effets parallaxe
  int _pageIndex = 0;      // index discret pour UI

  // ── Orbes de fond ─────────────────────────────────────────────────────────
  late AnimationController _orb1Ctrl;
  late AnimationController _orb2Ctrl;
  late AnimationController _orb3Ctrl;

  // ── Glow bouton CTA ───────────────────────────────────────────────────────
  late AnimationController _glowCtrl;

  // ── Transition de page ────────────────────────────────────────────────────
  late AnimationController _pageTransitionCtrl;

  // Couleurs thème sombre (design system Prestahub)
  static const _bgStart   = Color(0xFF0B0B0F);
  static const _bgMid     = Color(0xFF1A0A2E);
  static const _bgEnd     = Color(0xFF0D1117);
  static const _primary   = Color(0xFF7C3AED);
  static const _accent    = Color(0xFFA78BFA);
  static const _textMuted = Color(0xFFC4B5FD);

  @override
  void initState() {
    super.initState();

    // Écouter les changements de page pour parallaxe
    _pageCtrl.addListener(_onPageScroll);

    // Orbe 1 — lent (3 s)
    _orb1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    // Orbe 2 — moyen (4,2 s)
    _orb2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);

    // Orbe 3 — lent (5,5 s)
    _orb3Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    )..repeat(reverse: true);

    // Glow CTA — 2 s
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Page-transition (pour l'effet de transition de couleur des orbes)
    _pageTransitionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _onPageScroll() {
    if (!mounted) return;
    setState(() {
      _pageValue = _pageCtrl.page ?? 0.0;
    });
  }

  @override
  void dispose() {
    _pageCtrl.removeListener(_onPageScroll);
    _pageCtrl.dispose();
    _orb1Ctrl.dispose();
    _orb2Ctrl.dispose();
    _orb3Ctrl.dispose();
    _glowCtrl.dispose();
    _pageTransitionCtrl.dispose();
    super.dispose();
  }

  // ─── Navigation & completion ──────────────────────────────────────────────

  Future<void> _completeOnboarding() async {
    await OnboardingPrefsService.markSeen();
    if (mounted) context.go(AppConstants.routeLogin);
  }

  void _nextPage() {
    if (_pageIndex < 2) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _bgStart,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
      backgroundColor: _bgStart,
      body: Stack(
        children: [
          // ── 1. Fond dégradé permanent ──────────────────────────────────
          _buildBackground(),

          // ── 2. Orbes lumineux animés ───────────────────────────────────
          _buildOrb1(size),
          _buildOrb2(size),
          _buildOrb3(size),

          // ── 3. Grille de bruit subtil (simulée par opacity layer) ──────
          // (optionnel — on laisse le fond tel quel)

          // ── 4. Contenu principal ───────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Barre supérieure
                _buildTopBar(),

                // PageView
                Expanded(
                  child: PageView(
                    controller: _pageCtrl,
                    onPageChanged: (i) => setState(() => _pageIndex = i),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      PageOneContent(pageOffset: _pageValue - 0),
                      PageTwoContent(pageOffset: _pageValue - 1),
                      PageThreeContent(pageOffset: _pageValue - 2),
                    ],
                  ),
                ),

                // Indicateurs + CTA
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
      ),  // Scaffold
    );    // AnnotatedRegion
  }

  // ─── Fond ─────────────────────────────────────────────────────────────────

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_bgStart, _bgMid, _bgEnd],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  // ─── Orbes ────────────────────────────────────────────────────────────────

  Widget _buildOrb1(Size size) {
    return AnimatedBuilder(
      animation: _orb1Ctrl,
      builder: (context, _) {
        final v = _orb1Ctrl.value;
        return Positioned(
          top: -90 + v * 35,
          left: -90 + v * 25,
          child: Container(
            width: size.width * 0.72,
            height: size.width * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF6D28D9).withValues(alpha: 0.32 + v * 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrb2(Size size) {
    return AnimatedBuilder(
      animation: _orb2Ctrl,
      builder: (context, _) {
        final v = _orb2Ctrl.value;
        return Positioned(
          bottom: -110 + v * 45,
          right: -70 + v * 30,
          child: Container(
            width: size.width * 0.68,
            height: size.width * 0.68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFA78BFA).withValues(alpha: 0.18 + v * 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrb3(Size size) {
    return AnimatedBuilder(
      animation: _orb3Ctrl,
      builder: (context, _) {
        final v = _orb3Ctrl.value;
        return Positioned(
          top: size.height * 0.42 + v * 22,
          left: size.width * 0.22 + v * 18,
          child: Container(
            width: size.width * 0.52,
            height: size.width * 0.52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: 0.10 + v * 0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Barre supérieure ─────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primary, _accent],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hub_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'PrestaHub',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          // Bouton Ignorer
          GestureDetector(
            onTap: _completeOnboarding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    'Ignorer',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textMuted,
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

  // ─── Contrôles bas ────────────────────────────────────────────────────────

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
      child: Column(
        children: [
          // Indicateurs de page (pills)
          _buildPageIndicators(),
          const SizedBox(height: 28),

          // Bouton CTA avec glow
          _buildCtaButton(),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = _pageIndex == i;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 30 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: isActive
                ? const LinearGradient(
                    colors: [_primary, _accent],
                  )
                : null,
            color: isActive ? null : Colors.white.withValues(alpha: 0.18),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.40),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildCtaButton() {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (context, _) {
        final glow = _glowCtrl.value;
        return GestureDetector(
          onTap: _nextPage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.28 + glow * 0.22),
                  blurRadius: 18 + glow * 22,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.06),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Reflet interne
                Positioned(
                  top: 4,
                  left: 24,
                  right: 24,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                // Texte + icône
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _pageIndex == 2 ? 'Commencer' : 'Continuer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _pageIndex == 2
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_rounded,
                        key: ValueKey(_pageIndex),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
