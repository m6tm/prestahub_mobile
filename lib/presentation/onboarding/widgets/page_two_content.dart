import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Écran 2 — "Réservez en quelques secondes"
/// Calendrier glassmorphique · Bulles de chat animées · Badge de confirmation spring
class PageTwoContent extends StatefulWidget {
  final double pageOffset;

  const PageTwoContent({super.key, required this.pageOffset});

  @override
  State<PageTwoContent> createState() => _PageTwoContentState();
}

class _PageTwoContentState extends State<PageTwoContent>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _bubble1Ctrl;
  late AnimationController _bubble2Ctrl;
  late AnimationController _confirmCtrl;
  late AnimationController _dotCtrl;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    _bubble1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bubble2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _confirmCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _dotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Séquence d'apparition des bulles
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _bubble1Ctrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _bubble2Ctrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _confirmCtrl.forward();
    });
  }

  @override
  void didUpdateWidget(PageTwoContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageOffset.abs() > 0.6 && widget.pageOffset.abs() <= 0.6) {
      _entranceCtrl.reset();
      _bubble1Ctrl.reset();
      _bubble2Ctrl.reset();
      _confirmCtrl.reset();

      _entranceCtrl.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _bubble1Ctrl.forward();
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _bubble2Ctrl.forward();
      });
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) _confirmCtrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _floatCtrl.dispose();
    _bubble1Ctrl.dispose();
    _bubble2Ctrl.dispose();
    _confirmCtrl.dispose();
    _dotCtrl.dispose();
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
              // ── Carte calendrier centrale ──
              Positioned(
                left: 20 - p * 28,
                right: 20 + p * 28,
                top: 36,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceCtrl,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                  ),
                  child: AnimatedBuilder(
                    animation: _floatCtrl,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(p * 6, _floatCtrl.value * -8),
                      child: child,
                    ),
                    child: const _CalendarCard(),
                  ),
                ),
              ),

              // ── Bulle client (gauche) ──
              Positioned(
                left: 16 - p * 40,
                bottom: 110 + p * 18,
                child: AnimatedBuilder(
                  animation: _bubble1Ctrl,
                  builder: (context, child) {
                    final anim = CurvedAnimation(
                      parent: _bubble1Ctrl,
                      curve: const ElasticOutCurve(0.85),
                    );
                    return FadeTransition(
                      opacity: _bubble1Ctrl,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-0.6, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    );
                  },
                  child: _ChatBubble(
                    text: 'Besoin d\'un plombier\naujourd\'hui 🔧',
                    isClient: true,
                  ),
                ),
              ),

              // ── Bulle prestataire (droite) ──
              Positioned(
                right: 16 + p * 40,
                bottom: 50 - p * 14,
                child: AnimatedBuilder(
                  animation: _bubble2Ctrl,
                  builder: (context, child) {
                    final anim = CurvedAnimation(
                      parent: _bubble2Ctrl,
                      curve: const ElasticOutCurve(0.85),
                    );
                    return FadeTransition(
                      opacity: _bubble2Ctrl,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.6, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    );
                  },
                  child: _ChatBubble(
                    text: 'Je suis disponible\ndans 1h ✅',
                    isClient: false,
                  ),
                ),
              ),

              // ── Badge de confirmation ──
              Positioned(
                right: 24 - p * 22,
                top: size.height * 0.28 + p * 28,
                child: AnimatedBuilder(
                  animation: _confirmCtrl,
                  builder: (context, child) => Transform.scale(
                    scale: CurvedAnimation(
                      parent: _confirmCtrl,
                      curve: const ElasticOutCurve(0.75),
                    ).value,
                    child: FadeTransition(
                      opacity: _confirmCtrl,
                      child: child,
                    ),
                  ),
                  child: const _ConfirmBadge(),
                ),
              ),

              // ── Chip horaire flottant ──
              Positioned(
                left: 14 - p * 32,
                top: 20 + p * 20,
                child: AnimatedBuilder(
                  animation: _floatCtrl,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(
                      math.sin(_floatCtrl.value * math.pi) * 5,
                      _floatCtrl.value * -12,
                    ),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entranceCtrl,
                        curve: const Interval(0.2, 0.8),
                      ),
                      child: child,
                    ),
                  ),
                  child: _TimeChip(dotCtrl: _dotCtrl),
                ),
              ),

              // ── Indicateur de frappe (typing dots) ──
              Positioned(
                left: 20 - p * 25,
                bottom: 22 + p * 10,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceCtrl,
                    curve: const Interval(0.5, 1.0),
                  ),
                  child: _TypingIndicator(dotCtrl: _dotCtrl),
                ),
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
                curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFFA78BFA),
                        Color(0xFF60A5FA),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Réservez en\nquelques secondes',
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
                    'Échangez directement avec votre prestataire, fixez un créneau et suivez votre mission en temps réel.',
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte calendrier
// ─────────────────────────────────────────────────────────────────────────────
class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  String _monthName(int m) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const dayLetters = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final todayIndex = now.weekday - 1; // 0 = lundi

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFA78BFA).withOpacity(0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9).withOpacity(0.22),
                blurRadius: 36,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.04),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête mois
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_monthName(now.month)} ${now.year}',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Disponible',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Jours de la semaine
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: dayLetters
                    .map(
                      (d) => Text(
                        d,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),

              // Rangée de jours (semaine courante)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (i) {
                  final day = now.day - todayIndex + i;
                  final isToday = i == todayIndex;
                  final isSelected = i == (todayIndex + 1) % 7;
                  final displayDay = day > 0 ? day : day + 28;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                            )
                          : null,
                      color: isToday && !isSelected
                          ? const Color(0xFF7C3AED).withOpacity(0.18)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF6D28D9).withOpacity(0.40),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$displayDay',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? const Color(0xFFA78BFA)
                                  : const Color(0xFF9CA3AF),
                          fontWeight:
                              (isSelected || isToday) ? FontWeight.w700 : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Créneaux horaires
              Row(
                children: ['09:00', '11:00', '14:00', '16:00']
                    .asMap()
                    .entries
                    .map((e) {
                  final isSelected = e.key == 2;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: e.key < 3 ? 6 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFFA78BFA).withOpacity(0.14),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF6D28D9).withOpacity(0.35),
                                  blurRadius: 10,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF9CA3AF),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bulle de chat
