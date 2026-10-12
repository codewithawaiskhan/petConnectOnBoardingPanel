import '../entities/auth_entity.dart';

abstract class AdminAuthRepository {
  Future<AuthEntity> login(String identifier, String password);
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> logout();
  bool isAuthenticated();
  AdminUserEntity? getCachedUser();
}
