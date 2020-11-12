import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/failures.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/local_datasource.dart';

abstract class LocalRepository {

  // save user to cache for reusing token
  Future<void> saveUser2Cache(User user);

  // get saved user from cache
  Future<Either<Failure, User>> getUserFromCache();

  // remove user form cache
  Future<void> removeUserFromCache();
}

class LocalRepositoryImpl implements LocalRepository {

  final log = logger.log;
  final LocalDataSource localDataSource;

  LocalRepositoryImpl({
    @required this.localDataSource
  });

  @override
  Future<Either<Failure, User>> getUserFromCache() async {
    try {
      User user = await localDataSource.getUserFromCache();
      log.d("saved user: $user");
      return Right(user);
    } catch (e) {
      log.e(e);
      return Left(CacheFailure());
    }
  }

  @override
  Future<void> removeUserFromCache() async {
    try {
      await localDataSource.removeUserFromCache();
    } catch (e) {
      log.e(e);
    }
  }

  @override
  Future<void> saveUser2Cache(User user) async {
    try {
      await localDataSource.saveUser2Cache(user);
    } catch (e) {
      log.e(e);
    }
  }

}