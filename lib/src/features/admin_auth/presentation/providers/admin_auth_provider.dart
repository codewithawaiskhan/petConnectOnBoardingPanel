import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/admin_auth_usecases.dart';

class AdminAuthProvider extends ChangeNotifier {
  final AdminAuthUseCases useCases;

  AdminAuthProvider({required this.useCases}) {
    checkAuthStatus();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AdminUserEntity? _currentUser;
  AdminUserEntity? get currentUser => _currentUser;

  String? _token;
  String? get token => _token;

  Map<String, dynamic>? _decodedToken;
  Map<String, dynamic>? get decodedToken => _decodedToken;

  String get adminEmail {
    if (_currentUser?.email.isNotEmpty == true) return _currentUser!.email;
    if (_decodedToken != null && _decodedToken!['email'] != null) {
      return _decodedToken!['email'].toString();
    }
    return 'admin@petaccessapp.com';
  }

  String get adminName {
    if (_currentUser?.fullName.isNotEmpty == true) {
      return _currentUser!.fullName;
    }
    if (_currentUser?.username.isNotEmpty == true) {
      return _currentUser!.username;
    }
    if (_decodedToken != null) {
      if (_decodedToken!['fullName'] != null) {
        return _decodedToken!['fullName'].toString();
      }
      if (_decodedToken!['username'] != null) {
        return _decodedToken!['username'].toString();
      }
      if (_decodedToken!['name'] != null) {
        return _decodedToken!['name'].toString();
      }
    }
    return 'Admin';
  }

  String get adminRole {
    if (_currentUser?.roles.isNotEmpty == true) {
      return _currentUser!.roles.first;
    }
    if (_decodedToken != null) {
      if (_decodedToken!['roles'] is List &&
          (_decodedToken!['roles'] as List).isNotEmpty) {
        return (_decodedToken!['roles'] as List).first.toString();
      }
      if (_decodedToken!['role'] != null) {
        return _decodedToken!['role'].toString();
      }
    }
    return 'Super Admin';
  }

  Future<bool> checkAuthStatus() async {
    _isInitializing = true;
    try {
      final storedToken = useCases.getToken();
      if (storedToken == null || storedToken.trim().isEmpty) {
        _isLoggedIn = false;
        _token = null;
        _decodedToken = null;
        _currentUser = null;
        return false;
      }

      if (JwtDecoder.isExpired(storedToken)) {
        await useCases.logout();
        _isLoggedIn = false;
        _token = null;
        _decodedToken = null;
        _currentUser = null;
        return false;
      }

      _token = storedToken;
      _decodedToken = JwtDecoder.decode(storedToken);
      _isLoggedIn = true;

      _currentUser = useCases.getCachedUser();

      if (_currentUser == null && _decodedToken != null) {
        final rolesList = <String>[];
        if (_decodedToken!['roles'] is List) {
          for (final r in _decodedToken!['roles']) {
            rolesList.add(r.toString());
          }
        } else if (_decodedToken!['role'] != null) {
          rolesList.add(_decodedToken!['role'].toString());
        }

        _currentUser = AdminUserEntity(
          id:
              _decodedToken!['id']?.toString() ??
              _decodedToken!['_id']?.toString() ??
              '',
          fullName:
              _decodedToken!['fullName']?.toString() ??
              _decodedToken!['name']?.toString() ??
              'Admin',
          username: _decodedToken!['username']?.toString() ?? '',
          email: _decodedToken!['email']?.toString() ?? '',
          roles: rolesList.isNotEmpty ? rolesList : ['admin'],
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error decoding JWT token: $e');
      _isLoggedIn = false;
      _token = null;
      _decodedToken = null;
      _currentUser = null;
      return false;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<bool> loginAdmin({
    required String identifier,
    required String password,
    required BuildContext context,
  }) async {
    final cleanIdentifier = identifier.trim();
    final cleanPassword = password.trim();

    if (cleanIdentifier.isEmpty) {
      showToast(context, 'Please enter email address', isError: true);
      return false;
    }

    if (cleanPassword.isEmpty) {
      showToast(context, 'Please enter your password', isError: true);
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final AuthEntity auth = await useCases.login(
        cleanIdentifier,
        cleanPassword,
      );

      _token = auth.token;
      if (_token != null && _token!.isNotEmpty) {
        try {
          _decodedToken = JwtDecoder.decode(_token!);
        } catch (_) {}
      }

      _isLoggedIn = true;
      _currentUser = auth.user;
      notifyListeners();

      if (context.mounted) {
        showToast(context, auth.message ?? 'Login successful! Welcome back.');
        context.go('/dashboard');
      }

      return true;
    } catch (e) {
      if (context.mounted) {
        showToast(context, e.toString(), isError: true);
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await useCases.logout();
      _isLoggedIn = false;
      _token = null;
      _decodedToken = null;
      _currentUser = null;
      notifyListeners();

      if (context.mounted) {
        showToast(context, 'Logged out successfully');
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        showToast(context, e.toString(), isError: true);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
