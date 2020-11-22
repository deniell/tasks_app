import 'package:date_time_picker/date_time_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/tasks_manager/data/repositories/task_repository.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/pages/edit_task_page.dart';
import 'package:tasks_app/injection_container.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  TaskDetailsPage({
  @required this.task,
  Key key
  }) : super(key: key);

@override
_TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {

  final log = logger.log;
  // widget state
  bool loading = false;
  final TaskRepository taskRepository = di();

  @override
  Widget build(BuildContext context) {

    String formatted = '';
    try {
      final DateTime date = DateTime.fromMicrosecondsSinceEpoch((widget.task.dueBy*1000000));
      log.d("task ${widget.task.title} date: $date");
      final DateFormat formatter = DateFormat('EEEE dd MMM, y');
      formatted = formatter.format(date);
    } catch (e) {
      log.e(e);
    }

    // prevent auto-rotate screen to landscape position
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final Size screenSize = MediaQuery.of(context).size;

    return loading ? LoadingWidget() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'Task Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.grey[700],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.grey[700],
            onPressed: () {
              log.d("Go to edit task page");
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<TasksListBloc>(context, listen: true),
                    child: EditTaskPage(task: widget.task)
                  )
                ),
                  ModalRoute.withName("/")
              );
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            SizedBox(
              width: screenSize.width,
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 10),
                  color: Colors.grey[200],
                  width: screenSize.width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.task.title,
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenSize.width,
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            formatted,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15, bottom: 0),
                  child: Text(
                    "Priority",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.grey[800],
                        size: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, top: 15),
                      child: Text(
                        "${widget.task.priority.value}",
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
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: Colors.grey[600],
                thickness: 0.5,
                height: 0,
              ),
            ),
            if (widget.task.description != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                    child: Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                    color: Colors.grey[100],
                    width: screenSize.width,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.task.description,
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(
                  color: Colors.grey[600],
                  thickness: 0.5,
                  height: 0,
                ),
              ),
            ],
          ],
        ),
      ),
      bottomSheet: FlatButton(
        child: Text(
          "Delete task",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19
          ),
        ),
        color: Colors.blueGrey,
        onPressed: ()
        {
          _deleteTask();
        },
        minWidth: screenSize.width,
        height: 50,
      ),
    );
  }

  ///
  /// Delete task
  ///
  Future<void> _deleteTask() async
  {
    // get user token
    String token = Provider.of<AuthService>(context, listen: false).user.token;

    setState(() => loading = true);

    // sent API request
    final result = await taskRepository.deleteTask(widget.task.id, token);

    setState(() => loading = false);

    // evaluate result of adding the task
    result.fold(
      (failure){
        log.e("failure");
        String message = mapFailureToMessage(failure);
        Flushbar(
          message: message,
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red,
          ),
          duration: Duration(seconds: 5),
          leftBarIndicatorColor: Colors.red,
        )..show(context);
        return;
      },
      (tasks) {
        log.d("success!");
        /// update tasks list
        // create bloc event
        BlocProvider.of<TasksListBloc>(context).add(RefreshTasksList(token: token));
        Navigator.of(context).pop();
      }
    );
  }
}
