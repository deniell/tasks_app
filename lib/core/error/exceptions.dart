// throw for 500
class ServerException implements Exception {}

// throw for 422
class ValidationException implements Exception {
  final String cause;

  ValidationException({this.cause});
}

// throw for 403
class UnauthorizedException implements Exception {}

// throw for default
class UnexpectedException implements Exception {}