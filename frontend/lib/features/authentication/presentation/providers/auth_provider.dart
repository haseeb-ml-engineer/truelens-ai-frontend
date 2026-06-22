import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepshield_ai/features/authentication/data/models/user_model.dart';
import 'package:deepshield_ai/features/authentication/data/repositories/mock_auth_repository.dart';
import 'package:deepshield_ai/features/authentication/domain/repositories/auth_repository.dart';

/// Authentication state.
enum AuthStatus { initial, authenticated, unauthenticated, loading }

/// Auth state class holding the status and current user.
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

/// Auth state notifier managing login/signup/logout flows.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  /// Login with email and password.
  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authService.login(email: email, password: password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  /// Sign up with name, email, and password.
  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authService.signUp(
        fullName: name,
        email: email,
        password: password,
      );
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  /// Sign in with Google.
  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _authService.signInWithGoogle();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  /// Reset password.
  Future<bool> resetPassword(String email) async {
    try {
      return await _authService.resetPassword(email: email);
    } catch (e) {
      return false;
    }
  }

  /// Logout.
  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Skip auth (for development ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Â auto-login with mock user).
  void skipAuth() {
    state = AuthState(
      status: AuthStatus.authenticated,
      user: UserModel.mock(),
    );
  }
}

/// Provider for the MockAuthRepository.
final authServiceProvider = Provider<AuthRepository>((ref) => MockAuthRepository());

/// Provider for the AuthNotifier.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

/// Convenience provider for the current user.
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});