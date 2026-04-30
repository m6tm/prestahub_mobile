// Modèles UI pour la configuration du profil professionnel prestataire.
// Version présentation — sera remplacée par les entités du domaine une fois
// le repository `provider_profile` branché sur Supabase.

/// Profil professionnel affiché dans l'écran d'édition.
class ProviderBusinessProfile {
  final String businessName;
  final String description;
  final String phone;
  final String email;
  final String siret;
  final String? avatarUrl;

  const ProviderBusinessProfile({
    required this.businessName,
    required this.description,
    required this.phone,
    required this.email,
    required this.siret,
    this.avatarUrl,
  });

  ProviderBusinessProfile copyWith({
    String? businessName,
    String? description,
    String? phone,
    String? email,
    String? siret,
    String? avatarUrl,
  }) {
    return ProviderBusinessProfile(
      businessName: businessName ?? this.businessName,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      siret: siret ?? this.siret,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  bool get isComplete =>
      businessName.isNotEmpty && description.isNotEmpty && phone.isNotEmpty;
}

/// Mode de facturation pour un service.
enum PricingType { hourly, fixed, range }

extension PricingTypeLabel on PricingType {
  String get label {
    switch (this) {
      case PricingType.hourly:
        return 'Horaire';
      case PricingType.fixed:
        return 'Forfait';
      case PricingType.range:
        return 'Fourchette';
    }
  }
}

/// Service proposé par le prestataire (lié à une catégorie).
class ProviderService {
  final String id;
  final String categoryId;
  final String categoryName;
  final String name;
  final String description;
  final PricingType pricingType;
  final double? price;
  final double? priceMin;
  final double? priceMax;
  final bool isActive;

  const ProviderService({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.pricingType,
    this.price,
    this.priceMin,
    this.priceMax,
    this.isActive = true,
  });

  String get displayPrice {
    switch (pricingType) {
      case PricingType.hourly:
        return price != null
            ? '${price!.toStringAsFixed(0)} € / h'
            : 'Non défini';
      case PricingType.fixed:
        return price != null
            ? 'Forfait ${price!.toStringAsFixed(0)} €'
            : 'Non défini';
      case PricingType.range:
        if (priceMin != null && priceMax != null) {
          return 'De ${priceMin!.toStringAsFixed(0)} € à ${priceMax!.toStringAsFixed(0)} €';
        }
        return 'Non défini';
    }
  }

  ProviderService copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    String? name,
    String? description,
    PricingType? pricingType,
    double? price,
    double? priceMin,
    double? priceMax,
    bool? isActive,
  }) {
    return ProviderService(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      name: name ?? this.name,
      description: description ?? this.description,
      pricingType: pricingType ?? this.pricingType,
      price: price ?? this.price,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Catégorie de service disponible à l'ajout (référentiel).
class ServiceCategoryOption {
  final String id;
  final String name;

  const ServiceCategoryOption({required this.id, required this.name});
}

/// Zone d'intervention : une ville avec un ensemble de quartiers.
class ProviderZone {
  final String id;
  final String name;
  final String city;
  final List<String> districts;
  final bool isActive;

  const ProviderZone({
    required this.id,
    required this.name,
    required this.city,
    this.districts = const [],
    this.isActive = true,
  });

  ProviderZone copyWith({
    String? id,
    String? name,
    String? city,
    List<String>? districts,
    bool? isActive,
  }) {
    return ProviderZone(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      districts: districts ?? this.districts,
      isActive: isActive ?? this.isActive,
    );
  }

  String get summary => districts.isEmpty
      ? city
      : '$city · ${districts.length} quartier${districts.length > 1 ? 's' : ''}';
}

/// Créneau horaire récurrent pour un jour de la semaine.
class AvailabilitySlot {
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const AvailabilitySlot({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  AvailabilitySlot copyWith({
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    bool? isAvailable,
  }) {
    return AvailabilitySlot(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

/// Exception de disponibilité (absence ponctuelle).
class AvailabilityException {
  final String id;
  final DateTime date;
  final String? reason;

  const AvailabilityException({
    required this.id,
    required this.date,
    this.reason,
  });
}

/// Statut de vérification d'un document ou du profil global.
enum VerificationState { unverified, pending, verified, rejected }

extension VerificationStateLabel on VerificationState {
  String get label {
    switch (this) {
      case VerificationState.unverified:
        return 'Non vérifié';
      case VerificationState.pending:
        return 'En cours de vérification';
      case VerificationState.verified:
        return 'Vérifié';
      case VerificationState.rejected:
        return 'Refusé';
    }
  }
}

/// Type de document justificatif attendu.
enum ProviderDocumentType {
  idCard,
  businessRegistration,
  certification,
  other,
}

extension ProviderDocumentTypeLabel on ProviderDocumentType {
  String get label {
    switch (this) {
      case ProviderDocumentType.idCard:
        return 'Pièce d\'identité';
      case ProviderDocumentType.businessRegistration:
        return 'Registre du commerce';
      case ProviderDocumentType.certification:
        return 'Certification';
      case ProviderDocumentType.other:
        return 'Autre document';
    }
  }

  String get description {
    switch (this) {
      case ProviderDocumentType.idCard:
        return 'CNI, passeport ou titre de séjour';
      case ProviderDocumentType.businessRegistration:
        return 'Kbis, RNA ou équivalent';
      case ProviderDocumentType.certification:
        return 'Diplôme ou certification professionnelle';
      case ProviderDocumentType.other:
        return 'Tout autre justificatif utile';
    }
  }
}

/// Document justificatif envoyé par le prestataire.
class ProviderDocument {
  final String id;
  final ProviderDocumentType type;
  final String fileName;
  final VerificationState status;
  final DateTime uploadedAt;

  const ProviderDocument({
    required this.id,
    required this.type,
    required this.fileName,
    required this.status,
    required this.uploadedAt,
  });

  ProviderDocument copyWith({
    String? id,
    ProviderDocumentType? type,
    String? fileName,
    VerificationState? status,
    DateTime? uploadedAt,
  }) {
    return ProviderDocument(
      id: id ?? this.id,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      status: status ?? this.status,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

/// Statut global de vérification du profil prestataire.
class ProviderVerificationStatus {
  final VerificationState state;
  final String? rejectionReason;
  final DateTime? updatedAt;

  const ProviderVerificationStatus({
    required this.state,
    this.rejectionReason,
    this.updatedAt,
  });
}
