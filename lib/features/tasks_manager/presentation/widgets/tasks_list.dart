import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/bottom_loader.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/task_widget.dart';
import 'package:provider/provider.dart';

class TasksList extends StatelessWidget {

  final log = logger.log;
  final scrollController;

  TasksList({
    @required this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  token: Provider.of<AuthService>(context).user.token
              );
              BlocProvider.of<TasksListBloc>(context).add(event);
              return LoadingWidget();
            } else if (state is Empty) {
              return noTasks();
            } else if (state is Loading) {
              return LoadingWidget();
            } else if (state is Loaded) {
              if (state.tasks.length == 0) {
                return noTasks();
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    // just for sake of UI set duration for refresh indicator before api call
                    await Future.delayed(Duration(seconds: 1));
                    String token = Provider.of<AuthService>(context, listen: false).user.token;
                    BlocProvider.of<TasksListBloc>(context).add(RefreshTasksList(token: token));
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      log.d("index: $index, state.tasks.length: ${state.tasks.length}, state.hasReachedMax: ${state.hasReachedMax}");
                      return index >= state.tasks.length
                        ? BottomLoader()
                        : BlocProvider.value(
                        value: BlocProvider.of<TasksListBloc>(context, listen: true),
                        child: TaskWidget(task: state.tasks[index])
                      );
                    },
                    itemCount: state.hasReachedMax
                      ? state.tasks.length
                      : state.tasks.length + 1,
                  )
                );
              }
            } else {
              return Text('Something goes wrong');
            }
          }
        ),
      ),
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
