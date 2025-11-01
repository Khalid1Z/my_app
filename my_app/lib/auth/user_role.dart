enum UserRole {
  client,
  professional,
}

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.client:
        return 'Client';
      case UserRole.professional:
        return 'Professional';
    }
  }

  bool get isProfessional => this == UserRole.professional;
}
