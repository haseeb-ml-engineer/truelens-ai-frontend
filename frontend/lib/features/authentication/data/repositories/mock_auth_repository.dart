import 'package:deepshield_ai/features/authentication/domain/repositories/auth_repository.dart';
import 'package:deepshield_ai/features/authentication/data/models/user_model.dart';

/// Mock authentication service.
///
/// Returns dummy data for development. Replace the method bodies
/// with real API calls (e.g. Firebase Auth, FastAPI) later.
class MockAuthRepository implements AuthRepository {
  /// Simulates a login request.
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return UserModel.mock();
  }

  /// Simulates a sign-up request.
  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel.mock().copyWith(
      fullName: fullName,
      email: email,
    );
  }

  /// Simulates a password reset request.
  @override
  Future<bool> resetPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Simulates Google Sign-In.
  @override
  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel.mock();
  }

  /// Simulates logout.
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Returns the currently "logged-in" user.
  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return UserModel.mock();
  }
}