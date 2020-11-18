import 'package:dartz/dartz.dart' as dz;
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tasks_app/core/error/failures.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/features/tasks_manager/data/repositories/task_repository.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';
import 'package:tasks_app/features/tasks_manager/presentation/bloc/bloc.dart';

class TasksListBloc extends Bloc<TasksListEvent, TasksListState> {

  final log = logger.log;
  final TaskRepository taskRepository;

  TasksListBloc({
    @required this.taskRepository
  }) : super(Uninitialized());

  @override
  Stream<Transition<TasksListEvent, TasksListState>> transformEvents(
      Stream<TasksListEvent> events,
      transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      transitionFn,
    );
  }

  @override
  Stream<TasksListState> mapEventToState(TasksListEvent event) async* {
    log.d("Task list event: $event");
    final currentState = state;
    int currentPage = 1;
    if (event is GetTasksList && !_hasReachedMax(currentState)) {
      if (currentState is Uninitialized || currentState is Empty) {
        log.d("dispatched event: $event");

        // yield Loading();
        final tasks = await taskRepository.getTasks(event.filter, event.direction, event.token, currentPage);

        log.d("tasks is: $tasks");

        yield* _evaluateTasksState(tasks);
        log.d("state become: $state");
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

  Stream<TasksListState> _evaluateTasksState(dz.Either<Failure, List<Task>> tasks) async* {
    yield tasks.fold(
      (failure){
        log.e("failure");
        String message = mapFailureToMessage(failure);
        return Empty(errorMessage: message);
      },
      (tasks) {
        log.d("success!");
        return Loaded(tasks: tasks, hasReachedMax: false);
      }
    );
  }

  bool _hasReachedMax(TasksListState state) =>
      state is Loaded && state.hasReachedMax;

}