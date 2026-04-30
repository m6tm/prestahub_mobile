import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../requests/models/service_request_models.dart';
import 'models/provider_mission_models.dart';

/// Historique des missions terminées ou annulées.
class ProviderMissionHistoryScreen extends StatefulWidget {
  const ProviderMissionHistoryScreen({super.key});

  @override
  State<ProviderMissionHistoryScreen> createState() =>
      _ProviderMissionHistoryScreenState();
}

class _ProviderMissionHistoryScreenState
    extends State<ProviderMissionHistoryScreen> {
  int _selectedTab = 0;

  List<ProviderMissionSummary> get _filtered {
    final all = ProviderMissionsMock.missionsCompleted;
    switch (_selectedTab) {
      case 0:
        return all
            .where((m) => m.status == RequestStatus.completed)
            .toList();
      case 1:
        return all
            .where((m) => m.status == RequestStatus.cancelled)
            .toList();
      case 2:
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final completedCount = ProviderMissionsMock.missionsCompleted
        .where((m) => m.status == RequestStatus.completed)
        .length;
    final avgRating = _averageRating(ProviderMissionsMock.missionsCompleted);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _Header(
                completedCount: completedCount,
                avgRating: avgRating,
              ),
              _Tabs(
                selected: _selectedTab,
                onChanged: (i) => setState(() => _selectedTab = i),
              ),
              Expanded(
                child: items.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, i) => _HistoryCard(
                          mission: items[i],
                          onTap: () => context.push(
                            AppConstants.routeProviderPastMissionDetail
                                .replaceFirst(':id', items[i].id),
                            extra: items[i],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _averageRating(List<ProviderMissionSummary> missions) {
    final rated = missions
        .where((m) => m.clientRating != null)
        .map((m) => m.clientRating!)
        .toList();
    if (rated.isEmpty) return null;
    return rated.reduce((a, b) => a + b) / rated.length;
  }
}

class _Header extends StatelessWidget {
  final int completedCount;
  final double? avgRating;

  const _Header({
    required this.completedCount,
    required this.avgRating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
              const SizedBox(width: 12),
              Text(
                'Historique',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.textLight,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.task_alt_rounded,
                  label: 'Missions',
                  value: completedCount.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.star_rounded,
                  label: 'Note moyenne',
                  value: avgRating != null
                      ? avgRating!.toStringAsFixed(1)
                      : '—',
                  color: PrestaHubTheme.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? PrestaHubTheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: c, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: PrestaHubTheme.textMutedLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _Tabs({required this.selected, required this.onChanged});

  static const _items = ['Terminées', 'Annulées', 'Toutes'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: PrestaHubTheme.surface2Light,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final active = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _items[i],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? PrestaHubTheme.primary
                        : PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ProviderMissionSummary mission;
  final VoidCallback onTap;
  const _HistoryCard({required this.mission, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: PrestaHubTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PrestaHubTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    alignment: Alignment.center,
                    child: Icon(mission.categoryIcon,
                        color: PrestaHubTheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: PrestaHubTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${mission.category} · ${mission.completedOn ?? ''}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: PrestaHubTheme.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: mission.status.softColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mission.status.label,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: mission.status.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    mission.clientName,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                  const Spacer(),
                  if (mission.clientRating != null) ...[
                    const Icon(Icons.star_rounded,
                        size: 16, color: PrestaHubTheme.warning),
                    const SizedBox(width: 3),
                    Text(
                      mission.clientRating!.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    mission.price,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PrestaHubTheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: PrestaHubTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.history_rounded,
                  color: PrestaHubTheme.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune mission dans cette catégorie',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Vos missions terminées et annulées s\'afficheront ici.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: PrestaHubTheme.textMutedLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
