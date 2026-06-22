/// Data model representing a user.
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String plan;
  final DateTime createdAt;
  final int totalScans;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.plan = 'Free',
    required this.createdAt,
    this.totalScans = 0,
  });

  /// Creates a mock user for development.
  factory UserModel.mock() {
    return UserModel(
      id: 'usr_001',
      fullName: 'Alex Johnson',
      email: 'alex@truelens.ai',
      avatarUrl: null,
      plan: 'Pro',
      createdAt: DateTime(2024, 6, 1),
      totalScans: 47,
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? plan,
    DateTime? createdAt,
    int? totalScans,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
      totalScans: totalScans ?? this.totalScans,
    );
  }
}