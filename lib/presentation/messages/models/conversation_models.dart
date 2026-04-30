import 'package:flutter/material.dart';
import 'package:prestahub/presentation/requests/models/service_request_models.dart';

class ConversationSummary {
  final String id;
  final String requestId;
  final String requestTitle;
  final RequestStatus requestStatus;
  final String peerName;
  final String peerInitials;
  final Color peerColor;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isPeerTyping;
  final bool isPeerOnline;

  const ConversationSummary({
    required this.id,
    required this.requestId,
    required this.requestTitle,
    required this.requestStatus,
    required this.peerName,
    required this.peerInitials,
    required this.peerColor,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isPeerTyping = false,
    this.isPeerOnline = false,
  });
}

enum MessageKind { text, image, file, system }

enum MessageSender { me, peer }

class ChatMessage {
  final String id;
  final MessageSender sender;
  final MessageKind kind;
  final String content;
  final String? attachmentName;
  final String? attachmentSize;
  final String time;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.kind,
    required this.content,
    required this.time,
    this.isRead = true,
    this.attachmentName,
    this.attachmentSize,
  });
}
