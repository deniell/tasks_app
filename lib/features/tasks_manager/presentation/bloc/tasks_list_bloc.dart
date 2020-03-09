import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/features/tasks_manager/data/repositories/task_repository.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';

class TasksListBloc extends Bloc<TasksListEvent, TasksListState> {
  final TaskRepository taskRepository;

  TasksListBloc({
    @required this.taskRepository
  });

  @override
  TasksListState get initialState => Empty();

  @override
  Stream<TasksListState> mapEventToState(TasksListEvent event) async* {
    if (event is GetTasksList) {
      print("dispatched event: $event");

      yield Loading();
      final tasks = await taskRepository.getTasks(event.filter, event.direction, event.token);

      yield* tasks.fold(
        (failure) async* {
          String message = mapFailureToMessage(failure);
          yield Empty(message: message);
        },
        (tasks) async* {
          yield Loaded(tasks: tasks);
        }
      );

      yield Loading();

    }
  }

}