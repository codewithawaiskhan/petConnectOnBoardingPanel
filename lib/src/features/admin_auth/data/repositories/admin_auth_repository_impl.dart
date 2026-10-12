import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/admin_auth_repository.dart';
import '../data_sources/admin_auth_local_data_source.dart';
import '../data_sources/admin_auth_remote_data_source.dart';
import '../models/auth_model.dart';

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  final AdminAuthRemoteDataSource remoteDataSource;
  final AdminAuthLocalDataSource localDataSource;
  final ApiServices apiServices;

  AdminAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.apiServices,
  });

  @override
  Future<AuthEntity> login(String identifier, String password) async {
    final Response response = await remoteDataSource.login(identifier, password);

    final Map<String, dynamic> rawResponse = response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    final authModel = AuthModel.fromJson(rawResponse);

    if (authModel.token.trim().isNotEmpty) {
      await localDataSource.cacheToken(authModel.token);
      apiServices.updateHeader(authModel.token);
      debugPrint('AdminAuthRepository: Token successfully cached to SharedPreferences');
    } else {
      debugPrint('AdminAuthRepository: WARNING - No token found in login response to cache!');
    }

    if (authModel.user != null) {
      final userModel = authModel.user is AdminUserModel
          ? authModel.user as AdminUserModel
          : AdminUserModel.fromEntity(authModel.user!);
      await localDataSource.cacheUser(jsonEncode(userModel.toJson()));
      debugPrint('AdminAuthRepository: User details cached to SharedPreferences');
    }

    return authModel;
  }

  @override
  Future<void> saveToken(String token) async {
    await localDataSource.cacheToken(token);
    apiServices.updateHeader(token);
  }

  @override
  String? getToken() {
    final token = localDataSource.getCachedToken();
    if (token != null && token.trim().isNotEmpty) {
      apiServices.updateHeader(token);
    }
    return token;
  }

  @override
  AdminUserEntity? getCachedUser() {
    final cached = localDataSource.getCachedUser();
    if (cached != null && cached.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return AdminUserModel.fromJson(decoded);
      } catch (e) {
        debugPrint('Error decoding cached user: $e');
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
    apiServices.updateHeader('');
  }

  @override
  bool isAuthenticated() {
    final token = localDataSource.getCachedToken();
    return token != null && token.trim().isNotEmpty;
  }
}
