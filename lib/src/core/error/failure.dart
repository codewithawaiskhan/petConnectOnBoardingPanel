/// A base class for all failure types in the application.
/// The Presentation Layer will receive a Failure object when a use case fails.
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Represents a 401 Unauthorized failure.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// Represents a 403 Forbidden failure.
class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

/// Represents a failure from the server (e.g., 500 Internal Server Error).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents a failure due to network issues (e.g., no internet connection).
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Represents a failure from local cache (e.g., SharedPreferences or local DB).
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents a generic failure for unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
