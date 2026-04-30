/// Modèle d'adresse côté présentation.
///
/// Simplifié pour la première itération (état local). Sera remplacé par
/// le modèle de domaine une fois le repository `addresses` disponible.
class AddressModel {
  final String id;
  final String label;
  final String street;
  final String postalCode;
  final String city;
  final String? additionalInfo;
  final bool isPrimary;

  const AddressModel({
    required this.id,
    required this.label,
    required this.street,
    required this.postalCode,
    required this.city,
    this.additionalInfo,
    this.isPrimary = false,
  });

  String get singleLine =>
      '$street, $postalCode $city${additionalInfo != null ? ' · $additionalInfo' : ''}';

  AddressModel copyWith({
    String? id,
    String? label,
    String? street,
    String? postalCode,
    String? city,
    String? additionalInfo,
    bool? isPrimary,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
