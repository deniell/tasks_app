import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/core/constants.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/tasks_manager/data/models/task_model.dart';
import 'package:tasks_app/features/tasks_manager/data/repositories/task_repository.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/tasks_list_event.dart';
import 'package:tasks_app/features/tasks_manager/presentation/pages/task_details_page.dart';
import 'package:tasks_app/injection_container.dart';

class EditTaskPage extends StatefulWidget {

  final Task task;
  
  EditTaskPage({
    @required this.task,
    Key key
  }) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {

  final log = logger.log;
  final TaskRepository taskRepository = di();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  // widget state
  bool loading = false;
  // task priority
  Priority _priority;
  // due to this time task should be done
  int _dueBy;
  // text field state
  String _title = '';
  String _description = '';
  Task _updatedTask;

  @override
  void initState() {
    _title = widget.task.title;
    _description = widget.task.description;
    _priority = widget.task.priority;
    if (widget.task.dueBy != null) {
      _dueBy = widget.task.dueBy*1000000;
    }
    _updatedTask = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // prevent auto-rotate screen to landscape position
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final Size screenSize = MediaQuery.of(context).size;

    return loading ? LoadingWidget() :  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'Edit Task',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.grey[700],
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<TasksListBloc>(context, listen: true),
                  child: TaskDetailsPage(task: _updatedTask)
                )
              ),
                ModalRoute.withName("/")
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  child: Text(
                    "Title",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  focusNode: _titleFocus,
                  decoration: textInputDecoration.copyWith(hintText: ''),
                  keyboardType: TextInputType.text,
                  validator: (val) => val.isEmpty ? 'Enter a title' : null,
                  maxLines: 5,
                  minLines: 3,
                  maxLength: 255,
                  onChanged: (val) {
                    _title = val;
                  },
                  initialValue: _title != null ? _title : "",
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _titleFocus, _descriptionFocus);
                  }
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: Colors.grey[600],
                thickness: 0.5,
                height: 0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 15),
                  child: Text(
                    "Priority",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomRadioButton(
                defaultSelected: _priority,
                elevation: 0,
                enableButtonWrap: true,
                unSelectedColor: Theme.of(context).canvasColor,
                padding: 5,
                buttonLables: [
                  'High',
                  'Medium',
                  'Low',
                ],
                buttonValues: [
                  Priority.High,
                  Priority.Normal,
                  Priority.Low,
                ],
                buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)
                ),
                radioButtonValue: (value) {
                  log.d("new priority is: $value");
                  _priority = value;
                },
                selectedColor: Theme.of(context).accentColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: Colors.grey[600],
                thickness: 0.5,
                height: 0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 15),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                focusNode: _descriptionFocus,
                decoration: textInputDecoration.copyWith(hintText: ''),
                keyboardType: TextInputType.text,
                maxLines: 5,
                minLines: 3,
                onChanged: (val) {
                  _description = val;
                },
                initialValue: _description != null ? _description : "",
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (term) {
                  _descriptionFocus.unfocus();
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: Colors.grey[600],
                thickness: 0.5,
                height: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: DateTimePicker(
                initialValue: _dueBy != null ? DateTime.fromMicrosecondsSinceEpoch(_dueBy).toString() : '',
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                firstDate: DateTime.now(),
                lastDate: DateTime(2200),

                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Time",
                onChanged: (val)
                {
                  log.d("New event time is: $val");
                  _dueBy = DateTime.parse(val).microsecondsSinceEpoch;
                  log.d("New event time in milliseconds since epoch: $_dueBy");
                }
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      bottomSheet: FlatButton(
        child: Text(
          "Update task",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19
          ),
        ),
        color: Colors.blueAccent,
        onPressed: ()
        {
          _updateTask();
        },
        minWidth: screenSize.width,
        height: 50,
      ),
    );
  }

  ///
  /// Change fields focus nod
  ///
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  ///
  /// Edit task
  ///
  Future<void> _updateTask() async
  {
    if(_formKey.currentState.validate()) {

      if (_priority == null) {
        Flushbar(
          message: 'Please choose a priority',
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red,
          ),
          duration: Duration(seconds: 5),
          leftBarIndicatorColor: Colors.red,
        )..show(context);

        return;
      }

      // create task model
      TaskModel taskModel = TaskModel(
        id: widget.task.id,
        title: _title,
        dueBy: _dueBy != null ? (_dueBy~/1000000).toInt() : null,
        priority: _priority,
        description: _description
      );

      Task tempTask = taskModel;

      log.d("update task with data: ${taskModel.toString()}");

      // get user token
      String token = Provider.of<AuthService>(context, listen: false).user.token;

      setState(() => loading = true);

      // sent API request
      final task = await taskRepository.updateTask(taskModel, token);

      setState(() => loading = false);

      // evaluate result of adding the task
      task.fold(
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
          (task) {
            log.d("success!");
            Flushbar(
              message: 'Task successfully updated!',
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              duration: Duration(seconds: 5),
              leftBarIndicatorColor: Colors.blue[300],
            )..show(context);
            _updatedTask = tempTask;
            // update tasks list
            BlocProvider.of<TasksListBloc>(context).add(RefreshTasksList(token: token));
          }
      );
    }
  }
}