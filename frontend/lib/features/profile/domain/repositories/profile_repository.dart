import 'package:deepshield_ai/features/authentication/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({String? fullName, String? email, String? avatarUrl});
  Future<bool> upgradePlan(String planId);
}
