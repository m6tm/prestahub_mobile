import 'package:equatable/equatable.dart';

/// Modèlise une requête HTTP échouée qui doit être rejouée ultérieurement.
/// Contient toutes les données nécessaires pour reconstruire la requête Dio d'origine.
class SyncRequest extends Equatable {
  /// Identifiant unique de la requête.
  final String id;

  /// Chemin relatif de l'API (ex: '/profile/update').
  final String path;

  /// Méthode HTTP utilisée ('POST', 'PUT', 'DELETE', 'PATCH').
  final String method;

  /// Corps de la requête (optionnel).
  final Map<String, dynamic>? data;

  /// Paramètres de requête URL (optionnels).
  final Map<String, dynamic>? queryParameters;

  /// Headers personnalisés (optionnels).
  final Map<String, dynamic>? headers;

  /// Date et heure à laquelle la requête a été mise en file d'attente.
  final DateTime createdAt;

  /// Nombre de tentatives de synchronisation effectuées.
  final int attempts;

  /// Priorité de la requête (plus le nombre est petit, plus la priorité est haute).
  /// Permet d'ordonner la synchronisation des données critiques.
  final int priority;

  const SyncRequest({
    required this.id,
    required this.path,
    required this.method,
    this.data,
    this.queryParameters,
    this.headers,
    required this.createdAt,
    this.attempts = 0,
    this.priority = 100, // Priorité par défaut
  });

  /// Convertit une instance en Map JSON pour la persistance locale.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'method': method,
      'data': data,
      'queryParameters': queryParameters,
      'headers': headers,
      'createdAt': createdAt.toIso8601String(),
      'attempts': attempts,
      'priority': priority,
    };
  }

  /// Crée une instance de SyncRequest à partir d'un Map JSON.
  factory SyncRequest.fromJson(Map<String, dynamic> json) {
    return SyncRequest(
      id: json['id'] as String,
      path: json['path'] as String,
      method: json['method'] as String,
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      queryParameters: json['queryParameters'] != null
          ? Map<String, dynamic>.from(json['queryParameters'])
          : null,
      headers:
          json['headers'] != null ? Map<String, dynamic>.from(json['headers']) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      attempts: json['attempts'] as int? ?? 0,
      priority: json['priority'] as int? ?? 100,
    );
  }

  @override
  List<Object?> get props => [
        id,
        path,
        method,
        data,
        queryParameters,
        headers,
        createdAt,
        attempts,
        priority
      ];

  /// Crée une copie modifiée de la requête avec un nouveau nombre de tentatives.
  SyncRequest copyWith({int? attempts}) {
    return SyncRequest(
      id: id,
      path: path,
      method: method,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      createdAt: createdAt,
      attempts: attempts ?? this.attempts,
      priority: priority,
    );
  }
}
