import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class TasksRepository extends CrudRepository<Task, TasksCompanion> {
  final TasksDao tasksDao;

  const TasksRepository(
    this.tasksDao,
  );

  @override
  Future<int> create(TasksCompanion companion) =>
      tasksDao.createTask(companion);

  @override
  Future<Task?> getItemById(int id) => tasksDao.getTaskById(id);

  @override
  Future<List<Task>> getPaginatedItems({int limit = 50, int? offset}) =>
      tasksDao.getPaginatedTasks(limit, offset);

  @override
  Future<List<Task>> getItems() => tasksDao.getAllTasks();

  Future<List<TaskWithProject>> getPaginatedTasksWithProjects(
          int limit, int? offset) =>
      tasksDao.getPaginatedTasksWithProjects(limit, offset);

  Future<int> createTaskWithProject(
          TasksCompanion tasksCompanion, ProjectsCompanion projectsCompanion) =>
      tasksDao.createTaskWithProject(tasksCompanion, projectsCompanion);

  Future<TaskWithProject?> getTaskWithProjectById(int taskId) =>
      tasksDao.getTaskWithProjectById(taskId);

  Future<void> deleteTask(Task task) => tasksDao.deleteTask(task);

  @override
  Future<int> delete(Task entity) => tasksDao.deleteTask(entity);

  @override
  Future<void> update(Task entity) => tasksDao.updateTask(
        entity.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
}
