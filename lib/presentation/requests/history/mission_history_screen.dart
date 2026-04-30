import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../reviews/models/review_context.dart';
import '../models/service_request_models.dart';

class MissionHistoryScreen extends StatefulWidget {
  const MissionHistoryScreen({super.key});

  @override
  State<MissionHistoryScreen> createState() => _MissionHistoryScreenState();
}

class _MissionHistoryScreenState extends State<MissionHistoryScreen> {
  String _activeFilter = 'Toutes';
  static const _filters = ['Toutes', 'Terminées', 'Annulées', 'Refusées'];

  static final _missions = <MissionSummary>[
    MissionSummary(
      id: 'MIS-0881',
      title: 'Installation chauffe-eau',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.completed,
      completedOn: '15 avr. 2026',
      providerName: 'Jean Dupont',
      providerInitials: 'JD',
      price: '210 €',
      rating: 5.0,
      hasReview: true,
    ),
    MissionSummary(
      id: 'MIS-0792',
      title: 'Ménage grand nettoyage',
      category: 'Ménage',
      categoryIcon: Icons.cleaning_services_rounded,
      status: RequestStatus.completed,
      completedOn: '2 avr. 2026',
      providerName: 'Sophie Blanc',
      providerInitials: 'SB',
      price: '85 €',
      rating: 4.5,
      hasReview: true,
    ),
    MissionSummary(
      id: 'MIS-0745',
      title: 'Dépannage prise électrique',
      category: 'Électricité',
      categoryIcon: Icons.bolt_rounded,
      status: RequestStatus.completed,
      completedOn: '22 mars 2026',
      providerName: 'Marie Leroi',
      providerInitials: 'ML',
      price: '60 €',
      hasReview: false,
    ),
    MissionSummary(
      id: 'MIS-0721',
      title: 'Peinture chambre',
      category: 'Peinture',
      categoryIcon: Icons.format_paint_rounded,
      status: RequestStatus.cancelled,
      completedOn: '10 mars 2026',
      providerName: 'Laura Petit',
      providerInitials: 'LP',
      price: '—',
    ),
    MissionSummary(
      id: 'MIS-0708',
      title: 'Tonte pelouse',
      category: 'Jardinage',
      categoryIcon: Icons.yard_rounded,
      status: RequestStatus.rejected,
      completedOn: '1er mars 2026',
      providerName: 'Karim Ould',
      providerInitials: 'KO',
      price: '—',
    ),
  ];

  List<MissionSummary> get _filtered {
    switch (_activeFilter) {
      case 'Terminées':
        return _missions
            .where((m) => m.status == RequestStatus.completed)
            .toList();
      case 'Annulées':
        return _missions
            .where((m) => m.status == RequestStatus.cancelled)
            .toList();
      case 'Refusées':
        return _missions
            .where((m) => m.status == RequestStatus.rejected)
            .toList();
      default:
        return _missions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildStats(),
              _buildFilters(),
              Expanded(
                child: items.isEmpty ? _buildEmpty() : _buildList(items),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: PrestaHubTheme.textMutedLight),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historique',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${_missions.length} missions au total',
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
    );
  }

  Widget _buildStats() {
    final completed =
        _missions.where((m) => m.status == RequestStatus.completed).length;
    final totalSpent = _missions
        .where((m) => m.status == RequestStatus.completed)
        .fold<double>(
          0,
          (sum, m) =>
              sum + (double.tryParse(m.price.replaceAll(' €', '')) ?? 0),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: PrestaHubTheme.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PrestaHubTheme.border),
          boxShadow: [
            BoxShadow(
              color: PrestaHubTheme.textLight.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _statCell(
              '$completed',
              'Terminées',
              Icons.task_alt_rounded,
              PrestaHubTheme.success,
            ),
            _vDivider(),
            _statCell(
              '${totalSpent.toInt()} €',
              'Dépensé',
              Icons.euro_rounded,
              PrestaHubTheme.primary,
            ),
            _vDivider(),
            _statCell(
              '${_missions.length}',
              'Total',
              Icons.history_rounded,
              PrestaHubTheme.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 32,
        color: PrestaHubTheme.surface2Light,
      );

  Widget _statCell(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: PrestaHubTheme.borderStrong,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: SizedBox(
        height: 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, i) {
            final f = _filters[i];
            final sel = _activeFilter == f;
            return GestureDetector(
              onTap: () => setState(() => _activeFilter = f),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: sel
                      ? PrestaHubTheme.primary
                      : PrestaHubTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: sel
                        ? PrestaHubTheme.primary
                        : PrestaHubTheme.border,
                  ),
                ),
                child: Text(
                  f,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: sel
                        ? PrestaHubTheme.primaryContent
                        : PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<MissionSummary> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, i) => _MissionCard(
        mission: items[i],
        onTap: () => context.push(
          AppConstants.routeClientMissionDetail
              .replaceFirst(':id', items[i].id),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 34,
                color: PrestaHubTheme.borderStrong,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune mission',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Aucune mission ne correspond à ce filtre.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: PrestaHubTheme.textMutedLight,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final MissionSummary mission;
  final VoidCallback onTap;

  const _MissionCard({required this.mission, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: PrestaHubTheme.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    mission.categoryIcon,
                    color: PrestaHubTheme.primary,
                    size: 20,
                  ),
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
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${mission.category} · ${mission.completedOn}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: PrestaHubTheme.borderStrong,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: mission.status.softColor,
                    borderRadius: BorderRadius.circular(20),
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
            Container(height: 1, color: PrestaHubTheme.surface2Light),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: primarySoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      mission.providerInitials,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mission.providerName,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                ),
                if (mission.rating != null) ...[
                  const Icon(Icons.star_rounded,
                      size: 13, color: PrestaHubTheme.warning),
                  const SizedBox(width: 3),
                  Text(
                    mission.rating!.toStringAsFixed(1),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  mission.price,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: PrestaHubTheme.primary,
                  ),
                ),
              ],
            ),
            if (mission.status == RequestStatus.completed &&
                !mission.hasReview) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push(
                  AppConstants.routeClientMissionReview
                      .replaceFirst(':id', mission.id),
                  extra: ReviewMissionContext(
                    missionId: mission.id,
                    missionTitle: mission.title,
                    providerName: mission.providerName,
                    providerInitials: mission.providerInitials,
                    completedOn: mission.completedOn,
                  ),
                ),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: PrestaHubTheme.warning.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_border_rounded,
                          size: 14, color: PrestaHubTheme.warning),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Évaluation en attente',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: PrestaHubTheme.warning,
                          ),
                        ),
                      ),
                      Text(
                        'Noter',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: PrestaHubTheme.warning,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded,
                          size: 14, color: PrestaHubTheme.warning),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
