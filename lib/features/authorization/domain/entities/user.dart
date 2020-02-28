import 'package:meta/meta.dart';

///
/// User entity, just to keep auth token
///
class User {

  // auth token
  // The token will expire in 24 hours
  final String token;

  User({
    @required this.token
  });

}