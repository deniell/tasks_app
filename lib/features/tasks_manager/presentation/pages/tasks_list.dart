import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/remote_datasource.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/app_drawer.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/bottom_loader.dart';
import 'package:tasks_app/features/tasks_manager/presentation/widgets/task_widget.dart';
import 'package:tasks_app/injection_container.dart';

class TasksList extends StatefulWidget {
  const TasksList({
    Key key
  }) : super(key: key);

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  AuthService authServiceProvider;
  SortFilter filter;
  ValueNotifier<SortDirection> sortDirectionNotifier = ValueNotifier<SortDirection>(SortDirection.asc);
  // current get tasks request to fetch more tasks
  TasksListEvent gEvent;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    authServiceProvider = Provider.of<AuthService>(context);

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
                  style: TextStyle(
                      color: Colors.black, fontSize: 18),
                ),
              ),
              PopupMenuItem(
                value: 2,
                height: 40,
                child: Text(
                  'Priority',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18),
                ),
              ),
              PopupMenuItem(
                value: 3,
                height: 40,
                child: Text(
                  'Date',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18),
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
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        tooltip: 'Add task',
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 45,
        ),
      ),
    );
  }

  BlocProvider<TasksListBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => di<TasksListBloc>(),
      child: Container(
//        padding: const EdgeInsets.all(10),
        child: Center(
          child:
            BlocBuilder<TasksListBloc, TasksListState>(
              builder: (context, state) {
                print("state is: $state");
                if (state is Uninitialized) {
                  return LoadingWidget();
                } else if (state is Empty) {
                  if (state.errorMessage != null) {
                    print(state.errorMessage);
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
                  return Text('No tasks');
                } else if (state is Loading) {
                  return LoadingWidget();
                } else if (state is Loaded) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.tasks.length
                          ? BottomLoader()
                          : TaskWidget(task: state.tasks[index]);
                    },
                    itemCount: state.hasReachedMax
                        ? state.tasks.length
                        : state.tasks.length + 1,
                    controller: _scrollController,
                  );
                } else {
                  return Text('Something goes wrong');
                }
              }
            ),
        ),
      ),
    );
  }

  void dispatchTasksList(GetTasksList gEvent) {
    di<TasksListBloc>().add(gEvent);
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
