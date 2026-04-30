/// Contexte minimal passé à l'écran de notation pour pré-remplir
/// les informations de mission sans refaire un fetch.
class ReviewMissionContext {
  final String missionId;
  final String missionTitle;
  final String providerName;
  final String providerInitials;
  final String completedOn;

  const ReviewMissionContext({
    required this.missionId,
    required this.missionTitle,
    required this.providerName,
    required this.providerInitials,
    required this.completedOn,
  });
}

/// Contexte passé à l'écran de signalement d'un avis.
class ReportReviewContext {
  final String reviewId;
  final String authorName;
  final String excerpt;

  const ReportReviewContext({
    required this.reviewId,
    required this.authorName,
    required this.excerpt,
  });
}
