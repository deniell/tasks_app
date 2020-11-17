import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pr;
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/remote_datasource.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/tasks_list_bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/pages/add_task_page.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/app_drawer.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/tasks_list.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({
    Key key
  }) : super(key: key);

  @override
  _TasksListPageState createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {

  final log = logger.log;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  AuthService authServiceProvider;
  SortFilter filter;
  ValueNotifier<SortDirection> sortDirectionNotifier = ValueNotifier<SortDirection>(SortDirection.asc);
  // current get tasks request to fetch more tasks
  TasksListEvent gEvent;
  Widget tasksList;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    tasksList = TasksList(scrollController: _scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log.d("build Task list page");

    // prevent auto-rotate screen to landscape position
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    authServiceProvider = pr.Provider.of<AuthService>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'My Tasks',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.bars,
            color: Colors.grey[700],
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                height: 40,
                enabled: false,
                child: Text(
                  'Sort by',
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 18),
                ),
              ),
              PopupMenuItem(
                value: 1,
                height: 40,
                child: Text(
                  'Name',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                height: 40,
                child: Text(
                  'Priority',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                height: 40,
                child: Text(
                  'Date',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                ),
              )
            ],
            icon: Icon(
              FontAwesomeIcons.listUl,
              color: Colors.grey[700],
            ),
            offset: Offset(0, 100),
            padding: EdgeInsets.only(top: 5),
            onSelected: (item)
            {
              if (item == 1) {
                gEvent = GetTasksList(
                  filter: SortFilter.title,
                  direction: sortDirectionNotifier.value,
                  token: authServiceProvider.user.token
                );
                dispatchTasksList(gEvent);
              } else if (item == 2) {
                gEvent = GetTasksList(
                  filter: SortFilter.priority,
                  direction: sortDirectionNotifier.value,
                  token: authServiceProvider.user.token
                );
                dispatchTasksList(gEvent);
              } else if (item == 3) {
                gEvent = GetTasksList(
                  filter: SortFilter.dueBy,
                  direction: sortDirectionNotifier.value,
                  token: authServiceProvider.user.token
                );
                dispatchTasksList(gEvent);
              }
            },
          ),
          sortDirectionBtn()
        ],
      ),
      body: tasksList,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage()
            )
          );
        },
        tooltip: 'Add task',
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 45,
        ),
      ),
    );
  }

  ///
  /// Send event to Tasks list bloc
  ///
  void dispatchTasksList(GetTasksList gEvent) {
    BlocProvider.of<TasksListBloc>(context).add(gEvent);
  }

  ///
  /// Task list sort direction button
  ///
  Widget sortDirectionBtn()
  {
    return ValueListenableBuilder(
      builder: (BuildContext context, SortDirection value, Widget child)
      {
        switch(value) {
          case SortDirection.asc:
            return IconButton(
              icon: Icon(
                FontAwesomeIcons.sortAmountUp,
                color: Colors.grey[700],
              ),
              onPressed: () {
                sortDirectionNotifier.value = SortDirection.desc;
                gEvent = GetTasksList(
                    filter: SortFilter.dueBy,
                    direction: sortDirectionNotifier.value,
                    token: authServiceProvider.user.token
                );
                dispatchTasksList(gEvent);
              },
            );
          case SortDirection.desc:
            return IconButton(
              icon: Icon(
                FontAwesomeIcons.sortAmountDown,
                color: Colors.grey[700],
              ),
              onPressed: () {
                sortDirectionNotifier.value = SortDirection.asc;
              },
            );
        }
        return null; //unreachable
      },
      valueListenable: sortDirectionNotifier,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      dispatchTasksList(gEvent);
    }
  }
}
