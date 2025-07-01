class UserAdminModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime joinedDate;

  UserAdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedDate,
  });

  UserAdminModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    DateTime? joinedDate,
  }) {
    return UserAdminModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}