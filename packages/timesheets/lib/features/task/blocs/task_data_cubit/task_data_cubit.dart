import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

export 'task_retrieve_filter.dart';

typedef TasksDataState = Data<Task?, TaskRetrieveFilter>;

class TaskDataCubit extends DataCubit<Task?, TaskRetrieveFilter>
    with CubitMaybeEmit {
  final TasksRepository tasksRepository;

  TaskDataCubit(this.tasksRepository)
      : super(
          ListBlocUtil.dataLoader<Task?, TaskRetrieveFilter>(
            loader: ([filter]) {
              if (filter == null) {
                throw ArgumentError.notNull('taskId');
              }
              return tasksRepository.getTaskById(filter.taskId);
            },
          ),
        );

  Future<void> updateTask(Task task) async {
    await tasksRepository.updateTask(task);
    emit(Data(data: task, filter: state.filter));
  }

  Future<void> deleteTask(Task task) async {
    await tasksRepository.deleteTask(task);
    emit(const Data.empty());
  }

  Future<Task?> resetTask(Task task) async {
    await tasksRepository.resetTask(task);
    await load();
    return await tasksRepository.getTaskById(task.id);
  }

  Future<void> refreshTask() async {
    await load();
  }
}