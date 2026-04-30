import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../requests/models/service_request_models.dart';
import '../models/conversation_models.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static final _conversations = <ConversationSummary>[
    ConversationSummary(
      id: 'CONV-1042',
      requestId: 'REQ-1042',
      requestTitle: 'Fuite sous évier cuisine',
      requestStatus: RequestStatus.pending,
      peerName: 'Julien Moreau',
      peerInitials: 'JM',
      peerColor: PrestaHubTheme.primary,
      lastMessage: 'Je peux passer demain matin vers 9h, ça vous va ?',
      lastMessageTime: '14:32',
      unreadCount: 2,
      isPeerOnline: true,
    ),
    ConversationSummary(
      id: 'CONV-1038',
      requestId: 'REQ-1038',
      requestTitle: 'Remplacement tableau électrique',
      requestStatus: RequestStatus.accepted,
      peerName: 'Marie Leroi',
      peerInitials: 'ML',
      peerColor: PrestaHubTheme.info,
      lastMessage: 'Parfait, à demain 10h. Je confirme le devis.',
      lastMessageTime: 'Hier',
      isPeerTyping: true,
      isPeerOnline: true,
    ),
    ConversationSummary(
      id: 'CONV-1034',
      requestId: 'REQ-1034',
      requestTitle: 'Ménage hebdomadaire 2h',
      requestStatus: RequestStatus.inProgress,
      peerName: 'Sophie Blanc',
      peerInitials: 'SB',
      peerColor: PrestaHubTheme.success,
      lastMessage: 'J\'ai terminé, tout est nickel !',
      lastMessageTime: 'Lun.',
      unreadCount: 0,
    ),
    ConversationSummary(
      id: 'CONV-1021',
      requestId: 'REQ-1021',
      requestTitle: 'Peinture salon',
      requestStatus: RequestStatus.pending,
      peerName: 'Karim Bensaid',
      peerInitials: 'KB',
      peerColor: PrestaHubTheme.warning,
      lastMessage: 'Bonjour, je vous envoie mon devis détaillé.',
      lastMessageTime: '20 avr.',
      unreadCount: 1,
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ConversationSummary> get _filtered {
    if (_query.trim().isEmpty) return _conversations;
    final q = _query.toLowerCase();
    return _conversations
        .where((c) =>
            c.peerName.toLowerCase().contains(q) ||
            c.requestTitle.toLowerCase().contains(q) ||
            c.lastMessage.toLowerCase().contains(q))
        .toList();
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
              _buildHeader(),
              _buildSearchField(),
              Expanded(
                child: items.isEmpty ? _buildEmpty() : _buildList(items),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final total = _conversations.fold<int>(0, (s, c) => s + c.unreadCount);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
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
                  'Messages',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  total > 0
                      ? '$total message${total > 1 ? 's' : ''} non lu${total > 1 ? 's' : ''}'
                      : 'Tout est à jour',
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

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: PrestaHubTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded,
                size: 18, color: PrestaHubTheme.textMutedLight),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                cursorColor: PrestaHubTheme.primary,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: PrestaHubTheme.textLight,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Rechercher une conversation',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: PrestaHubTheme.textMutedLight,
                  ),
                ),
              ),
            ),
            if (_query.isNotEmpty)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _searchCtrl.clear();
                  setState(() => _query = '');
                },
                child: const Icon(Icons.close_rounded,
                    size: 16, color: PrestaHubTheme.textMutedLight),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<ConversationSummary> items) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: PrestaHubTheme.surface2Light),
      itemBuilder: (context, i) => _ConversationTile(
        conversation: items[i],
        onTap: () => context.push(
          AppConstants.routeClientConversation
              .replaceFirst(':id', items[i].id),
          extra: items[i],
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
                Icons.chat_bubble_outline_rounded,
                size: 32,
                color: PrestaHubTheme.borderStrong,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _query.isEmpty
                  ? 'Aucune conversation'
                  : 'Aucun résultat',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PrestaHubTheme.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _query.isEmpty
                  ? 'Vos échanges avec les prestataires apparaîtront ici.'
                  : 'Essayez avec un autre mot-clé.',
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

class _ConversationTile extends StatelessWidget {
  final ConversationSummary conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = conversation.unreadCount > 0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: conversation.peerColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    conversation.peerInitials,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: conversation.peerColor,
                    ),
                  ),
                ),
                if (conversation.isPeerOnline)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: PrestaHubTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: PrestaHubTheme.backgroundLight,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.peerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight:
                                hasUnread ? FontWeight.w700 : FontWeight.w600,
                            color: PrestaHubTheme.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conversation.lastMessageTime,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight:
                              hasUnread ? FontWeight.w600 : FontWeight.w500,
                          color: hasUnread
                              ? PrestaHubTheme.primary
                              : PrestaHubTheme.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.requestTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: PrestaHubTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.isPeerTyping
                              ? 'en train d\'écrire…'
                              : conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontStyle: conversation.isPeerTyping
                                ? FontStyle.italic
                                : FontStyle.normal,
                            fontWeight:
                                hasUnread ? FontWeight.w600 : FontWeight.w400,
                            color: hasUnread
                                ? PrestaHubTheme.textLight
                                : PrestaHubTheme.textMutedLight,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: PrestaHubTheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: PrestaHubTheme.primaryContent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
