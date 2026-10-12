import 'app_exceptions.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error.runtimeType.toString() == 'SocketException' ||
        error.toString().contains('SocketException') ||
        error.toString().contains('ClientException')) {
      return const NetworkFailure('No Internet connection. Please check your network.');
    }

    if (error is AppException) {
      final String errorMessage = error.message.trim().isNotEmpty
          ? error.message
          : 'An unexpected error occurred. Please try again.';

      // Handle 401
      if (error is UnauthorizedException) {
        return AuthenticationFailure(errorMessage);
      }
      // Handle 403
      if (error is ForbiddenException) {
        return ForbiddenFailure(errorMessage);
      }
      if (error is ServerException) {
        return ServerFailure(errorMessage);
      }
      if (error is BadRequestException) {
        return ServerFailure(errorMessage);
      }
      if (error is NetworkException) {
        return NetworkFailure(errorMessage);
      }
      if (error is CacheException) {
        return CacheFailure(errorMessage);
      }
      if (error is DataParsingException) {
        return ServerFailure(errorMessage);
      }
      if (error is UnknownException) {
        return UnknownFailure(errorMessage);
      }
      // Default case
      return UnknownFailure(errorMessage);
    }
    return const UnknownFailure('An unexpected error occurred. Please try again.');
  }
}
