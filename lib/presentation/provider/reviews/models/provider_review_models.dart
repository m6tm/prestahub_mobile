// Modèles UI pour les avis reçus côté prestataire.
// Seront remplacés par les entités de domaine une fois le repository
// `reviews` connecté.

/// Avis laissé par un client sur une mission terminée.
class ProviderReview {
  final String id;
  final String missionId;
  final String missionTitle;
  final String clientName;
  final String clientInitials;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String? providerResponse;
  final DateTime? respondedAt;

  const ProviderReview({
    required this.id,
    required this.missionId,
    required this.missionTitle,
    required this.clientName,
    required this.clientInitials,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.providerResponse,
    this.respondedAt,
  });

  bool get hasResponse =>
      providerResponse != null && providerResponse!.isNotEmpty;

  ProviderReview copyWith({
    String? providerResponse,
    DateTime? respondedAt,
  }) {
    return ProviderReview(
      id: id,
      missionId: missionId,
      missionTitle: missionTitle,
      clientName: clientName,
      clientInitials: clientInitials,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      providerResponse: providerResponse ?? this.providerResponse,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}

/// Mock des avis reçus — utilisé par les écrans le temps du branchement API.
class ProviderReviewsMock {
  static final List<ProviderReview> reviews = [
    ProviderReview(
      id: 'REV-1005',
      missionId: 'PMIS-1005',
      missionTitle: 'Dépannage fuite WC',
      clientName: 'Emma Bernard',
      clientInitials: 'EB',
      rating: 5,
      comment:
          'Intervention rapide et soignée. Très pro, je recommande sans hésiter.',
      createdAt: DateTime(2026, 4, 12),
      providerResponse: 'Merci beaucoup Emma, à bientôt si besoin !',
      respondedAt: DateTime(2026, 4, 13),
    ),
    ProviderReview(
      id: 'REV-1002',
      missionId: 'PMIS-1002',
      missionTitle: 'Pose mitigeur salle de bain',
      clientName: 'Thomas Girard',
      clientInitials: 'TG',
      rating: 4,
      comment:
          'Bon travail, ponctuel. Juste un peu de poussière à nettoyer après intervention.',
      createdAt: DateTime(2026, 4, 5),
    ),
    ProviderReview(
      id: 'REV-0992',
      missionId: 'PMIS-0992',
      missionTitle: 'Dépannage chauffe-eau',
      clientName: 'Karim Mansouri',
      clientInitials: 'KM',
      rating: 5,
      comment:
          'Excellent prestataire, très à l\'écoute. Mon chauffe-eau fonctionne à nouveau parfaitement.',
      createdAt: DateTime(2026, 3, 21),
      providerResponse:
          'Merci Karim, ce fut un plaisir de vous aider.',
      respondedAt: DateTime(2026, 3, 22),
    ),
    ProviderReview(
      id: 'REV-0985',
      missionId: 'PMIS-0985',
      missionTitle: 'Remplacement joint salle de bain',
      clientName: 'Léa Fontaine',
      clientInitials: 'LF',
      rating: 3,
      comment:
          'Intervention correcte mais un léger retard sur l\'horaire prévu.',
      createdAt: DateTime(2026, 3, 8),
    ),
  ];

  static ProviderReview? byId(String id) {
    try {
      return reviews.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  static double averageRating() {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  static Map<int, int> distribution() {
    final map = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final bucket = r.rating.round();
      map[bucket] = (map[bucket] ?? 0) + 1;
    }
    return map;
  }
}
