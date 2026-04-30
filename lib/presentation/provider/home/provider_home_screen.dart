import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:prestahub/application/auth/auth_notifier.dart';
import 'package:prestahub/core/constants/app_constants.dart';
import 'package:prestahub/core/theme/app_theme.dart';
import 'package:prestahub/presentation/provider/missions/models/provider_mission_models.dart';
import 'package:prestahub/presentation/requests/models/service_request_models.dart';

/// Tableau de bord prestataire — vue synthétique des demandes reçues,
/// des missions en cours et des principaux indicateurs d'activité.
class ProviderHomeScreen extends ConsumerStatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  ConsumerState<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends ConsumerState<ProviderHomeScreen> {
  int _navIndex = 0;
  bool _available = true;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final pendingRequests = ProviderMissionsMock.requests
        .where((r) => r.status == RequestStatus.pending)
        .toList();
    final activeMissions = ProviderMissionsMock.missionsInProgress;
    final completedMissions = ProviderMissionsMock.missionsCompleted
        .where((m) => m.status == RequestStatus.completed)
        .toList();

    final avgRating = _averageRating(completedMissions);
    final monthlyRevenue = _monthlyRevenue(completedMissions);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.surfaceLight,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async =>
                await Future.delayed(const Duration(milliseconds: 400)),
            color: PrestaHubTheme.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 120),
              physics: const BouncingScrollPhysics(),
              children: [
                _Header(
                  user: user,
                  available: _available,
                  onToggleAvailability: (v) =>
                      setState(() => _available = v),
                ),
                const SizedBox(height: 20),
                _StatsGrid(
                  pendingCount: pendingRequests.length,
                  activeCount: activeMissions.length,
                  completedCount: completedMissions.length,
                  avgRating: avgRating,
                  monthlyRevenue: monthlyRevenue,
                ),
                const SizedBox(height: 22),
                _SectionHeader(
                  title: 'Demandes à traiter',
                  badge: pendingRequests.length,
                  onSeeAll: () =>
                      context.push(AppConstants.routeProviderRequests),
                ),
                const SizedBox(height: 10),
                if (pendingRequests.isEmpty)
                  const _SectionEmpty(
                    icon: Icons.inbox_rounded,
                    message:
                        'Aucune nouvelle demande pour le moment. Elles apparaîtront ici.',
                  )
                else
                  ...pendingRequests.take(2).map(
                        (r) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: _RequestRow(
                            request: r,
                            onTap: () => context.push(
                              AppConstants.routeProviderRequestDetail
                                  .replaceFirst(':id', r.id),
                              extra: r,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                _SectionHeader(
                  title: 'Missions à venir',
                  badge: activeMissions.length,
                  onSeeAll: () =>
                      context.push(AppConstants.routeProviderMissions),
                ),
                const SizedBox(height: 10),
                if (activeMissions.isEmpty)
                  const _SectionEmpty(
                    icon: Icons.event_available_rounded,
                    message:
                        'Aucune mission planifiée. Acceptez une demande pour commencer.',
                  )
                else
                  ...activeMissions.take(2).map(
                        (m) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: _MissionRow(
                            mission: m,
                            onTap: () => context.push(
                              AppConstants.routeProviderMissionDetail
                                  .replaceFirst(':id', m.id),
                              extra: m,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                _SectionHeader(
                  title: 'Dernières missions',
                  onSeeAll: () =>
                      context.push(AppConstants.routeProviderMissionHistory),
                ),
                const SizedBox(height: 10),
                if (completedMissions.isEmpty)
                  const _SectionEmpty(
                    icon: Icons.history_rounded,
                    message: 'Votre historique de missions s\'affichera ici.',
                  )
                else
                  ...completedMissions.take(2).map(
                        (m) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: _HistoryRow(
                            mission: m,
                            onTap: () => context.push(
                              AppConstants.routeProviderPastMissionDetail
                                  .replaceFirst(':id', m.id),
                              extra: m,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _ProviderNavBar(
          currentIndex: _navIndex,
          onTap: (i) {
            switch (i) {
              case 1:
                context.push(AppConstants.routeProviderRequests);
                return;
              case 2:
                context.push(AppConstants.routeProviderMissions);
                return;
              case 3:
                // Messagerie prestataire — non encore implémentée.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La messagerie prestataire sera disponible prochainement.',
                    ),
                  ),
                );
                return;
              case 4:
                context.push(AppConstants.routeSettings);
                return;
            }
            setState(() => _navIndex = i);
          },
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

  int _monthlyRevenue(List<ProviderMissionSummary> missions) {
    var total = 0;
    for (final m in missions) {
      final digits = RegExp(r'\d+').firstMatch(m.price)?.group(0);
      if (digits != null) total += int.parse(digits);
    }
    return total;
  }
}

// ─── Header ─────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final dynamic user;
  final bool available;
  final ValueChanged<bool> onToggleAvailability;

  const _Header({
    required this.user,
    required this.available,
    required this.onToggleAvailability,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(user?.displayName ?? 'JD');
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: PrestaHubTheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
                Text(
                  user?.displayName ?? 'Prestataire',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          _AvailabilityToggle(
            value: available,
            onChanged: onToggleAvailability,
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }
}

class _AvailabilityToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AvailabilityToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: value
              ? PrestaHubTheme.success.withValues(alpha: 0.12)
              : PrestaHubTheme.surface2Light,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value
                ? PrestaHubTheme.success.withValues(alpha: 0.4)
                : PrestaHubTheme.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: value
                    ? PrestaHubTheme.success
                    : PrestaHubTheme.textMutedLight,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              value ? 'Disponible' : 'Indisponible',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: value
                    ? PrestaHubTheme.success
                    : PrestaHubTheme.textMutedLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grille d'indicateurs ───────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final int pendingCount;
  final int activeCount;
  final int completedCount;
  final double? avgRating;
  final int monthlyRevenue;

  const _StatsGrid({
    required this.pendingCount,
    required this.activeCount,
    required this.completedCount,
    required this.avgRating,
    required this.monthlyRevenue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.inbox_rounded,
                  label: 'Nouvelles',
                  value: pendingCount.toString(),
                  color: PrestaHubTheme.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.task_alt_rounded,
                  label: 'En cours',
                  value: activeCount.toString(),
                  color: PrestaHubTheme.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.star_rounded,
                  label: 'Note moyenne',
                  value: avgRating != null
                      ? avgRating!.toStringAsFixed(1)
                      : '—',
                  suffix: avgRating != null ? '/ 5' : null,
                  color: PrestaHubTheme.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.euro_rounded,
                  label: 'Revenus 30j',
                  value: monthlyRevenue > 0
                      ? monthlyRevenue.toString()
                      : '—',
                  suffix: monthlyRevenue > 0 ? '€' : null,
                  color: PrestaHubTheme.success,
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
  final String? suffix;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.suffix,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: PrestaHubTheme.textLight,
                  letterSpacing: -0.4,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 3),
                Text(
                  suffix!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Sections ───────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final int? badge;
  final VoidCallback onSeeAll;

  const _SectionHeader({
    required this.title,
    required this.onSeeAll,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.textLight,
              letterSpacing: -0.2,
            ),
          ),
          if (badge != null && badge! > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: PrestaHubTheme.warning,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge.toString(),
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          const Spacer(),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: PrestaHubTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Voir tout',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  final IconData icon;
  final String message;

  const _SectionEmpty({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surface2Light,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon,
                  size: 18, color: PrestaHubTheme.textMutedLight),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: PrestaHubTheme.textMutedLight,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cartes résumé ──────────────────────────────────────────────────────────
class _RequestRow extends StatelessWidget {
  final ProviderRequestSummary request;
  final VoidCallback onTap;
  const _RequestRow({required this.request, required this.onTap});

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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Icon(request.categoryIcon,
                    color: PrestaHubTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${request.clientName} · ${request.receivedAt}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                request.budgetLabel,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissionRow extends StatelessWidget {
  final ProviderMissionSummary mission;
  final VoidCallback onTap;
  const _MissionRow({required this.mission, required this.onTap});

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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: mission.status.softColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Icon(mission.status.icon,
                    color: mission.status.color, size: 20),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${mission.clientName} · ${mission.scheduledAt}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final ProviderMissionSummary mission;
  final VoidCallback onTap;
  const _HistoryRow({required this.mission, required this.onTap});

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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check_rounded,
                    color: PrestaHubTheme.success, size: 20),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${mission.clientName} · ${mission.completedOn ?? mission.scheduledAt}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (mission.clientRating != null) ...[
                const Icon(Icons.star_rounded,
                    size: 15, color: PrestaHubTheme.warning),
                const SizedBox(width: 3),
                Text(
                  mission.clientRating!.toStringAsFixed(1),
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Barre de navigation prestataire ────────────────────────────────────────
class _ProviderNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ProviderNavBar({required this.currentIndex, required this.onTap});

  // Composition : Accueil, Demandes, Missions, Messages (désactivé), Paramètres.
  // Les entrées désactivées affichent un badge "Bientôt" et renvoient une
  // SnackBar informative plutôt que de router vers un écran non réalisé.
  static const _items = <_NavItem>[
    _NavItem(
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Accueil',
    ),
    _NavItem(
      activeIcon: Icons.assignment_rounded,
      inactiveIcon: Icons.assignment_outlined,
      label: 'Demandes',
    ),
    _NavItem(
      activeIcon: Icons.task_alt_rounded,
      inactiveIcon: Icons.task_alt_outlined,
      label: 'Missions',
    ),
    _NavItem(
      activeIcon: Icons.chat_bubble_rounded,
      inactiveIcon: Icons.chat_bubble_outline_rounded,
      label: 'Messages',
      disabled: true,
    ),
    _NavItem(
      activeIcon: Icons.settings_rounded,
      inactiveIcon: Icons.settings_outlined,
      label: 'Paramètres',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 64 + bottomPad,
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          final isActive = currentIndex == i;
          final mutedColor = item.disabled
              ? PrestaHubTheme.borderStrong
              : PrestaHubTheme.textMutedLight;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 66,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.inactiveIcon,
                        size: 22,
                        color: isActive
                            ? PrestaHubTheme.primary
                            : mutedColor,
                      ),
                      if (item.disabled)
                        Positioned(
                          right: -10,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: PrestaHubTheme.warning,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Bientôt',
                              style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? PrestaHubTheme.primary
                          : mutedColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool disabled;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    this.disabled = false,
  });
}
