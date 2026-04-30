import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../requests/models/service_request_models.dart';
import 'models/provider_mission_models.dart';

/// Détail d'une demande reçue côté prestataire.
///
/// Affiche les infos client, le besoin, l'adresse, les créneaux et propose
/// les actions accepter / refuser (avec confirmation).
class ProviderRequestDetailScreen extends StatelessWidget {
  final String requestId;
  final ProviderRequestSummary? initial;

  const ProviderRequestDetailScreen({
    super.key,
    required this.requestId,
    this.initial,
  });

  @override
  Widget build(BuildContext context) {
    final summary = initial ?? ProviderMissionsMock.requestById(requestId);
    if (summary == null) {
      return const _NotFound();
    }
    final detail = ProviderMissionsMock.detailOf(summary);
    final isPending = summary.status == RequestStatus.pending;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.surfaceLight,
        bottomNavigationBar: isPending
            ? SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: _ActionBar(
                  onAccept: () => _confirmAccept(context, summary),
                  onRefuse: () => _openRefusal(context, summary),
                ),
              )
            : null,
        body: SafeArea(
          bottom: isPending,
          child: Column(
            children: [
              _Header(summary: summary),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ClientCard(
                        name: summary.clientName,
                        initials: summary.clientInitials,
                        phone: detail.clientPhone,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Description du besoin'),
                      const SizedBox(height: 8),
                      _TextBlock(text: detail.description),
                      const SizedBox(height: 14),
                      _SectionTitle('Adresse'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.location_on_rounded,
                        label: summary.address,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Créneau souhaité'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.event_rounded,
                        label: detail.preferredDate,
                        subtitle: detail.preferredSlot,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Budget indicatif'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.payments_rounded,
                        label: summary.budgetLabel,
                      ),
                      if (summary.urgency != null) ...[
                        const SizedBox(height: 14),
                        _SectionTitle('Urgence'),
                        const SizedBox(height: 8),
                        _InfoTile(
                          icon: Icons.priority_high_rounded,
                          label: summary.urgency!,
                          emphasisColor: summary.urgency == 'Urgent'
                              ? PrestaHubTheme.danger
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAccept(
    BuildContext context,
    ProviderRequestSummary summary,
  ) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _AcceptConfirmationSheet(summary: summary),
    );
    if (!context.mounted || confirmed != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demande acceptée. Le client sera notifié.'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
    Navigator.of(context).maybePop();
  }

  Future<void> _openRefusal(
    BuildContext context,
    ProviderRequestSummary summary,
  ) async {
    final refused = await context.push<bool>(
      AppConstants.routeProviderRequestRefusal.replaceFirst(':id', summary.id),
      extra: summary,
    );
    if (!context.mounted || refused != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demande refusée. Le client sera informé.'),
        backgroundColor: PrestaHubTheme.warning,
      ),
    );
    Navigator.of(context).maybePop();
  }
}

class _Header extends StatelessWidget {
  final ProviderRequestSummary summary;
  const _Header({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.surface2Light,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: summary.status.softColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      summary.status.icon,
                      size: 13,
                      color: summary.status.color,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      summary.status.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: summary.status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    summary.categoryIcon,
                    color: PrestaHubTheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${summary.category} · ${summary.receivedAt}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: PrestaHubTheme.textMutedLight,
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
    );
  }
}

class _ClientCard extends StatelessWidget {
  final String name;
  final String initials;
  final String phone;
  const _ClientCard({
    required this.name,
    required this.initials,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: PrestaHubTheme.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          _CircleAction(
            icon: Icons.chat_bubble_outline_rounded,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('La messagerie s\'ouvrira après acceptation.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: PrestaHubTheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: PrestaHubTheme.primary, size: 18),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: PrestaHubTheme.textMutedLight,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String text;
  const _TextBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13.5,
          color: PrestaHubTheme.textLight,
          height: 1.5,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? emphasisColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.emphasisColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = emphasisColor ?? PrestaHubTheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onRefuse;
  const _ActionBar({required this.onAccept, required this.onRefuse});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: onRefuse,
              icon: const Icon(Icons.close_rounded, size: 18),
              label: Text(
                'Refuser',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: PrestaHubTheme.danger,
                side: const BorderSide(color: PrestaHubTheme.danger),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onAccept,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(
                'Placer une offre',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: PrestaHubTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AcceptConfirmationSheet extends StatelessWidget {
  final ProviderRequestSummary summary;
  const _AcceptConfirmationSheet({required this.summary});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PrestaHubTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PrestaHubTheme.success.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: PrestaHubTheme.success,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Accepter cette demande ?',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Vous vous engagez à intervenir sur « ${summary.title} » auprès de ${summary.clientName}. La mission apparaîtra dans votre planning.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: PrestaHubTheme.textMutedLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: PrestaHubTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Confirmer l\'acceptation',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Annuler',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: PrestaHubTheme.textMutedLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: Text(
          'Demande introuvable',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
      ),
    );
  }
}
