import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:tasks_app/core/network/network_info.dart';
import 'package:tasks_app/features/authorization/data/datasources/auth_datasource.dart';
import 'package:tasks_app/features/authorization/data/repositories/auth_repository.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/local_datasource.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/remote_datasource.dart';
import 'package:tasks_app/features/tasks_manager/data/repositories/local_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tasks_app/features/tasks_manager/data/repositories/task_repository.dart';

import 'features/tasks_manager/presentation/bloc/tasks_list_bloc.dart';

final di = GetIt.instance;

Future<void> init() async {

  // initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(UserAdapter());
  final userBox = await Hive.openBox('user_entity');

  // Services
  di.registerFactory(
    () => AuthService(
      authRepository: di(),
      localeRepository: di(),
    )
  );

  // Bloc
  di.registerFactory(
    () => TasksListBloc(
      taskRepository: di()
    ),
  );

  // Data sources
  di.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(client: di()),
  );
  di.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(),
  );
  di.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(client: di())
  );

  // Repository
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: di(),
      networkInfo: di(),
    )
  );
  di.registerLazySingleton<LocalRepository>(
    () => LocalRepositoryImpl(
      localDataSource: di(),
    )
  );
  di.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteDataSource: di(),
      localDataSource: di(),
      networkInfo: di()
    )
  );

  // External
  di.registerLazySingleton(() => http.Client());
  di.registerLazySingleton(() => DataConnectionChecker());
  di.registerLazySingleton(() => Connectivity());

  // Core
  di.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: di(),
      connectivity: di()
    )
  );
}

