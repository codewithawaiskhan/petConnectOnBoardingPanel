class AdminUserEntity {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? phone;
  final List<String> roles;
  final String? status;

  const AdminUserEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.phone,
    required this.roles,
    this.status,
  });
}

class AuthEntity {
  final String token;
  final AdminUserEntity? user;
  final String? message;

  const AuthEntity({required this.token, this.user, this.message});
}
