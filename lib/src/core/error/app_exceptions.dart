/// Base class for all custom exceptions in the app.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() {
    return "AppException: $message (Status Code: $statusCode)";
  }
}

/// Thrown when the server returns a 401 Unauthorized error.
class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, [super.statusCode = 401]);
}

/// Thrown when the server returns a 403 Forbidden error.
class ForbiddenException extends AppException {
  ForbiddenException(super.message, [super.statusCode = 403]);
}

/// Thrown when the server returns a 5xx error.
class ServerException extends AppException {
  ServerException(super.message, [super.statusCode]);
}

/// Thrown when the server returns a 4xx error, indicating a client error.
class BadRequestException extends AppException {
  BadRequestException(super.message, [super.statusCode]);
}

/// Thrown when there is no internet connection.
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Thrown when an error occurs while accessing local cache.
class CacheException extends AppException {
  CacheException(super.message);
}

/// Thrown for any other unexpected error.
class UnknownException extends AppException {
  UnknownException(super.message);
}

/// Thrown when JSON model parsing fails.
class DataParsingException extends AppException {
  DataParsingException(super.message);
}
