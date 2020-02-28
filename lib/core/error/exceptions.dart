// throw for 500
class ServerException implements Exception {
  final String message = "Server Failure.";
}

// throw for 422
class ValidationException implements Exception {
  final String message = "Validation failed.";
  final String cause;

  ValidationException({this.cause});
}

// throw for 403
class UnauthorizedException implements Exception {
  final String message = "This action is unauthorized.";
}

// throw for default
class UnexpectedException implements Exception {
  final String message = "Something went wrong.";
}