import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/tasks_list_bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/pages/task_details_page.dart';

class TaskWidget extends StatelessWidget {
  final log = logger.log;
  final Task task;

  TaskWidget({
    Key key,
    @required this.task
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String formatted = '';
    try {
      final DateTime date = DateTime.fromMicrosecondsSinceEpoch((task.dueBy*1000000));
      log.d("task ${task.title} date: $date");
      final DateFormat formatter = DateFormat('MM/dd/yy');
      formatted = formatter.format(date);
    } catch (e) {
      log.e(e);
    }

    return Card(
      elevation: 2.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 280,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      task.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 2, bottom: 10),
                    child: Text(
                      "Due to ",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      formatted,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.grey[800],
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "${task.priority.value}",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[500],
              ),
            ),
            onTap: () {
              log.d("Open task info page");
              log.d("test context: ${BlocProvider.of<TasksListBloc>(context).currentPage}");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<TasksListBloc>(context, listen: true),
                    child: TaskDetailsPage(task: task)
                  )
                )
              );
            },
          ),
        ],
      )
    );
  }
}