enum UserRole {
  client,
  provider,
  admin,
  unknown;

  static UserRole fromString(String? role) {
    switch (role) {
      case 'client':
        return UserRole.client;
      case 'provider':
        return UserRole.provider;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.unknown;
    }
  }

  String get value {
    switch (this) {
      case UserRole.client:
        return 'client';
      case UserRole.provider:
        return 'provider';
      case UserRole.admin:
        return 'admin';
      case UserRole.unknown:
        return 'unknown';
    }
  }
}
