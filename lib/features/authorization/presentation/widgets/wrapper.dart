import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' as pr;
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/authorization/presentation/widgets/authenticate.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/pages/tasks_list_page.dart';
import 'package:tasks_app/injection_container.dart';

class Wrapper extends StatelessWidget {

  final log = logger.log;

  @override
  Widget build(BuildContext context) {

    final authServiceProvider = pr.Provider.of<AuthService>(context);

    log.d(authServiceProvider.user?.token);

    // return either the TasksList or Authenticate widget
    if (authServiceProvider.user == null) {
      return LoadingWidget();
    } else if (authServiceProvider.user.token != null) {
      return BlocProvider(
        create: (context) => di<TasksListBloc>(),
        child: TasksListPage()
      );
    } else {
      return Authenticate();
    }
  }
}