import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.isProCandidate,
    required this.kycSubmitted,
    required this.kycDocuments,
    required this.addressLine,
    required this.city,
    required this.nationalId,
    required this.dateOfBirth,
    required this.identityPhotoPath,
    required this.identityVerified,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final bool isProCandidate;
  final bool kycSubmitted;
  final List<String> kycDocuments;
  final String addressLine;
  final String city;
  final String nationalId;
  final DateTime? dateOfBirth;
  final String identityPhotoPath;
  final bool identityVerified;

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    bool? isProCandidate,
    bool? kycSubmitted,
    List<String>? kycDocuments,
    String? addressLine,
    String? city,
    String? nationalId,
    DateTime? dateOfBirth,
    String? identityPhotoPath,
    bool? identityVerified,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isProCandidate: isProCandidate ?? this.isProCandidate,
      kycSubmitted: kycSubmitted ?? this.kycSubmitted,
      kycDocuments: kycDocuments ?? this.kycDocuments,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      nationalId: nationalId ?? this.nationalId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      identityPhotoPath: identityPhotoPath ?? this.identityPhotoPath,
      identityVerified: identityVerified ?? this.identityVerified,
    );
  }
}
