import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/user_profile.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier(
    const UserProfile(
      id: 'user-1',
      name: 'Amelia Rogers',
      phone: '+1 555-0100',
      email: 'amelia.rogers@example.com',
      isProCandidate: true,
      kycSubmitted: false,
      kycDocuments: <String>[],
    ),
  );
});

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier(UserProfile initial) : super(initial);

  void updateContact({
    required String name,
    required String phone,
    required String email,
  }) {
    state = state.copyWith(name: name, phone: phone, email: email);
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
}
