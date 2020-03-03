import 'package:hive/hive.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';

///
/// Representation of local storage interface
///
abstract class LocalDataSource {

  // save user to cache for reusing token
  Future<void> saveUser2Cache(User user);

  // get saved user from cache
  Future<User> getUserFromCache();

  // remove user form cache
  Future<void> removeUserFromCache();
}

class LocalDataSourceImpl implements LocalDataSource {

  LocalDataSourceImpl();

  @override
  Future<User> getUserFromCache() async {
    return await Hive.box('user_entity').get('user');
  }

  @override
  Future<void> saveUser2Cache(User user) async {
    await Hive.box('user_entity').put('user', user);
  }

  @override
  Future<void> removeUserFromCache() async {
    await Hive.box('user_entity').delete('user');
  }
}