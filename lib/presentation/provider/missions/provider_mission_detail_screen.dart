import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../requests/models/service_request_models.dart';
import 'models/provider_mission_models.dart';

/// Détail d'une mission en cours côté prestataire.
///
/// Permet de suivre le statut (acceptée → en cours → terminée) et d'agir
/// sur la mission (démarrer, terminer, contacter le client).
class ProviderMissionDetailScreen extends StatefulWidget {
  final String missionId;
  final ProviderMissionSummary? initial;

  const ProviderMissionDetailScreen({
    super.key,
    required this.missionId,
    this.initial,
  });

  @override
  State<ProviderMissionDetailScreen> createState() =>
      _ProviderMissionDetailScreenState();
}

class _ProviderMissionDetailScreenState
    extends State<ProviderMissionDetailScreen> {
  late ProviderMissionSummary? _mission;

  @override
  void initState() {
    super.initState();
    _mission = widget.initial ??
        ProviderMissionsMock.missionById(widget.missionId);
  }

  Future<void> _updateStatus(RequestStatus next) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_titleForTransition(next)),
        content: Text(_descriptionForTransition(next)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: PrestaHubTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _mission = _mission!.copyWith(status: next));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Statut mis à jour : ${next.label}'),
        backgroundColor: PrestaHubTheme.success,
      ),
    );
  }

  String _titleForTransition(RequestStatus next) {
    switch (next) {
      case RequestStatus.inProgress:
        return 'Démarrer la mission ?';
      case RequestStatus.completed:
        return 'Marquer la mission comme terminée ?';
      default:
        return 'Confirmer';
    }
  }

  String _descriptionForTransition(RequestStatus next) {
    switch (next) {
      case RequestStatus.inProgress:
        return 'Le client sera notifié du démarrage de l\'intervention.';
      case RequestStatus.completed:
        return 'Une demande d\'avis sera envoyée au client. Cette action est définitive.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mission = _mission;
    if (mission == null) {
      return const _NotFound();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.surfaceLight,
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: _ActionBar(
            mission: mission,
            onStart: () => _updateStatus(RequestStatus.inProgress),
            onComplete: () => _updateStatus(RequestStatus.completed),
            onContact: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Messagerie à venir.')),
              );
            },
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _Header(mission: mission),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Timeline(current: mission.status),
                      const SizedBox(height: 18),
                      _ClientCard(mission: mission),
                      const SizedBox(height: 14),
                      _SectionTitle('Créneau prévu'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.event_rounded,
                        label: mission.scheduledAt,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Adresse d\'intervention'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.location_on_rounded,
                        label: mission.address,
                      ),
                      const SizedBox(height: 14),
                      _SectionTitle('Tarif convenu'),
                      const SizedBox(height: 8),
                      _InfoTile(
                        icon: Icons.payments_rounded,
                        label: mission.price,
                      ),
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
}

class _Header extends StatelessWidget {
  final ProviderMissionSummary mission;
  const _Header({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: PrestaHubTheme.border),
        ),
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
                  child: const Icon(Icons.arrow_back_rounded,
                      size: 20, color: PrestaHubTheme.textLight),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: mission.status.softColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(mission.status.icon,
                        size: 13, color: mission.status.color),
                    const SizedBox(width: 5),
                    Text(
                      mission.status.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: mission.status.color,
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
                  child: Icon(mission.categoryIcon,
                      color: PrestaHubTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${mission.category} · ${mission.id}',
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

class _Timeline extends StatelessWidget {
  final RequestStatus current;
  const _Timeline({required this.current});

  @override
  Widget build(BuildContext context) {
    const steps = [
      RequestStatus.accepted,
      RequestStatus.inProgress,
      RequestStatus.completed,
    ];
    final currentIndex = steps.indexOf(current);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = (i ~/ 2) < currentIndex;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? PrestaHubTheme.success : PrestaHubTheme.border,
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < currentIndex;
          final active = idx == currentIndex;
          final label = _labelFor(steps[idx]);
          return Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: done
                      ? PrestaHubTheme.success
                      : (active
                          ? PrestaHubTheme.primary
                          : PrestaHubTheme.surface2Light),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: done
                        ? PrestaHubTheme.success
                        : (active
                            ? PrestaHubTheme.primary
                            : PrestaHubTheme.borderStrong),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  done ? Icons.check_rounded : steps[idx].icon,
                  size: 14,
                  color: done || active
                      ? Colors.white
                      : PrestaHubTheme.textMutedLight,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 74,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: done || active
                        ? PrestaHubTheme.textLight
                        : PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _labelFor(RequestStatus s) {
    switch (s) {
      case RequestStatus.accepted:
        return 'Acceptée';
      case RequestStatus.inProgress:
        return 'En cours';
      case RequestStatus.completed:
        return 'Terminée';
      default:
        return s.label;
    }
  }
}

class _ClientCard extends StatelessWidget {
  final ProviderMissionSummary mission;
  const _ClientCard({required this.mission});

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
              mission.clientInitials,
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
                  'Client',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mission.clientName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
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
              color: PrestaHubTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: PrestaHubTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PrestaHubTheme.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final ProviderMissionSummary mission;
  final VoidCallback onStart;
  final VoidCallback onComplete;
  final VoidCallback onContact;

  const _ActionBar({
    required this.mission,
    required this.onStart,
    required this.onComplete,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: Text(
                'Contacter',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: PrestaHubTheme.primary,
                side: const BorderSide(color: PrestaHubTheme.primary),
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
          child: _primaryAction(),
        ),
      ],
    );
  }

  Widget _primaryAction() {
    if (mission.status == RequestStatus.accepted) {
      return SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow_rounded, size: 20),
          label: Text(
            'Démarrer la mission',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: PrestaHubTheme.info,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
    if (mission.status == RequestStatus.inProgress) {
      return SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onComplete,
          icon: const Icon(Icons.task_alt_rounded, size: 18),
          label: Text(
            'Marquer comme terminée',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: PrestaHubTheme.success,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_rounded, size: 18),
        label: Text(
          mission.status.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: PrestaHubTheme.surface2Light,
          foregroundColor: PrestaHubTheme.textMutedLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
          'Mission introuvable',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: PrestaHubTheme.textMutedLight,
          ),
        ),
      ),
    );
  }
}
