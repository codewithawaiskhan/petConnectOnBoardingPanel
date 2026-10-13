class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() {
    return "AppException: $message (Status Code: $statusCode)";
  }
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, [super.statusCode = 401]);
}

class ForbiddenException extends AppException {
  ForbiddenException(super.message, [super.statusCode = 403]);
}

class ServerException extends AppException {
  ServerException(super.message, [super.statusCode]);
}

class BadRequestException extends AppException {
  BadRequestException(super.message, [super.statusCode]);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class UnknownException extends AppException {
  UnknownException(super.message);
}

class DataParsingException extends AppException {
  DataParsingException(super.message);
}
