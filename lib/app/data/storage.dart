import 'package:drift/drift.dart';
import 'package:e1547/files/files.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/identity/data/database.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/task/task.dart';
import 'package:e1547/traits/traits.dart';
import 'package:notified_preferences/notified_preferences.dart';

// ignore: always_use_package_imports
import 'storage.drift.dart';

@DriftDatabase(
  tables: [
    IdentitiesTable,
    TraitsTable,
    HistoriesTable,
    HistoriesIdentitiesTable,
    FollowsTable,
    FollowsIdentitiesTable,
    TasksTable,
    TasksIdentitiesTable,
    QueryStorageTable,
    FileCacheTable,
  ],
)
class AppDatabase extends $AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) {
      return m.createAll().then((_) async {
        await customStatement('''
              CREATE TRIGGER delete_identity_follows
              AFTER DELETE ON identities_table
              BEGIN
                  DELETE FROM follows_table
                  WHERE id IN (SELECT follow FROM follows_identities_table WHERE identity = OLD.id);
              END;
              CREATE TRIGGER delete_identity_histories
              AFTER DELETE ON identities_table
              BEGIN
                  DELETE FROM histories_table
                  WHERE id IN (SELECT history FROM histories_identities_table WHERE identity = OLD.id);
              END;
              CREATE TRIGGER delete_identity_tasks
              AFTER DELETE ON identities_table
              BEGIN
                  DELETE FROM tasks_table
                  WHERE id IN (SELECT task FROM tasks_identities_table WHERE identity = OLD.id);
              END;
            ''');
      });
    },
    onUpgrade: (m, from, to) async {
      if (from < 4) {
        await customStatement('''
              DELETE FROM identities_table
              WHERE type != 'e621';
              ''');
        await m.alterTable(TableMigration(identitiesTable));
        await m.alterTable(
          TableMigration(
            traitsTable,
            newColumns: [traitsTable.userId, traitsTable.perPage],
          ),
        );
      }
      if (from < 5) {
        await m.alterTable(
          TableMigration(
            traitsTable,
            newColumns: [traitsTable.writeHistory, traitsTable.trimHistory],
          ),
        );
      }
      if (from < 6) {
        final existing = await customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'tasks_table'",
        ).get();
        if (existing.isEmpty) {
          await m.createTable(tasksTable);
          await m.createTable(tasksIdentitiesTable);
          await customStatement('''
                CREATE TRIGGER delete_identity_tasks
                AFTER DELETE ON identities_table
                BEGIN
                    DELETE FROM tasks_table
                    WHERE id IN (SELECT task FROM tasks_identities_table WHERE identity = OLD.id);
                END;
              ''');
        }
      }
      if (from >= 6 && from < 7) {
        await m.addColumn(tasksTable, tasksTable.metadata);
      }
      if (from < 8) {
        await m.createTable(queryStorageTable);
      }
      if (from < 9) {
        await m.createTable(fileCacheTable);
        // createTable does not create indexes, unlike createAll.
        await m.create(fileCacheLookup);
        await m.create(fileCacheTouched);
      }
    },
    beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
  );
}

/// Holds various databases for the app.
class AppStorage {
  const AppStorage({
    required this.preferences,
    required this.temporaryFiles,
    required this.queryCache,
    required this.sqlite,
  });

  final SharedPreferences preferences;
  final String temporaryFiles;
  final CachedQuery queryCache;
  final AppDatabase sqlite;

  Future<void> close() async {
    queryCache.deleteCache();
    await sqlite.close();
  }
}
