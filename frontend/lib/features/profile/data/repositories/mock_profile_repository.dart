import 'package:deepshield_ai/features/profile/domain/repositories/profile_repository.dart';
import 'package:deepshield_ai/features/authentication/data/models/user_model.dart';

/// Mock profile service.
///
/// Handles user profile operations. Replace with Firebase
/// or FastAPI calls later.
class MockProfileRepository implements ProfileRepository {
  /// Returns the current user profile.
  @override
  Future<UserModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return UserModel.mock();
  }

  /// Updates the user profile.
  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel.mock().copyWith(
      fullName: fullName,
      email: email,
      avatarUrl: avatarUrl,
    );
  }

  /// Simulates upgrading the subscription plan.
  @override
  Future<bool> upgradePlan(String planId) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}