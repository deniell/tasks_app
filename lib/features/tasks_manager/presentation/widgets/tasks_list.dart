import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/remote_datasource.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/bottom_loader.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/task_widget.dart';
import 'package:provider/provider.dart' as pr;

class TasksList extends StatelessWidget {

  final log = logger.log;
  final scrollController;

  TasksList({
    @required this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(10),
        child: Center(
          child: BlocConsumer<TasksListBloc, TasksListState>(
            listener: (context, state) {
              log.d("listened state is: $state");
               if (state is Empty && state.errorMessage != null) {
                log.d(state.errorMessage);
                Flushbar(
                  message: state.errorMessage,
                  icon: Icon(
                    Icons.info_outline,
                    size: 28.0,
                    color: Colors.blue[300],
                  ),
                  duration: Duration(seconds: 5),
                  leftBarIndicatorColor: Colors.blue[300],
                )..show(context);
              }
            },
            builder: (context, state) {
              log.d("build state is: $state");
              if (state is Uninitialized) {
                TasksListEvent event = GetTasksList(
                    filter: SortFilter.dueBy,
                    direction: SortDirection.asc,
                    token: pr.Provider.of<AuthService>(context).user.token
                );
                BlocProvider.of<TasksListBloc>(context).add(event);
                return LoadingWidget();
              } else if (state is Empty) {
                return noTasks();
              } else if (state is Loading) {
                return LoadingWidget();
              } else if (state is Loaded) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if (state.tasks.length == 0 && index == 0) {
                      return noTasks();
                    } else {
                      return index >= state.tasks.length
                        ? BottomLoader()
                        : TaskWidget(task: state.tasks[index]);
                    }
                  },
                  itemCount: state.hasReachedMax
                    ? state.tasks.length
                    : state.tasks.length + 1,
                  controller: scrollController,
                );
              } else {
                return Text('Something goes wrong');
              }
            }
          ),
        ),
      // ),
    );
  }

  ///
  /// No tasks widget
  ///
  Widget noTasks() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Text(
        "You have no tasks.",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}
