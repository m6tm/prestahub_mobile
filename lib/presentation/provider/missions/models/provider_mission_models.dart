import 'package:flutter/material.dart';

import '../../../requests/models/service_request_models.dart';

/// Résumé d'une demande reçue côté prestataire.
class ProviderRequestSummary {
  final String id;
  final String title;
  final String category;
  final IconData categoryIcon;
  final RequestStatus status;
  final String receivedAt;
  final String clientName;
  final String clientInitials;
  final String address;
  final String? urgency;
  final double? budgetMin;
  final double? budgetMax;

  const ProviderRequestSummary({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.status,
    required this.receivedAt,
    required this.clientName,
    required this.clientInitials,
    required this.address,
    this.urgency,
    this.budgetMin,
    this.budgetMax,
  });

  String get budgetLabel {
    if (budgetMin != null && budgetMax != null) {
      return '${budgetMin!.toStringAsFixed(0)} € — ${budgetMax!.toStringAsFixed(0)} €';
    }
    if (budgetMin != null) return 'À partir de ${budgetMin!.toStringAsFixed(0)} €';
    return 'Budget à discuter';
  }
}

/// Détail complet d'une demande reçue.
class ProviderRequestDetail {
  final ProviderRequestSummary summary;
  final String description;
  final List<String> photos;
  final String preferredDate;
  final String preferredSlot;
  final String clientPhone;

  const ProviderRequestDetail({
    required this.summary,
    required this.description,
    this.photos = const [],
    required this.preferredDate,
    required this.preferredSlot,
    required this.clientPhone,
  });
}

/// Résumé d'une mission du prestataire (acceptée, en cours, terminée).
class ProviderMissionSummary {
  final String id;
  final String title;
  final String category;
  final IconData categoryIcon;
  final RequestStatus status;
  final String scheduledAt;
  final String clientName;
  final String clientInitials;
  final String address;
  final String price;
  final double? clientRating;
  final String? clientReview;
  final String? completedOn;

  const ProviderMissionSummary({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.status,
    required this.scheduledAt,
    required this.clientName,
    required this.clientInitials,
    required this.address,
    required this.price,
    this.clientRating,
    this.clientReview,
    this.completedOn,
  });

  ProviderMissionSummary copyWith({RequestStatus? status}) {
    return ProviderMissionSummary(
      id: id,
      title: title,
      category: category,
      categoryIcon: categoryIcon,
      status: status ?? this.status,
      scheduledAt: scheduledAt,
      clientName: clientName,
      clientInitials: clientInitials,
      address: address,
      price: price,
      clientRating: clientRating,
      clientReview: clientReview,
      completedOn: completedOn,
    );
  }
}

/// Référentiel (mock) des demandes et missions utilisées par les écrans prestataire.
class ProviderMissionsMock {
  static final requests = <ProviderRequestSummary>[
    ProviderRequestSummary(
      id: 'PREQ-2041',
      title: 'Fuite dans la salle de bain',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.pending,
      receivedAt: 'Il y a 12 min',
      clientName: 'Alice Martin',
      clientInitials: 'AM',
      address: '12 rue de la République, Paris 11e',
      urgency: 'Urgent',
      budgetMin: 80,
      budgetMax: 150,
    ),
    ProviderRequestSummary(
      id: 'PREQ-2039',
      title: 'Installation chauffe-eau 150L',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.pending,
      receivedAt: 'Il y a 1 h',
      clientName: 'Lucas Bernard',
      clientInitials: 'LB',
      address: '5 rue Lamarck, Paris 18e',
      urgency: 'Standard',
      budgetMin: 300,
      budgetMax: 450,
    ),
    ProviderRequestSummary(
      id: 'PREQ-2036',
      title: 'Remplacement robinet cuisine',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.accepted,
      receivedAt: 'Hier',
      clientName: 'Sophie Durand',
      clientInitials: 'SD',
      address: '42 bd Voltaire, Paris 11e',
      urgency: 'Standard',
      budgetMin: 80,
      budgetMax: 120,
    ),
    ProviderRequestSummary(
      id: 'PREQ-2028',
      title: 'Débouchage évier',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.rejected,
      receivedAt: 'Il y a 3 j',
      clientName: 'Paul Morel',
      clientInitials: 'PM',
      address: 'Montrouge',
      urgency: 'Standard',
    ),
  ];

