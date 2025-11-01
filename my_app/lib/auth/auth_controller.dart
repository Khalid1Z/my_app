import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/profile/providers.dart';

import 'user_role.dart';

class AuthState {
  const AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.errorMessage,
    this.fullName,
    this.email,
    this.role = UserRole.client,
  });

  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final String? fullName;
  final String? email;
  final UserRole role;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    String? fullName,
    String? email,
    UserRole? role,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref)
      : super(const AuthState(
          isAuthenticated: false,
        ));

  final Ref _ref;

  Future<void> signIn({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Please provide email and password.',
      );
      return;
    }
    final resolvedName = state.fullName ?? email.split('@').first;
    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      email: email,
      fullName: resolvedName,
      role: role,
    );
    _syncProfile(
      role: role,
      fullName: resolvedName,
      email: email,
    );
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (fullName.isEmpty || email.isEmpty || password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'Please provide a name, email, and password (6+ characters).',
      );
      return;
    }
    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      email: email,
      fullName: fullName,
      role: role,
    );
    _syncProfile(
      role: role,
      fullName: fullName,
      email: email,
    );
  }

  void signOut() {
    state = const AuthState(isAuthenticated: false);
  }

  void _syncProfile({
    required UserRole role,
    required String fullName,
    required String email,
  }) {
    _ref
        .read(userProfileProvider.notifier)
        .syncWithAuthUser(role: role, fullName: fullName, email: email);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
