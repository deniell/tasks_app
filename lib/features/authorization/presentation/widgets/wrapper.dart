import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/authorization/presentation/widgets/authenticate.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/tasks_manager/presentation/pages/tasks_list.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authServiceProvider = Provider.of<AuthService>(context);

    print(authServiceProvider.user);

    // return either the TasksList or Authenticate widget
    if (authServiceProvider.user == null) {
      return LoadingWidget();
    } else if (authServiceProvider.user.token != null) {
      return TasksList();
    } else {
      return Authenticate();
    }
  }
}