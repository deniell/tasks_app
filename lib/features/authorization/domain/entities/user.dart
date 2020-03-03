import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

///
/// User entity, just to keep auth token
///
@HiveType(typeId: 0)
class User {

  // auth token
  // The token will expire in 24 hours
  @HiveField(0)
  final String token;

  User({
    @required this.token
  });

}