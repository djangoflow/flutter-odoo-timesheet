import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks, Projects])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(AppDatabase db) : super(db);

  // Task CRUD operations
  Future<int> createTask(TasksCompanion tasksCompanion) =>
      into(tasks).insert(tasksCompanion);

  Future<int> createTaskWithProject(
          TasksCompanion tasksCompanion, ProjectsCompanion projectsCompanion) =>
      transaction(
        () async {
          final projectId = await into(projects).insert(projectsCompanion);
          final taskId = await into(tasks).insert(
            tasksCompanion.copyWith(
              projectId: Value(projectId),
            ),
          );

          return taskId;
        },
      );

  Future<List<TaskWithProject>> getPaginatedTasksWithProjects(
          int limit, int? offset) =>
      (select(tasks)
            // should be ordered by createdAt and onlineIds
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
            ])
            ..limit(limit, offset: offset))
          .join([
            leftOuterJoin(projects, projects.id.equalsExp(tasks.projectId)),
          ])
          .get()
          .then(
            (rows) => rows
                .map(
                  (row) => TaskWithProject(
                    task: row.readTable(tasks),
                    project: row.readTable(projects),
                  ),
                )
                .toList(),
          );

  Future<Task?> getTaskById(int taskId) =>
      (select(tasks)..where((t) => t.id.equals(taskId))).getSingleOrNull();

  Future<TaskWithProject?> getTaskWithProjectById(int taskId) => (select(tasks)
        ..where((t) => t.id.equals(taskId))
        ..limit(1))
      .join([
        leftOuterJoin(projects, projects.id.equalsExp(tasks.projectId)),
      ])
      .getSingleOrNull()
      .then(
        (row) => row != null
            ? TaskWithProject(
                task: row.readTable(tasks),
                project: row.readTable(projects),
              )
            : null,
      );

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Future<List<Task>> getPaginatedTasks(int limit, int? offset) => (select(tasks)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(limit, offset: offset))
      .get();

  Future<void> updateTask(Task task) => update(tasks).replace(task);

  Future<int> deleteTask(Task task) => delete(tasks).delete(task);
}
