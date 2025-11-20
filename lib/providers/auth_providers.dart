import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

/// Provider for current UserModel
final userModelProvider = StreamProvider<UserModel?>((ref) {
  // Watch auth state
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return AuthService.userModelStream;
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider for checking if user has completed tutorial
final hasCompletedTutorialProvider = Provider<bool>((ref) {
  final userModel = ref.watch(userModelProvider);
  return userModel.when(
    data: (user) => user?.hasCompletedTutorial ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

