import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/auth/user_role.dart';

import 'models/user_profile.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
      return UserProfileNotifier(
        UserProfile(
          id: 'user-1',
          name: 'Amelia Rogers',
          phone: '+1 555-0100',
          email: 'amelia.rogers@example.com',
          isProCandidate: true,
          kycSubmitted: false,
          kycDocuments: <String>[],
          addressLine: '221B Palm Avenue',
          city: 'Casablanca',
          nationalId: 'AA123456',
          dateOfBirth: DateTime(1993, 4, 12),
          identityPhotoPath: '',
          identityVerified: false,
        ),
      );
    });

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier(super.initial);

  void updateContact({
    required String name,
    required String phone,
    required String email,
    String? addressLine,
    String? city,
    String? nationalId,
    DateTime? dateOfBirth,
  }) {
    state = state.copyWith(name: name, phone: phone, email: email);
    if (addressLine != null || city != null || nationalId != null) {
      state = state.copyWith(
        addressLine: addressLine ?? state.addressLine,
        city: city ?? state.city,
        nationalId: nationalId ?? state.nationalId,
      );
    }
    if (dateOfBirth != null) {
      state = state.copyWith(dateOfBirth: dateOfBirth);
    }
  }

  void updateAddress({required String addressLine, required String city}) {
    state = state.copyWith(addressLine: addressLine, city: city);
  }

  void updateIdentityDetails({
    required String nationalId,
    DateTime? dateOfBirth,
    String? identityPhotoPath,
  }) {
    state = state.copyWith(
      nationalId: nationalId,
      dateOfBirth: dateOfBirth ?? state.dateOfBirth,
      identityPhotoPath: identityPhotoPath ?? state.identityPhotoPath,
      identityVerified: false,
    );
  }

  void updateKycDocuments(List<String> documents) {
    state = state.copyWith(
      kycDocuments: documents,
      kycSubmitted: documents.isNotEmpty ? state.kycSubmitted : false,
    );
  }

  void markKycSubmitted() {
    state = state.copyWith(kycSubmitted: true);
  }

  void markIdentityVerified() {
    state = state.copyWith(identityVerified: true);
  }

  void syncWithAuthUser({
    required UserRole role,
    required String fullName,
    required String email,
  }) {
    state = state.copyWith(
      name: fullName,
      email: email,
      isProCandidate: role.isProfessional,
    );
  }
}
