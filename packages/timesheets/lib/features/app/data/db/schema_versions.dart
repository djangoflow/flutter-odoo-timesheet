import 'package:drift/internal/versioned_schema.dart' as i0;
import 'package:drift/drift.dart' as i1;
import 'package:drift/drift.dart'; // ignore_for_file: type=lint,unused_import

// GENERATED BY drift_dev, DO NOT MODIFY.
final class _S2 extends i0.VersionedSchema {
  _S2({required super.database}) : super(version: 2);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    projects,
    tasks,
    backends,
    taskBackends,
    timesheets,
  ];
  late final Shape0 projects = Shape0(
      source: i0.VersionedTable(
        entityName: 'projects',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 tasks = Shape1(
      source: i0.VersionedTable(
        entityName: 'tasks',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_5,
          _column_1,
          _column_6,
          _column_7,
          _column_8,
          _column_9,
          _column_10,
          _column_11,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape2 backends = Shape2(
      source: i0.VersionedTable(
        entityName: 'backends',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_12,
          _column_6,
          _column_13,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape3 taskBackends = Shape3(
      source: i0.VersionedTable(
        entityName: 'task_backends',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_14,
          _column_15,
          _column_16,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape4 timesheets = Shape4(
      source: i0.VersionedTable(
        entityName: 'timesheets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_17,
          _column_18,
          _column_19,
          _column_14,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape0 extends i0.VersionedTable {
  Shape0({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get onlineId =>
      columnsByName['online_id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get updatedAt =>
      columnsByName['updated_at']! as i1.GeneratedColumn<DateTime>;
}

i1.GeneratedColumn<int> _column_0(String aliasedName) =>
    i1.GeneratedColumn<int>('id', aliasedName, false,
        hasAutoIncrement: true,
        type: i1.DriftSqlType.int,
        defaultConstraints:
            i1.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
i1.GeneratedColumn<int> _column_1(String aliasedName) =>
    i1.GeneratedColumn<int>('online_id', aliasedName, true,
        type: i1.DriftSqlType.int);
i1.GeneratedColumn<String> _column_2(String aliasedName) =>
    i1.GeneratedColumn<String>('name', aliasedName, true,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<DateTime> _column_3(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('created_at', aliasedName, false,
        type: i1.DriftSqlType.dateTime, defaultValue: currentDateAndTime);
i1.GeneratedColumn<DateTime> _column_4(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('updated_at', aliasedName, false,
        type: i1.DriftSqlType.dateTime, defaultValue: currentDateAndTime);

class Shape1 extends i0.VersionedTable {
  Shape1({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get projectId =>
      columnsByName['project_id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get onlineId =>
      columnsByName['online_id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get description =>
      columnsByName['description']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get duration =>
      columnsByName['duration']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get status =>
      columnsByName['status']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<DateTime> get lastTicked =>
      columnsByName['last_ticked']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get firstTicked =>
      columnsByName['first_ticked']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get updatedAt =>
      columnsByName['updated_at']! as i1.GeneratedColumn<DateTime>;
}

i1.GeneratedColumn<int> _column_5(String aliasedName) =>
    i1.GeneratedColumn<int>('project_id', aliasedName, true,
        type: i1.DriftSqlType.int,
        defaultConstraints: i1.GeneratedColumn.constraintIsAlways(
            'REFERENCES projects (id) ON DELETE CASCADE'));
i1.GeneratedColumn<String> _column_6(String aliasedName) =>
    i1.GeneratedColumn<String>('name', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<String> _column_7(String aliasedName) =>
    i1.GeneratedColumn<String>('description', aliasedName, true,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<int> _column_8(String aliasedName) =>
    i1.GeneratedColumn<int>('duration', aliasedName, false,
        type: i1.DriftSqlType.int, defaultValue: const Constant(0));
i1.GeneratedColumn<int> _column_9(String aliasedName) =>
    i1.GeneratedColumn<int>('status', aliasedName, false,
        type: i1.DriftSqlType.int, defaultValue: const Constant(0));
i1.GeneratedColumn<DateTime> _column_10(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('last_ticked', aliasedName, true,
        type: i1.DriftSqlType.dateTime);
i1.GeneratedColumn<DateTime> _column_11(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('first_ticked', aliasedName, true,
        type: i1.DriftSqlType.dateTime);

class Shape2 extends i0.VersionedTable {
  Shape2({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get backendType =>
      columnsByName['backend_type']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get description =>
      columnsByName['description']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get updatedAt =>
      columnsByName['updated_at']! as i1.GeneratedColumn<DateTime>;
}

i1.GeneratedColumn<int> _column_12(String aliasedName) =>
    i1.GeneratedColumn<int>('backend_type', aliasedName, false,
        type: i1.DriftSqlType.int);
i1.GeneratedColumn<String> _column_13(String aliasedName) =>
    i1.GeneratedColumn<String>('description', aliasedName, false,
        type: i1.DriftSqlType.string);

class Shape3 extends i0.VersionedTable {
  Shape3({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get taskId =>
      columnsByName['task_id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get backendId =>
      columnsByName['backend_id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<DateTime> get lastSynced =>
      columnsByName['last_synced']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get updatedAt =>
      columnsByName['updated_at']! as i1.GeneratedColumn<DateTime>;
}

i1.GeneratedColumn<int> _column_14(String aliasedName) =>
    i1.GeneratedColumn<int>('task_id', aliasedName, false,
        type: i1.DriftSqlType.int,
        defaultConstraints: i1.GeneratedColumn.constraintIsAlways(
            'REFERENCES tasks (id) ON DELETE CASCADE'));
i1.GeneratedColumn<int> _column_15(String aliasedName) =>
    i1.GeneratedColumn<int>('backend_id', aliasedName, false,
        type: i1.DriftSqlType.int,
        defaultConstraints: i1.GeneratedColumn.constraintIsAlways(
            'REFERENCES backends (id) ON DELETE CASCADE'));
i1.GeneratedColumn<DateTime> _column_16(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('last_synced', aliasedName, true,
        type: i1.DriftSqlType.dateTime);

class Shape4 extends i0.VersionedTable {
  Shape4({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get onlineId =>
      columnsByName['online_id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<DateTime> get startTime =>
      columnsByName['start_time']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get endTime =>
      columnsByName['end_time']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<int> get totalSpentSeconds =>
      columnsByName['total_spent_seconds']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get taskId =>
      columnsByName['task_id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<DateTime> get updatedAt =>
      columnsByName['updated_at']! as i1.GeneratedColumn<DateTime>;
}

i1.GeneratedColumn<DateTime> _column_17(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('start_time', aliasedName, false,
        type: i1.DriftSqlType.dateTime);
i1.GeneratedColumn<DateTime> _column_18(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('end_time', aliasedName, false,
        type: i1.DriftSqlType.dateTime);
i1.GeneratedColumn<int> _column_19(String aliasedName) =>
    i1.GeneratedColumn<int>('total_spent_seconds', aliasedName, false,
        type: i1.DriftSqlType.int);
i1.OnUpgrade stepByStep({
  required Future<void> Function(i1.Migrator m, _S2 schema) from1To2,
}) {
  return i1.Migrator.stepByStepHelper(step: (currentVersion, database) async {
    switch (currentVersion) {
      case 1:
        final schema = _S2(database: database);
        final migrator = i1.Migrator(database, schema);
        await from1To2(migrator, schema);
        return 2;
      default:
        throw ArgumentError.value('Unknown migration from $currentVersion');
    }
  });
}
