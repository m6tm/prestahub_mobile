import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../requests/models/service_request_models.dart';
import '../models/conversation_models.dart';
import 'image_preview_screen.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;
  final ConversationSummary? initial;

  const ConversationScreen({
    super.key,
    required this.conversationId,
    this.initial,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _hasText = false;

  late final ConversationSummary _conversation = widget.initial ??
      const ConversationSummary(
        id: 'CONV-1042',
        requestId: 'REQ-1042',
        requestTitle: 'Fuite sous évier cuisine',
        requestStatus: RequestStatus.pending,
        peerName: 'Julien Moreau',
        peerInitials: 'JM',
        peerColor: PrestaHubTheme.primary,
        lastMessage: '',
        lastMessageTime: '',
        isPeerOnline: true,
      );

  final List<ChatMessage> _messages = [
    const ChatMessage(
      id: 'M1',
      sender: MessageSender.peer,
      kind: MessageKind.system,
      content: 'Demande créée · 14:20',
      time: '14:20',
    ),
    const ChatMessage(
      id: 'M2',
      sender: MessageSender.me,
      kind: MessageKind.text,
      content:
          'Bonjour, j\'ai une fuite sous l\'évier de la cuisine. Êtes-vous disponible ?',
      time: '14:25',
    ),
    const ChatMessage(
      id: 'M3',
      sender: MessageSender.peer,
      kind: MessageKind.text,
      content:
          'Bonjour ! Oui, je peux intervenir rapidement. Pourriez-vous m\'envoyer une photo de la fuite ?',
      time: '14:28',
    ),
    const ChatMessage(
      id: 'M4',
      sender: MessageSender.me,
      kind: MessageKind.image,
      content:
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600',
      time: '14:30',
    ),
    const ChatMessage(
      id: 'M5',
      sender: MessageSender.peer,
      kind: MessageKind.file,
      content: 'Devis plomberie signé.',
      attachmentName: 'devis-plomberie.pdf',
      attachmentSize: '142 Ko',
      time: '14:31',
    ),
    const ChatMessage(
      id: 'M6',
      sender: MessageSender.peer,
      kind: MessageKind.text,
      content: 'Je peux passer demain matin vers 9h, ça vous va ?',
      time: '14:32',
      isRead: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _inputCtrl.addListener(() {
      final has = _inputCtrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.animateTo(
      _scrollCtrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        id: 'M${_messages.length + 1}',
        sender: MessageSender.me,
        kind: MessageKind.text,
        content: text,
        time: _formatNow(),
      ));
      _inputCtrl.clear();
      _hasText = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String _formatNow() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

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
              _buildHeader(),
              _buildRequestBanner(),
              Expanded(child: _buildMessages()),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        border: Border(
          bottom: BorderSide(color: PrestaHubTheme.border),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: PrestaHubTheme.textLight),
            ),
          ),
          const SizedBox(width: 4),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _conversation.peerColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _conversation.peerInitials,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _conversation.peerColor,
                  ),
                ),
              ),
              if (_conversation.isPeerOnline)
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 10,
                    height: 10,
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _conversation.peerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: PrestaHubTheme.textLight,
                  ),
                ),
                Text(
                  _conversation.isPeerOnline ? 'En ligne' : 'Hors ligne',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: _conversation.isPeerOnline
                        ? PrestaHubTheme.success
                        : PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          _circleAction(
            icon: Icons.call_rounded,
            onTap: () => context.push(
              AppConstants.routeClientCall
                  .replaceFirst(':id', _conversation.id),
              extra: _conversation,
            ),
          ),
          const SizedBox(width: 6),
          _circleAction(
            icon: Icons.more_vert_rounded,
            onTap: () => _showContextMenu(),
          ),
        ],
      ),
    );
  }

  Widget _circleAction({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: PrestaHubTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: PrestaHubTheme.textLight),
      ),
    );
  }

  Widget _buildRequestBanner() {
    final status = _conversation.requestStatus;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(
        AppConstants.routeClientRequestDetail
            .replaceFirst(':id', _conversation.requestId),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: PrestaHubTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrestaHubTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: PrestaHubTheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.description_rounded,
                  size: 16, color: PrestaHubTheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _conversation.requestTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PrestaHubTheme.textLight,
                    ),
                  ),
                  Text(
                    _conversation.requestId,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: PrestaHubTheme.borderStrong,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            ),
          ],
        ),
      ),
    );
  }

  List<PreviewImageItem> _buildImageGallery() {
    return _messages
        .where((m) => m.kind == MessageKind.image)
        .map((m) => PreviewImageItem(
              heroTag: 'msg-image-${m.id}',
              imageUrl: m.content,
              senderLabel: m.sender == MessageSender.me
                  ? 'Vous'
                  : _conversation.peerName,
              time: m.time,
            ))
        .toList();
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      physics: const BouncingScrollPhysics(),
      itemCount: _messages.length,
      itemBuilder: (context, i) {
        final m = _messages[i];
        if (m.kind == MessageKind.system) {
          return _SystemBubble(text: m.content);
        }
        return _MessageBubble(
          message: m,
          peerName: _conversation.peerName,
          onOpenImage: () {
            final gallery = _buildImageGallery();
            final index = gallery.indexWhere((g) => g.heroTag == 'msg-image-${m.id}');
            if (index < 0) return;
            Navigator.of(context).push(
              PageRouteBuilder<void>(
                opaque: false,
                barrierColor: Colors.black,
                transitionDuration: const Duration(milliseconds: 250),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (_, _, _) => ImagePreviewScreen(
                  items: gallery,
                  initialIndex: index,
                ),
                transitionsBuilder: (_, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).viewInsets.bottom > 0 ? 8 : 12,
      ),
      decoration: const BoxDecoration(
        color: PrestaHubTheme.backgroundLight,
        border: Border(top: BorderSide(color: PrestaHubTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _circleAction(
              icon: Icons.attach_file_rounded,
              onTap: _showAttachmentSheet,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: PrestaHubTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: PrestaHubTheme.border),
                ),
                child: TextField(
                  controller: _inputCtrl,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  cursorColor: PrestaHubTheme.primary,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    height: 1.35,
                    color: PrestaHubTheme.textLight,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Écrire un message…',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.5,
                      height: 1.35,
                      color: PrestaHubTheme.textMutedLight,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hasText ? _sendMessage : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _hasText
                      ? PrestaHubTheme.primary
                      : PrestaHubTheme.surface2Light,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.send_rounded,
                  size: 18,
                  color: _hasText
                      ? PrestaHubTheme.primaryContent
                      : PrestaHubTheme.borderStrong,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: PrestaHubTheme.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: PrestaHubTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _attachmentOption(
              icon: Icons.photo_library_rounded,
              label: 'Photos',
              onTap: () => Navigator.pop(ctx),
            ),
            _attachmentOption(
              icon: Icons.camera_alt_rounded,
              label: 'Appareil photo',
              onTap: () => Navigator.pop(ctx),
            ),
            _attachmentOption(
              icon: Icons.insert_drive_file_rounded,
              label: 'Document',
              onTap: () => Navigator.pop(ctx),
            ),
            _attachmentOption(
              icon: Icons.location_on_rounded,
              label: 'Localisation',
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: PrestaHubTheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: PrestaHubTheme.primary),
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: PrestaHubTheme.textLight,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: PrestaHubTheme.textMutedLight),
    );
  }

  void _showContextMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: PrestaHubTheme.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: PrestaHubTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _attachmentOption(
              icon: Icons.description_rounded,
              label: 'Voir la demande',
              onTap: () {
                Navigator.pop(ctx);
                context.push(
                  AppConstants.routeClientRequestDetail
                      .replaceFirst(':id', _conversation.requestId),
                );
              },
            ),
            _attachmentOption(
              icon: Icons.volume_off_rounded,
              label: 'Couper les notifications',
              onTap: () => Navigator.pop(ctx),
            ),
            _attachmentOption(
              icon: Icons.flag_rounded,
              label: 'Signaler',
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemBubble extends StatelessWidget {
  final String text;
  const _SystemBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: PrestaHubTheme.surfaceLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: PrestaHubTheme.textMutedLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String peerName;
  final VoidCallback? onOpenImage;

  const _MessageBubble({
    required this.message,
    required this.peerName,
    this.onOpenImage,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == MessageSender.me;
    final bg = isMe ? PrestaHubTheme.primary : PrestaHubTheme.surfaceLight;
    final fg = isMe ? PrestaHubTheme.primaryContent : PrestaHubTheme.textLight;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMe ? 16 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 16),
    );

    Widget content;
    switch (message.kind) {
      case MessageKind.image:
        final heroTag = 'msg-image-${message.id}';
        content = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onOpenImage,
          child: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                message.content,
                width: 220,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 220,
                  height: 160,
                  color: PrestaHubTheme.surface2Light,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_rounded,
                      color: PrestaHubTheme.borderStrong),
                ),
              ),
            ),
          ),
        );
        break;
      case MessageKind.file:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (isMe ? Colors.white : PrestaHubTheme.primary)
                    .withValues(alpha: isMe ? 0.20 : 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.description_rounded,
                size: 18,
                color: isMe ? Colors.white : PrestaHubTheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.attachmentName ?? 'Fichier',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.attachmentSize ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.75)
                        : PrestaHubTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ],
        );
        break;
      case MessageKind.text:
      case MessageKind.system:
        content = Text(
          message.content,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            height: 1.4,
            color: fg,
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: message.kind == MessageKind.image
                      ? const EdgeInsets.all(4)
                      : const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: radius,
                    border: isMe
                        ? null
                        : Border.all(color: PrestaHubTheme.border),
                  ),
                  child: content,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.time,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: PrestaHubTheme.textMutedLight,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.isRead
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 13,
                        color: message.isRead
                            ? PrestaHubTheme.primary
                            : PrestaHubTheme.textMutedLight,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