// ─────────────────────────────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isClient;

  const _ChatBubble({required this.text, required this.isClient});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isClient ? Radius.zero : const Radius.circular(18),
      bottomRight: isClient ? const Radius.circular(18) : Radius.zero,
    );

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 185),
          decoration: BoxDecoration(
            color: isClient
                ? const Color(0xFF7C3AED).withOpacity(0.65)
                : Colors.white.withOpacity(0.09),
            borderRadius: radius,
            border: Border.all(
              color: isClient
                  ? const Color(0xFFA78BFA).withOpacity(0.30)
                  : Colors.white.withOpacity(0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: isClient
                    ? const Color(0xFF6D28D9).withOpacity(0.30)
                    : Colors.black.withOpacity(0.15),
                blurRadius: 16,
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Badge confirmation
// ─────────────────────────────────────────────────────────────────────────────
class _ConfirmBadge extends StatelessWidget {
  const _ConfirmBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A).withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4ADE80).withOpacity(0.32),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF16A34A).withOpacity(0.25),
                blurRadius: 18,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF4ADE80),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Réservé !',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF4ADE80),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
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
// Chip horaire
// ─────────────────────────────────────────────────────────────────────────────
class _TimeChip extends StatelessWidget {
  final AnimationController dotCtrl;
  const _TimeChip({required this.dotCtrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF60A5FA).withOpacity(0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: Color(0xFF60A5FA),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                '14:00 · Aujourd\'hui',
                style: GoogleFonts.inter(
                  color: const Color(0xFF60A5FA),
                  fontSize: 12,
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
// Indicateur de frappe (3 dots animés)
// ─────────────────────────────────────────────────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  final AnimationController dotCtrl;
  const _TypingIndicator({required this.dotCtrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(14),
        topRight: Radius.circular(14),
        bottomRight: Radius.circular(14),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: AnimatedBuilder(
            animation: dotCtrl,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final delay = i * 0.33;
                  final t = ((dotCtrl.value - delay + 1.0) % 1.0);
                  final scale = 0.6 + math.sin(t * math.pi) * 0.4;
                  return Container(
                    margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFC4B5FD)
                          .withOpacity(0.4 + scale * 0.5),
                    ),
                    transform: Matrix4.identity()
                      ..translate(0.0, -scale * 3),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
