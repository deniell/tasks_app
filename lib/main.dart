import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/authorization/presentation/widgets/wrapper.dart';
import 'package:tasks_app/injection_container.dart' as di;

void main() async {
  // ensure that core.widgets initialization finished
  WidgetsFlutterBinding.ensureInitialized();
  // initialize dependency injection
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final GetIt di = GetIt.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (context) => di<AuthService>(),
      child: MaterialApp(
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  // TODO: close Hive: Hive.close();
}
