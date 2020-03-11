import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/features/tasks_manager/data/repositories/task_repository.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';

class TasksListBloc extends Bloc<TasksListEvent, TasksListState> {
  final TaskRepository taskRepository;

  TasksListBloc({
    @required this.taskRepository
  });

  @override
  Stream<TasksListState> transformEvents(
      Stream<TasksListEvent> events,
      Stream<TasksListState> Function(TasksListEvent event) next,
      ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  TasksListState get initialState => Uninitialized();

  @override
  Stream<TasksListState> mapEventToState(TasksListEvent event) async* {
    final currentState = state;
    int currentPage = 1;
    if (event is GetTasksList && !_hasReachedMax(currentState)) {
        if (currentState is Uninitialized || currentState is Empty) {
          print("dispatched event: $event");

//          yield Loading();
          final tasks = await taskRepository.getTasks(event.filter, event.direction, event.token, currentPage);

          yield* tasks.fold(
            (failure) async* {
              String message = mapFailureToMessage(failure);
              yield Empty(errorMessage: message);
            },
            (tasks) async* {
              yield Loaded(tasks: tasks, hasReachedMax: false);
            }
          );
        } else if (currentState is Loaded) {
          
          final tasks = await taskRepository.getTasks(event.filter, event.direction, event.token, currentPage);

          yield* tasks.fold(
              (failure) async* {
                String message = mapFailureToMessage(failure);
                if (currentState.tasks.isEmpty) {
                  yield Empty(errorMessage: message);
                } else {
                  yield currentState.copyWith(hasReachedMax: true, errorMessage: message);
                }
              },
              (tasks) async* {
                yield tasks.isEmpty
                  ? currentState.copyWith(hasReachedMax: true)
                  : Loaded(
                      tasks: currentState.tasks + tasks,
                      hasReachedMax: false,
                      errorMessage: null
                );
              }
          );
        }
    }
  }

  bool _hasReachedMax(TasksListState state) =>
      state is Loaded && state.hasReachedMax;

}