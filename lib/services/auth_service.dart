import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrixmeds/models/user.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String token) async {
    state = const AsyncValue.loading();
    try {
      // Store token securely
      // TODO: Implement secure storage
      state = AsyncValue.data(User(token: token));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void logout() {
    // Clear token
    state = const AsyncValue.data(null);
  }
}

class User {
  final String token;

  User({required this.token});
}