  static ProviderRequestDetail detailOf(ProviderRequestSummary s) {
    return ProviderRequestDetail(
      summary: s,
      description:
          'Bonjour, j\'ai une fuite d\'eau sous le lavabo de ma salle de bain depuis ce matin. L\'eau goutte de manière continue. Pouvez-vous intervenir rapidement ? Merci.',
      photos: const [],
      preferredDate: 'Demain',
      preferredSlot: '09:00 — 12:00',
      clientPhone: '+33 6 12 34 56 78',
    );
  }

  static final missionsInProgress = <ProviderMissionSummary>[
    ProviderMissionSummary(
      id: 'PMIS-1012',
      title: 'Remplacement robinet cuisine',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.accepted,
      scheduledAt: 'Demain, 10:00',
      clientName: 'Sophie Durand',
      clientInitials: 'SD',
      address: '42 bd Voltaire, Paris 11e',
      price: '95 €',
    ),
    ProviderMissionSummary(
      id: 'PMIS-1010',
      title: 'Réparation chasse d\'eau',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.inProgress,
      scheduledAt: 'Aujourd\'hui, 14:30',
      clientName: 'Marc Petit',
      clientInitials: 'MP',
      address: '8 rue Oberkampf, Paris 11e',
      price: '75 €',
    ),
  ];

  static final missionsCompleted = <ProviderMissionSummary>[
    ProviderMissionSummary(
      id: 'PMIS-1005',
      title: 'Dépannage fuite WC',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.completed,
      scheduledAt: '12 avr. 2026, 09:00',
      completedOn: '12 avril 2026',
      clientName: 'Emma Bernard',
      clientInitials: 'EB',
      address: '3 rue Saint-Maur, Paris 11e',
      price: '120 €',
      clientRating: 5,
      clientReview:
          'Intervention rapide et soignée. Très pro, je recommande sans hésiter.',
    ),
    ProviderMissionSummary(
      id: 'PMIS-1002',
      title: 'Pose mitigeur salle de bain',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.completed,
      scheduledAt: '5 avr. 2026, 14:00',
      completedOn: '5 avril 2026',
      clientName: 'Thomas Girard',
      clientInitials: 'TG',
      address: 'Saint-Ouen',
      price: '140 €',
      clientRating: 4,
      clientReview: 'Bon travail, ponctuel. Juste un peu de poussière à nettoyer.',
    ),
    ProviderMissionSummary(
      id: 'PMIS-0998',
      title: 'Débouchage canalisation',
      category: 'Plomberie',
      categoryIcon: Icons.plumbing_rounded,
      status: RequestStatus.cancelled,
      scheduledAt: '1 avr. 2026',
      completedOn: '1 avril 2026',
      clientName: 'Julien Roux',
      clientInitials: 'JR',
      address: 'Paris 20e',
      price: '—',
    ),
  ];

  static ProviderRequestSummary? requestById(String id) {
    try {
      return requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  static ProviderMissionSummary? missionById(String id) {
    try {
      return [...missionsInProgress, ...missionsCompleted]
          .firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Motifs de refus prédéfinis.
enum RefusalReason {
  unavailable,
  outOfZone,
  outOfScope,
  priceTooLow,
  other,
}

extension RefusalReasonLabel on RefusalReason {
  String get label {
    switch (this) {
      case RefusalReason.unavailable:
        return 'Indisponible aux créneaux proposés';
      case RefusalReason.outOfZone:
        return 'Hors de ma zone d\'intervention';
      case RefusalReason.outOfScope:
        return 'Non couvert par mes services';
      case RefusalReason.priceTooLow:
        return 'Budget non adapté';
      case RefusalReason.other:
        return 'Autre motif';
    }
  }
}
