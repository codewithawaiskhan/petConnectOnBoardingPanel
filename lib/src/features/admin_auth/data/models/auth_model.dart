import '../../domain/entities/auth_entity.dart';

class AdminUserModel extends AdminUserEntity {
  const AdminUserModel({
    required super.id,
    required super.fullName,
    required super.username,
    required super.email,
    super.phone,
    required super.roles,
    super.status,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    final rolesList = <String>[];
    if (json['roles'] is List) {
      for (final r in json['roles']) {
        rolesList.add(r.toString());
      }
    }

    return AdminUserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      roles: rolesList,
      status: json['status']?.toString(),
    );
  }

  factory AdminUserModel.fromEntity(AdminUserEntity entity) {
    return AdminUserModel(
      id: entity.id,
      fullName: entity.fullName,
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      roles: entity.roles,
      status: entity.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'roles': roles,
      'status': status,
    };
  }
}

class AuthModel extends AuthEntity {
  const AuthModel({required super.token, super.user, super.message});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    String token = '';
    String? message;
    AdminUserModel? userModel;

    String extractToken(Map<String, dynamic> map) {
      if (map['token'] != null && map['token'].toString().trim().isNotEmpty) {
        return map['token'].toString().trim();
      }
      if (map['accessToken'] != null &&
          map['accessToken'].toString().trim().isNotEmpty) {
        return map['accessToken'].toString().trim();
      }
      if (map['jwt'] != null && map['jwt'].toString().trim().isNotEmpty) {
        return map['jwt'].toString().trim();
      }
      return '';
    }

    Map<String, dynamic>? extractUserMap(Map<String, dynamic> map) {
      if (map['doc'] is Map<String, dynamic>) {
        return map['doc'] as Map<String, dynamic>;
      }
      if (map['user'] is Map<String, dynamic>) {
        return map['user'] as Map<String, dynamic>;
      }
      if (map['admin'] is Map<String, dynamic>) {
        return map['admin'] as Map<String, dynamic>;
      }
      return null;
    }

    message = json['message']?.toString();

    Map<String, dynamic>? dataWrapper;
    if (json['data'] is Map<String, dynamic>) {
      dataWrapper = json['data'] as Map<String, dynamic>;
      message ??= dataWrapper['message']?.toString();
    }

    final userMap = extractUserMap(dataWrapper ?? json) ?? extractUserMap(json);
    if (userMap != null) {
      userModel = AdminUserModel.fromJson(userMap);
      token = extractToken(userMap);
    } else if (dataWrapper != null) {
      userModel = AdminUserModel.fromJson(dataWrapper);
    }

    if (token.isEmpty && dataWrapper != null) {
      token = extractToken(dataWrapper);
    }
    if (token.isEmpty) {
      token = extractToken(json);
    }

    return AuthModel(token: token, user: userModel, message: message);
  }

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      token: entity.token,
      user: entity.user != null
          ? AdminUserModel.fromEntity(entity.user!)
          : null,
      message: entity.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user':
          (user is AdminUserModel
                  ? user as AdminUserModel
                  : (user != null ? AdminUserModel.fromEntity(user!) : null))
              ?.toJson(),
      'message': message,
    };
  }
}
