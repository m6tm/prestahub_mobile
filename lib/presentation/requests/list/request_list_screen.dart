import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../models/service_request_models.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  static final _mockRequests = <ServiceRequestSummary>[
    ServiceRequestSummary(
      id: 'REQ-1042',
      title: 'Fuite sous évier cuisine',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.pending,
      date: 'Aujourd\'hui, 14:30',
      address: '12 rue de la République, Paris',
      proposalsCount: 3,
    ),
    ServiceRequestSummary(
      id: 'REQ-1038',
      title: 'Remplacement tableau électrique',
      category: 'Électricité',
      categoryIcon: Icons.bolt_rounded,
      status: RequestStatus.accepted,
      date: 'Hier, 09:15',
      address: '25 av. des Champs-Élysées, Paris',
      providerName: 'Marie Leroi',
      providerInitials: 'ML',
      proposalsCount: 5,
    ),
    ServiceRequestSummary(
      id: 'REQ-1034',
      title: 'Ménage hebdomadaire 2h',
      category: 'Ménage',
      categoryIcon: Icons.cleaning_services_rounded,
      status: RequestStatus.inProgress,
      date: 'Lun. 27 avr., 10:00',
      address: '12 rue de la République, Paris',
      providerName: 'Sophie Blanc',
      providerInitials: 'SB',
    ),
    ServiceRequestSummary(
      id: 'REQ-1021',
      title: 'Peinture salon',
      category: 'Peinture',
      categoryIcon: Icons.format_paint_rounded,
      status: RequestStatus.pending,
      date: '20 avr., 16:45',
      address: '12 rue de la République, Paris',
      proposalsCount: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<ServiceRequestSummary> get _filtered {
    switch (_tabCtrl.index) {
      case 0:
        return _mockRequests
            .where((r) => r.status == RequestStatus.pending)
            .toList();
      case 1:
        return _mockRequests
            .where((r) =>
                r.status == RequestStatus.accepted ||
                r.status == RequestStatus.inProgress)
            .toList();
      case 2:
        return _mockRequests;
      default:
        return _mockRequests;
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              context.push(AppConstants.routeClientRequestCreate),
          backgroundColor: PrestaHubTheme.primary,
          foregroundColor: PrestaHubTheme.primaryContent,
          elevation: 2,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: Text(
            'Nouvelle demande',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildTabs(),
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
                  'Mes demandes',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${_mockRequests.length} demande${_mockRequests.length > 1 ? 's' : ''} au total',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.push(AppConstants.routeClientMissionHistory),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: const Icon(Icons.history_rounded,
                  size: 18, color: PrestaHubTheme.textMutedLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: PrestaHubTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        child: Row(
          children: List.generate(3, (i) {
            const labels = ['En attente', 'En cours', 'Toutes'];
            final isSelected = _tabCtrl.index == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => _tabCtrl.animateTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? PrestaHubTheme.backgroundLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: PrestaHubTheme.textLight
                                  .withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labels[i],
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? PrestaHubTheme.textLight
                          : PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildList(List<ServiceRequestSummary> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, i) => _RequestCard(
        request: items[i],
        onTap: () => context.push(
          AppConstants.routeClientRequestDetail
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
                Icons.inbox_outlined,
                size: 34,
                color: PrestaHubTheme.borderStrong,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune demande',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Lancez une nouvelle demande pour trouver un prestataire adapté.',
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

class _RequestCard extends StatelessWidget {
  final ServiceRequestSummary request;
  final VoidCallback onTap;

  const _RequestCard({required this.request, required this.onTap});

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
          boxShadow: [
            BoxShadow(
              color: PrestaHubTheme.textLight.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                    request.categoryIcon,
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
                        request.title,
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
                        '${request.category} · ${request.id}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: PrestaHubTheme.borderStrong,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusPill(status: request.status),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: PrestaHubTheme.surface2Light),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.event_rounded,
                  size: 13,
                  color: PrestaHubTheme.borderStrong,
                ),
                const SizedBox(width: 5),
                Text(
                  request.date,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.location_on_rounded,
                  size: 13,
                  color: PrestaHubTheme.borderStrong,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    request.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ),
              ],
            ),
            if (request.providerName != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PrestaHubTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: primarySoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          request.providerInitials ?? '',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: PrestaHubTheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        request.providerName!,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: PrestaHubTheme.textLight,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 14,
                      color: PrestaHubTheme.primary,
                    ),
                  ],
                ),
              ),
            ] else if (request.proposalsCount > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primarySoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.mark_email_unread_rounded,
                          size: 12,
                          color: PrestaHubTheme.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${request.proposalsCount} proposition${request.proposalsCount > 1 ? 's' : ''} reçue${request.proposalsCount > 1 ? 's' : ''}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: PrestaHubTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final RequestStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.softColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 11, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}
