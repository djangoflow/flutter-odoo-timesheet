import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/task.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(AppDatabase db) : super(db);

  // Task CRUD operations
  Future<int> createTask(TasksCompanion tasksCompanion) =>
      into(tasks).insert(tasksCompanion);

  Future<Task?> getTaskById(int taskId) =>
      (select(tasks)..where((t) => t.id.equals(taskId))).getSingleOrNull();

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Future<List<Task>> getTasks(int limit, int? offset) => (select(tasks)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(limit, offset: offset))
      .get();

  Future<void> updateTask(Task task) => update(tasks).replace(task);

  Future<void> deleteTask(Task task) => delete(tasks).delete(task);
}
