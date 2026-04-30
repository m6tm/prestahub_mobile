import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../models/conversation_models.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  final ConversationSummary? peer;

  const CallScreen({super.key, required this.callId, this.peer});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with TickerProviderStateMixin {
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  bool _connecting = true;
  bool _muted = false;
  bool _speakerOn = true;
  bool _onHold = false;

  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _connecting = false);
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '${h.toString().padLeft(2, '0')}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final peer = widget.peer;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0B1F),
        body: Stack(
          children: [
            _buildGradientBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  const Spacer(),
                  _buildAvatar(peer),
                  const SizedBox(height: 24),
                  Text(
                    peer?.peerName ?? 'Correspondant',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _connecting
                        ? 'Connexion en cours…'
                        : _onHold
                            ? 'Appel en attente'
                            : _formatDuration(_elapsed),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                  if (peer != null) ...[
                    const SizedBox(height: 24),
                    _buildRequestChip(peer),
                  ],
                  const Spacer(),
                  _buildSecondaryActions(),
                  const SizedBox(height: 32),
                  _buildHangupButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.4),
          radius: 1.2,
          colors: [
            Color(0xFF2B1760),
            Color(0xFF0F0B1F),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 22, color: Colors.white),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _connecting
                        ? PrestaHubTheme.warning
                        : PrestaHubTheme.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _connecting ? 'En cours' : 'Chiffré',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ConversationSummary? peer) {
    final color = peer?.peerColor ?? PrestaHubTheme.primary;
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (context, _) {
              final t = _pulseCtrl.value;
              return Container(
                width: 140 + t * 60,
                height: 140 + t * 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.18 * (1 - t)),
                ),
              );
            },
          ),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              peer?.peerInitials ?? '?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestChip(ConversationSummary peer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.description_rounded,
              size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            peer.requestTitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CallAction(
          icon: _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
          label: _muted ? 'Micro coupé' : 'Micro',
          active: _muted,
          onTap: () => setState(() => _muted = !_muted),
        ),
        _CallAction(
          icon:
              _speakerOn ? Icons.volume_up_rounded : Icons.hearing_rounded,
          label: _speakerOn ? 'Haut-parleur' : 'Écouteur',
          active: _speakerOn,
          onTap: () => setState(() => _speakerOn = !_speakerOn),
        ),
        _CallAction(
          icon: Icons.dialpad_rounded,
          label: 'Clavier',
          active: false,
          onTap: () {},
        ),
        _CallAction(
          icon: _onHold ? Icons.play_arrow_rounded : Icons.pause_rounded,
          label: _onHold ? 'Reprendre' : 'Pause',
          active: _onHold,
          onTap: () => setState(() => _onHold = !_onHold),
        ),
      ],
    );
  }

  Widget _buildHangupButton() {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: PrestaHubTheme.danger,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: PrestaHubTheme.danger.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: 2.3,
            child: const Icon(Icons.call_rounded,
                size: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _CallAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CallAction({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: active
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: active ? 0 : 0.12),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 22,
              color: active ? const Color(0xFF0F0B1F) : Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
