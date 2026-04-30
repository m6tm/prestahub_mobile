import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../messages/models/conversation_models.dart';
import '../models/service_request_models.dart';

class RequestDetailScreen extends StatelessWidget {
  final String requestId;
  const RequestDetailScreen({super.key, required this.requestId});

  static const _status = RequestStatus.accepted;

  static const _proposals = [
    _ProposalData('Marie Leroi', 'ML', 4.8, '30 €/h',
        'Je peux intervenir demain matin vers 9h.'),
    _ProposalData('Jean Dupont', 'JD', 4.9, '35 €/h',
        'Disponible aujourd\'hui après 16h, devis gratuit.'),
    _ProposalData('Karim Ould', 'KO', 4.5, '32 €/h',
        'Intervention possible sous 24h.'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: PrestaHubTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildStatusCard(),
                    const SizedBox(height: 14),
                    _buildTimeline(),
                    const SizedBox(height: 14),
                    _buildSection(
                      title: 'Description',
                      icon: Icons.description_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remplacement tableau électrique',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: PrestaHubTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Le tableau électrique est vétuste et disjoncte régulièrement. Remplacement complet avec mise aux normes.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: PrestaHubTheme.textMutedLight,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      title: 'Lieu',
                      icon: Icons.location_on_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '25 av. des Champs-Élysées',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: PrestaHubTheme.textLight,
                            ),
                          ),
                          Text(
                            '75008 Paris · Bâtiment A, 3e étage',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: PrestaHubTheme.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      title: 'Créneau',
                      icon: Icons.event_outlined,
                      child: Row(
                        children: [
                          Expanded(
                            child: _timeBlock('Date', 'Mer. 30 avr. 2026'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _timeBlock('Horaire', 'Matin (8h-12h)'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildProposalsHeader(),
                    const SizedBox(height: 10),
                    ..._proposals.map((p) => _ProposalCard(proposal: p)),
                  ],
                ),
              ),
              _buildBottomBar(context),
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
                  'Détail de la demande',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  requestId,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showActionsSheet(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: PrestaHubTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PrestaHubTheme.border),
              ),
              child: const Icon(Icons.more_horiz_rounded,
                  size: 18, color: PrestaHubTheme.textMutedLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _status.softColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _status.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _status.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _status.icon,
              color: PrestaHubTheme.primaryContent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _status.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _status.color,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Marie Leroi a accepté votre demande',
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

  Widget _buildTimeline() {
    const events = [
      _TimelineEvent('Demande créée', 'Il y a 2 jours', true, true),
      _TimelineEvent('3 propositions reçues', 'Il y a 1 jour', true, true),
      _TimelineEvent('Prestataire accepté', 'Aujourd\'hui', true, true),
      _TimelineEvent('Intervention', 'Mer. 30 avr. matin', false, false),
      _TimelineEvent('Mission terminée', '—', false, false),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline_rounded,
                  size: 15, color: PrestaHubTheme.primary),
              const SizedBox(width: 7),
              Text(
                'Suivi',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(events.length, (i) {
            final event = events[i];
            final isLast = i == events.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: event.completed
                              ? PrestaHubTheme.primary
                              : PrestaHubTheme.backgroundLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: event.completed
                                ? PrestaHubTheme.primary
                                : PrestaHubTheme.borderStrong,
                            width: 2,
                          ),
                        ),
                        child: event.completed
                            ? const Icon(Icons.check_rounded,
                                size: 8,
                                color: PrestaHubTheme.primaryContent)
                            : null,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: event.completed
                                ? PrestaHubTheme.primary
                                : PrestaHubTheme.border,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: event.completed
                                  ? PrestaHubTheme.textLight
                                  : PrestaHubTheme.borderStrong,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event.date,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: PrestaHubTheme.borderStrong,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrestaHubTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: PrestaHubTheme.primary),
              const SizedBox(width: 7),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PrestaHubTheme.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _timeBlock(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: PrestaHubTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: PrestaHubTheme.borderStrong,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: PrestaHubTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalsHeader() {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    return Row(
      children: [
        Text(
          'Propositions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: PrestaHubTheme.textLight,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_proposals.length}',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: PrestaHubTheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  ConversationSummary _buildPeerConversation() {
    return ConversationSummary(
      id: 'CONV-$requestId',
      requestId: requestId,
      requestTitle: 'Remplacement tableau électrique',
      requestStatus: _status,
      peerName: 'Marie Leroi',
      peerInitials: 'ML',
      peerColor: PrestaHubTheme.primary,
      lastMessage: '',
      lastMessageTime: '',
      isPeerOnline: true,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPad),
      decoration: const BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        border: Border(top: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final peer = _buildPeerConversation();
                context.push(
                  AppConstants.routeClientCall
                      .replaceFirst(':id', peer.id),
                  extra: peer,
                );
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.backgroundLight,
                  border: Border.all(color: PrestaHubTheme.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 16, color: PrestaHubTheme.textMutedLight),
                    const SizedBox(width: 6),
                    Text(
                      'Appeler',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final peer = _buildPeerConversation();
                context.push(
                  AppConstants.routeClientConversation
                      .replaceFirst(':id', peer.id),
                  extra: peer,
                );
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PrestaHubTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded,
                        size: 16, color: PrestaHubTheme.primaryContent),
                    const SizedBox(width: 6),
                    Text(
                      'Message',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.primaryContent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: PrestaHubTheme.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: PrestaHubTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _actionTile(
                  Icons.edit_outlined,
                  'Modifier la demande',
                  PrestaHubTheme.textMutedLight,
                  () => Navigator.pop(ctx),
                ),
                _actionTile(
                  Icons.share_outlined,
                  'Partager',
                  PrestaHubTheme.textMutedLight,
                  () => Navigator.pop(ctx),
                ),
                _actionTile(
                  Icons.cancel_outlined,
                  'Annuler la demande',
                  PrestaHubTheme.danger,
                  () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionTile(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineEvent {
  final String title;
  final String date;
  final bool completed;
  final bool active;
  const _TimelineEvent(this.title, this.date, this.completed, this.active);
}

class _ProposalData {
  final String name, initials, price, message;
  final double rating;
  const _ProposalData(
      this.name, this.initials, this.rating, this.price, this.message);
}

class _ProposalCard extends StatelessWidget {
  final _ProposalData proposal;
  const _ProposalCard({required this.proposal});

  @override
  Widget build(BuildContext context) {
    final primarySoft = PrestaHubTheme.primary.withValues(alpha: 0.10);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
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
                  color: primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    proposal.initials,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PrestaHubTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proposal.name,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: PrestaHubTheme.warning),
                        const SizedBox(width: 3),
                        Text(
                          proposal.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: PrestaHubTheme.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  proposal.price,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            proposal.message,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: PrestaHubTheme.textMutedLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: PrestaHubTheme.backgroundLight,
                      border: Border.all(color: PrestaHubTheme.border),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      'Voir profil',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: PrestaHubTheme.primary,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      'Accepter',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: PrestaHubTheme.primaryContent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
