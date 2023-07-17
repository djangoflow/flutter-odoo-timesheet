import 'package:drift/drift.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

part 'external_projects_dao.g.dart';

@DriftAccessor(tables: [ExternalProjects])
class ExternalProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ExternalProjectsDaoMixin {
  ExternalProjectsDao(AppDatabase db) : super(db);

  Future<int> createExternalProject(
          ExternalProjectsCompanion externalProjectsCompanion) =>
      into(externalProjects).insert(externalProjectsCompanion);

  Future<ExternalProject?> getExternalProjectById(int externalProjectId) =>
      (select(externalProjects)..where((p) => p.id.equals(externalProjectId)))
          .getSingleOrNull();

  Future<List<ExternalProject>> getAllExternalProjects() =>
      select(externalProjects).get();

  Future<void> updateExternalProject(ExternalProject externalProject) =>
      update(externalProjects).replace(externalProject);

  Future<void> deleteExternalProject(ExternalProject externalProject) =>
      delete(externalProjects).delete(externalProject);
}
