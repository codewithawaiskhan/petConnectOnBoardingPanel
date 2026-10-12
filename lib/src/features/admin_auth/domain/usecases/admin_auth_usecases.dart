import '../entities/auth_entity.dart';
import '../repositories/admin_auth_repository.dart';

class AdminAuthUseCases {
  final AdminAuthRepository repository;

  const AdminAuthUseCases({required this.repository});

  Future<AuthEntity> login(String identifier, String password) async {
    return await repository.login(identifier, password);
  }

  Future<void> saveToken(String token) async {
    await repository.saveToken(token);
  }

  String? getToken() {
    return repository.getToken();
  }

  Future<void> logout() async {
    await repository.logout();
  }

  bool isAuthenticated() {
    return repository.isAuthenticated();
  }

  AdminUserEntity? getCachedUser() {
    return repository.getCachedUser();
  }
}
