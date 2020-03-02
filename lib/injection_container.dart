import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tasks_app/core/network/network_info.dart';
import 'package:tasks_app/features/authorization/data/datasources/auth_datasource.dart';
import 'package:tasks_app/features/authorization/data/repositories/auth_repository.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Core
  di.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di()));

  // External
  di.registerLazySingleton(() => http.Client());
  di.registerLazySingleton(() => DataConnectionChecker());

  // Data sources
  di.registerLazySingleton<AuthDataSource>(
      () => AuthDataSourceImpl(client: di()),
  );

  // Repository
  di.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
            authDataSource: di(),
            networkInfo: di(),
          )
  );

  di.registerFactory(() => AuthService(authRepository: di()));
}

