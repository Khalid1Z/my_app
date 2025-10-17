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
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final bool isProCandidate;
  final bool kycSubmitted;
  final List<String> kycDocuments;

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    bool? isProCandidate,
    bool? kycSubmitted,
    List<String>? kycDocuments,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isProCandidate: isProCandidate ?? this.isProCandidate,
      kycSubmitted: kycSubmitted ?? this.kycSubmitted,
      kycDocuments: kycDocuments ?? this.kycDocuments,
    );
  }
}
