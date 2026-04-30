import 'package:flutter/material.dart';
import 'package:prestahub/core/theme/app_theme.dart';

enum RequestStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
  rejected,
}

extension RequestStatusX on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.pending:
        return 'En attente';
      case RequestStatus.accepted:
        return 'Acceptée';
      case RequestStatus.inProgress:
        return 'En cours';
      case RequestStatus.completed:
        return 'Terminée';
      case RequestStatus.cancelled:
        return 'Annulée';
      case RequestStatus.rejected:
        return 'Refusée';
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.pending:
        return PrestaHubTheme.warning;
      case RequestStatus.accepted:
        return PrestaHubTheme.primary;
      case RequestStatus.inProgress:
        return PrestaHubTheme.info;
      case RequestStatus.completed:
        return PrestaHubTheme.success;
      case RequestStatus.cancelled:
        return PrestaHubTheme.borderStrong;
      case RequestStatus.rejected:
        return PrestaHubTheme.danger;
    }
  }

  Color get softColor {
    switch (this) {
      case RequestStatus.pending:
        return PrestaHubTheme.warning.withValues(alpha: 0.12);
      case RequestStatus.accepted:
        return PrestaHubTheme.primary.withValues(alpha: 0.10);
      case RequestStatus.inProgress:
        return PrestaHubTheme.info.withValues(alpha: 0.12);
      case RequestStatus.completed:
        return PrestaHubTheme.success.withValues(alpha: 0.12);
      case RequestStatus.cancelled:
        return PrestaHubTheme.surface2Light;
      case RequestStatus.rejected:
        return PrestaHubTheme.danger.withValues(alpha: 0.12);
    }
  }

  IconData get icon {
    switch (this) {
      case RequestStatus.pending:
        return Icons.schedule_rounded;
      case RequestStatus.accepted:
        return Icons.check_circle_outline_rounded;
      case RequestStatus.inProgress:
        return Icons.play_circle_outline_rounded;
      case RequestStatus.completed:
        return Icons.task_alt_rounded;
      case RequestStatus.cancelled:
        return Icons.cancel_outlined;
      case RequestStatus.rejected:
        return Icons.block_rounded;
    }
  }
}

class ServiceRequestDraft {
  String? categoryLabel;
  IconData? categoryIcon;
  String title = '';
  String description = '';
  String address = '';
  String addressComplement = '';
  List<String> photos = [];
  DateTime? preferredDate;
  String preferredSlot = '';
  String urgency = 'Standard';
  double? budgetMin;
  double? budgetMax;

  ServiceRequestDraft();

  bool get hasCategory => categoryLabel != null && categoryLabel!.isNotEmpty;
  bool get hasDescription => title.isNotEmpty && description.isNotEmpty;
  bool get hasAddress => address.isNotEmpty;
  bool get hasSchedule => preferredDate != null && preferredSlot.isNotEmpty;

  bool get isComplete =>
      hasCategory && hasDescription && hasAddress && hasSchedule;
}

class ServiceRequestSummary {
  final String id;
  final String title;
  final String category;
  final IconData categoryIcon;
  final RequestStatus status;
  final String date;
  final String address;
  final String? providerName;
  final String? providerInitials;
  final int proposalsCount;

  const ServiceRequestSummary({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.status,
    required this.date,
    required this.address,
    this.providerName,
    this.providerInitials,
    this.proposalsCount = 0,
  });
}

class MissionSummary {
  final String id;
  final String title;
  final String category;
  final IconData categoryIcon;
  final RequestStatus status;
  final String completedOn;
  final String providerName;
  final String providerInitials;
  final String price;
  final double? rating;
  final bool hasReview;

  const MissionSummary({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.status,
    required this.completedOn,
    required this.providerName,
    required this.providerInitials,
    required this.price,
    this.rating,
    this.hasReview = false,
  });
}
