import 'package:deepshield_ai/features/authentication/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signUp({required String fullName, required String email, required String password});
  Future<bool> resetPassword({required String email});
  Future<UserModel> signInWithGoogle();
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}
