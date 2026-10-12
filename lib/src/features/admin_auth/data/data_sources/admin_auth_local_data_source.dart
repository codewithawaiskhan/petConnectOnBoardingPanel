import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/config/api_endpoints.dart';

abstract class AdminAuthLocalDataSource {
  Future<void> cacheToken(String token);
  String? getCachedToken();
  Future<void> clearToken();
  Future<void> cacheUser(String userJson);
  String? getCachedUser();
}

class AdminAuthLocalDataSourceImpl implements AdminAuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AdminAuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(ApiEndpoints.authTokenKey, token);
  }

  @override
  String? getCachedToken() {
    return sharedPreferences.getString(ApiEndpoints.authTokenKey);
  }

  @override
  Future<void> cacheUser(String userJson) async {
    await sharedPreferences.setString(ApiEndpoints.cachedUserKey, userJson);
  }

  @override
  String? getCachedUser() {
    return sharedPreferences.getString(ApiEndpoints.cachedUserKey);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(ApiEndpoints.authTokenKey);
    await sharedPreferences.remove(ApiEndpoints.cachedUserKey);
  }
}
