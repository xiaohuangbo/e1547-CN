// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:drift/src/runtime/api/runtime_api.dart' as i1;
import 'package:e1547/task/data/database.drift.dart' as i2;
import 'package:drift/internal/modular.dart' as i3;
import 'package:e1547/identity/data/database.drift.dart' as i4;
import 'package:e1547/task/data/task.dart' as i5;
import 'package:e1547/task/data/database.dart' as i6;
import 'package:e1547/shared/data/sql.dart' as i7;

typedef $$TasksTableTableCreateCompanionBuilder =
    i2.TaskCompanion Function({
      i0.Value<int> id,
      required i5.TaskAction action,
      required int postId,
      required i5.TaskStatus status,
      i0.Value<String?> error,
      required DateTime createdAt,
      i0.Value<DateTime?> completedAt,
      i0.Value<i5.TaskMetadata?> metadata,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    i2.TaskCompanion Function({
      i0.Value<int> id,
      i0.Value<i5.TaskAction> action,
      i0.Value<int> postId,
      i0.Value<i5.TaskStatus> status,
      i0.Value<String?> error,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime?> completedAt,
      i0.Value<i5.TaskMetadata?> metadata,
    });

final class $$TasksTableTableReferences
    extends
        i0.BaseReferences<i0.GeneratedDatabase, i2.$TasksTableTable, i5.Task> {
  $$TasksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static i0.MultiTypedResultKey<
    i2.$TasksIdentitiesTableTable,
    List<i2.TaskIdentity>
  >
  _tasksIdentitiesTableRefsTable(i0.GeneratedDatabase db) =>
      i0.MultiTypedResultKey.fromTable(
        i3.ReadDatabaseContainer(
          db,
        ).resultSet<i2.$TasksIdentitiesTableTable>('tasks_identities_table'),
        aliasName: i0.$_aliasNameGenerator(
          i3.ReadDatabaseContainer(
            db,
          ).resultSet<i2.$TasksTableTable>('tasks_table').id,
          i3.ReadDatabaseContainer(db)
              .resultSet<i2.$TasksIdentitiesTableTable>(
                'tasks_identities_table',
              )
              .task,
        ),
      );

  i2.$$TasksIdentitiesTableTableProcessedTableManager
  get tasksIdentitiesTableRefs {
    final manager = i2
        .$$TasksIdentitiesTableTableTableManager(
          $_db,
          i3.ReadDatabaseContainer(
            $_db,
          ).resultSet<i2.$TasksIdentitiesTableTable>('tasks_identities_table'),
        )
        .filter((f) => f.task.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tasksIdentitiesTableRefsTable($_db),
    );
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i5.TaskAction, i5.TaskAction, String>
  get action => $composableBuilder(
    column: $table.action,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<int> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i5.TaskStatus, i5.TaskStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i5.TaskMetadata?, i5.TaskMetadata, String>
  get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.Expression<bool> tasksIdentitiesTableRefs(
    i0.Expression<bool> Function(i2.$$TasksIdentitiesTableTableFilterComposer f)
    f,
  ) {
    final i2.$$TasksIdentitiesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: i3.ReadDatabaseContainer(
            $db,
          ).resultSet<i2.$TasksIdentitiesTableTable>('tasks_identities_table'),
          getReferencedColumn: (t) => t.task,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => i2.$$TasksIdentitiesTableTableFilterComposer(
                $db: $db,
                $table: i3.ReadDatabaseContainer($db)
                    .resultSet<i2.$TasksIdentitiesTableTable>(
                      'tasks_identities_table',
                    ),
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TasksTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$TasksTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i5.TaskAction, String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  i0.GeneratedColumn<int> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i5.TaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  i0.GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<i5.TaskMetadata?, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  i0.Expression<T> tasksIdentitiesTableRefs<T extends Object>(
    i0.Expression<T> Function(
      i2.$$TasksIdentitiesTableTableAnnotationComposer a,
    )
    f,
  ) {
    final i2.$$TasksIdentitiesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: i3.ReadDatabaseContainer(
            $db,
          ).resultSet<i2.$TasksIdentitiesTableTable>('tasks_identities_table'),
          getReferencedColumn: (t) => t.task,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => i2.$$TasksIdentitiesTableTableAnnotationComposer(
                $db: $db,
                $table: i3.ReadDatabaseContainer($db)
                    .resultSet<i2.$TasksIdentitiesTableTable>(
                      'tasks_identities_table',
                    ),
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TasksTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i2.$TasksTableTable,
          i5.Task,
          i2.$$TasksTableTableFilterComposer,
          i2.$$TasksTableTableOrderingComposer,
          i2.$$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (i5.Task, i2.$$TasksTableTableReferences),
          i5.Task,
          i0.PrefetchHooks Function({bool tasksIdentitiesTableRefs})
        > {
  $$TasksTableTableTableManager(
    i0.GeneratedDatabase db,
    i2.$TasksTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i2.$$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i2.$$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<int> id = const i0.Value.absent(),
                i0.Value<i5.TaskAction> action = const i0.Value.absent(),
                i0.Value<int> postId = const i0.Value.absent(),
                i0.Value<i5.TaskStatus> status = const i0.Value.absent(),
                i0.Value<String?> error = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime?> completedAt = const i0.Value.absent(),
                i0.Value<i5.TaskMetadata?> metadata = const i0.Value.absent(),
              }) => i2.TaskCompanion(
                id: id,
                action: action,
                postId: postId,
                status: status,
                error: error,
                createdAt: createdAt,
                completedAt: completedAt,
                metadata: metadata,
              ),
          createCompanionCallback:
              ({
                i0.Value<int> id = const i0.Value.absent(),
                required i5.TaskAction action,
                required int postId,
                required i5.TaskStatus status,
                i0.Value<String?> error = const i0.Value.absent(),
                required DateTime createdAt,
                i0.Value<DateTime?> completedAt = const i0.Value.absent(),
                i0.Value<i5.TaskMetadata?> metadata = const i0.Value.absent(),
              }) => i2.TaskCompanion.insert(
                id: id,
                action: action,
                postId: postId,
                status: status,
                error: error,
                createdAt: createdAt,
                completedAt: completedAt,
                metadata: metadata,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  i2.$$TasksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tasksIdentitiesTableRefs = false}) {
            return i0.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tasksIdentitiesTableRefs)
                  i3.ReadDatabaseContainer(
                    db,
                  ).resultSet<i2.$TasksIdentitiesTableTable>(
                    'tasks_identities_table',
                  ),
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksIdentitiesTableRefs)
                    await i0.$_getPrefetchedData<
                      i5.Task,
                      i2.$TasksTableTable,
                      i2.TaskIdentity
                    >(
                      currentTable: table,
                      referencedTable: i2.$$TasksTableTableReferences
                          ._tasksIdentitiesTableRefsTable(db),
                      managerFromTypedResult: (p0) => i2
                          .$$TasksTableTableReferences(db, table, p0)
                          .tasksIdentitiesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.task == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i2.$TasksTableTable,
      i5.Task,
      i2.$$TasksTableTableFilterComposer,
      i2.$$TasksTableTableOrderingComposer,
      i2.$$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (i5.Task, i2.$$TasksTableTableReferences),
      i5.Task,
      i0.PrefetchHooks Function({bool tasksIdentitiesTableRefs})
    >;
typedef $$TasksIdentitiesTableTableCreateCompanionBuilder =
    i2.TaskIdentityCompanion Function({
      required int identity,
      required int task,
      i0.Value<int> rowid,
    });
typedef $$TasksIdentitiesTableTableUpdateCompanionBuilder =
    i2.TaskIdentityCompanion Function({
      i0.Value<int> identity,
      i0.Value<int> task,
      i0.Value<int> rowid,
    });

final class $$TasksIdentitiesTableTableReferences
    extends
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i2.$TasksIdentitiesTableTable,
          i2.TaskIdentity
        > {
  $$TasksIdentitiesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static i4.$IdentitiesTableTable _identityTable(i0.GeneratedDatabase db) =>
      i3.ReadDatabaseContainer(db)
          .resultSet<i4.$IdentitiesTableTable>('identities_table')
          .createAlias(
            i0.$_aliasNameGenerator(
              i3.ReadDatabaseContainer(db)
                  .resultSet<i2.$TasksIdentitiesTableTable>(
                    'tasks_identities_table',
                  )
                  .identity,
              i3.ReadDatabaseContainer(
                db,
              ).resultSet<i4.$IdentitiesTableTable>('identities_table').id,
            ),
          );

  i4.$$IdentitiesTableTableProcessedTableManager get identity {
    final $_column = $_itemColumn<int>('identity')!;

    final manager = i4
        .$$IdentitiesTableTableTableManager(
          $_db,
          i3.ReadDatabaseContainer(
            $_db,
          ).resultSet<i4.$IdentitiesTableTable>('identities_table'),
        )
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_identityTable($_db));
    if (item == null) return manager;
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static i2.$TasksTableTable _taskTable(i0.GeneratedDatabase db) =>
      i3.ReadDatabaseContainer(db)
          .resultSet<i2.$TasksTableTable>('tasks_table')
          .createAlias(
            i0.$_aliasNameGenerator(
              i3.ReadDatabaseContainer(db)
                  .resultSet<i2.$TasksIdentitiesTableTable>(
                    'tasks_identities_table',
                  )
                  .task,
              i3.ReadDatabaseContainer(
                db,
              ).resultSet<i2.$TasksTableTable>('tasks_table').id,
            ),
          );

  i2.$$TasksTableTableProcessedTableManager get task {
    final $_column = $_itemColumn<int>('task')!;

    final manager = i2
        .$$TasksTableTableTableManager(
          $_db,
          i3.ReadDatabaseContainer(
            $_db,
          ).resultSet<i2.$TasksTableTable>('tasks_table'),
        )
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskTable($_db));
    if (item == null) return manager;
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TasksIdentitiesTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$TasksIdentitiesTableTable> {
  $$TasksIdentitiesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i4.$$IdentitiesTableTableFilterComposer get identity {
    final i4.$$IdentitiesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.identity,
      referencedTable: i3.ReadDatabaseContainer(
        $db,
      ).resultSet<i4.$IdentitiesTableTable>('identities_table'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i4.$$IdentitiesTableTableFilterComposer(
            $db: $db,
            $table: i3.ReadDatabaseContainer(
              $db,
            ).resultSet<i4.$IdentitiesTableTable>('identities_table'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  i2.$$TasksTableTableFilterComposer get task {
    final i2.$$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.task,
      referencedTable: i3.ReadDatabaseContainer(
        $db,
      ).resultSet<i2.$TasksTableTable>('tasks_table'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i2.$$TasksTableTableFilterComposer(
            $db: $db,
            $table: i3.ReadDatabaseContainer(
              $db,
            ).resultSet<i2.$TasksTableTable>('tasks_table'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksIdentitiesTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$TasksIdentitiesTableTable> {
  $$TasksIdentitiesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i4.$$IdentitiesTableTableOrderingComposer get identity {
    final i4.$$IdentitiesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.identity,
      referencedTable: i3.ReadDatabaseContainer(
        $db,
      ).resultSet<i4.$IdentitiesTableTable>('identities_table'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i4.$$IdentitiesTableTableOrderingComposer(
            $db: $db,
            $table: i3.ReadDatabaseContainer(
              $db,
            ).resultSet<i4.$IdentitiesTableTable>('identities_table'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  i2.$$TasksTableTableOrderingComposer get task {
    final i2.$$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.task,
      referencedTable: i3.ReadDatabaseContainer(
        $db,
      ).resultSet<i2.$TasksTableTable>('tasks_table'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i2.$$TasksTableTableOrderingComposer(
            $db: $db,
            $table: i3.ReadDatabaseContainer(
              $db,
            ).resultSet<i2.$TasksTableTable>('tasks_table'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksIdentitiesTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$TasksIdentitiesTableTable> {
  $$TasksIdentitiesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i4.$$IdentitiesTableTableAnnotationComposer get identity {
    final i4.$$IdentitiesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.identity,
          referencedTable: i3.ReadDatabaseContainer(
            $db,
          ).resultSet<i4.$IdentitiesTableTable>('identities_table'),
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => i4.$$IdentitiesTableTableAnnotationComposer(
                $db: $db,
                $table: i3.ReadDatabaseContainer(
                  $db,
                ).resultSet<i4.$IdentitiesTableTable>('identities_table'),
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  i2.$$TasksTableTableAnnotationComposer get task {
    final i2.$$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.task,
      referencedTable: i3.ReadDatabaseContainer(
        $db,
      ).resultSet<i2.$TasksTableTable>('tasks_table'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i2.$$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: i3.ReadDatabaseContainer(
              $db,
            ).resultSet<i2.$TasksTableTable>('tasks_table'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksIdentitiesTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i2.$TasksIdentitiesTableTable,
          i2.TaskIdentity,
          i2.$$TasksIdentitiesTableTableFilterComposer,
          i2.$$TasksIdentitiesTableTableOrderingComposer,
          i2.$$TasksIdentitiesTableTableAnnotationComposer,
          $$TasksIdentitiesTableTableCreateCompanionBuilder,
          $$TasksIdentitiesTableTableUpdateCompanionBuilder,
          (i2.TaskIdentity, i2.$$TasksIdentitiesTableTableReferences),
          i2.TaskIdentity,
          i0.PrefetchHooks Function({bool identity, bool task})
        > {
  $$TasksIdentitiesTableTableTableManager(
    i0.GeneratedDatabase db,
    i2.$TasksIdentitiesTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$TasksIdentitiesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              i2.$$TasksIdentitiesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              i2.$$TasksIdentitiesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                i0.Value<int> identity = const i0.Value.absent(),
                i0.Value<int> task = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.TaskIdentityCompanion(
                identity: identity,
                task: task,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int identity,
                required int task,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.TaskIdentityCompanion.insert(
                identity: identity,
                task: task,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  i2.$$TasksIdentitiesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({identity = false, task = false}) {
            return i0.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends i0.TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (identity) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.identity,
                                referencedTable: i2
                                    .$$TasksIdentitiesTableTableReferences
                                    ._identityTable(db),
                                referencedColumn: i2
                                    .$$TasksIdentitiesTableTableReferences
                                    ._identityTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (task) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.task,
                                referencedTable: i2
                                    .$$TasksIdentitiesTableTableReferences
                                    ._taskTable(db),
                                referencedColumn: i2
                                    .$$TasksIdentitiesTableTableReferences
                                    ._taskTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TasksIdentitiesTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i2.$TasksIdentitiesTableTable,
      i2.TaskIdentity,
      i2.$$TasksIdentitiesTableTableFilterComposer,
      i2.$$TasksIdentitiesTableTableOrderingComposer,
      i2.$$TasksIdentitiesTableTableAnnotationComposer,
      $$TasksIdentitiesTableTableCreateCompanionBuilder,
      $$TasksIdentitiesTableTableUpdateCompanionBuilder,
      (i2.TaskIdentity, i2.$$TasksIdentitiesTableTableReferences),
      i2.TaskIdentity,
      i0.PrefetchHooks Function({bool identity, bool task})
    >;
mixin $TaskRepositoryMixin on i0.DatabaseAccessor<i1.GeneratedDatabase> {
  i2.$TasksTableTable get tasksTable => i3.ReadDatabaseContainer(
    attachedDatabase,
  ).resultSet<i2.$TasksTableTable>('tasks_table');
  i4.$IdentitiesTableTable get identitiesTable => i3.ReadDatabaseContainer(
    attachedDatabase,
  ).resultSet<i4.$IdentitiesTableTable>('identities_table');
  i2.$TasksIdentitiesTableTable get tasksIdentitiesTable =>
      i3.ReadDatabaseContainer(
        attachedDatabase,
      ).resultSet<i2.$TasksIdentitiesTableTable>('tasks_identities_table');
  TaskRepositoryManager get managers => TaskRepositoryManager(this);
}

class TaskRepositoryManager {
  final $TaskRepositoryMixin _db;
  TaskRepositoryManager(this._db);
  i2.$$TasksTableTableTableManager get tasksTable =>
      i2.$$TasksTableTableTableManager(_db.attachedDatabase, _db.tasksTable);
  i4.$$IdentitiesTableTableTableManager get identitiesTable =>
      i4.$$IdentitiesTableTableTableManager(
        _db.attachedDatabase,
        _db.identitiesTable,
      );
  i2.$$TasksIdentitiesTableTableTableManager get tasksIdentitiesTable =>
      i2.$$TasksIdentitiesTableTableTableManager(
        _db.attachedDatabase,
        _db.tasksIdentitiesTable,
      );
}

class $TasksTableTable extends i6.TasksTable
    with i0.TableInfo<$TasksTableTable, i5.Task> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i5.TaskAction, String> action =
      i0.GeneratedColumn<String>(
        'action',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<i5.TaskAction>(i2.$TasksTableTable.$converteraction);
  static const i0.VerificationMeta _postIdMeta = const i0.VerificationMeta(
    'postId',
  );
  @override
  late final i0.GeneratedColumn<int> postId = i0.GeneratedColumn<int>(
    'post_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i5.TaskStatus, String> status =
      i0.GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<i5.TaskStatus>(i2.$TasksTableTable.$converterstatus);
  static const i0.VerificationMeta _errorMeta = const i0.VerificationMeta(
    'error',
  );
  @override
  late final i0.GeneratedColumn<String> error = i0.GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _createdAtMeta = const i0.VerificationMeta(
    'createdAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> createdAt =
      i0.GeneratedColumn<DateTime>(
        'created_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _completedAtMeta = const i0.VerificationMeta(
    'completedAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> completedAt =
      i0.GeneratedColumn<DateTime>(
        'completed_at',
        aliasedName,
        true,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i5.TaskMetadata?, String>
  metadata = i0.GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<i5.TaskMetadata?>(i2.$TasksTableTable.$convertermetadatan);
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    action,
    postId,
    status,
    error,
    createdAt,
    completedAt,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i5.Task> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i5.Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i5.Task(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      action: i2.$TasksTableTable.$converteraction.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}action'],
        )!,
      ),
      postId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}post_id'],
      )!,
      status: i2.$TasksTableTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      error: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      metadata: i2.$TasksTableTable.$convertermetadatan.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}metadata'],
        ),
      ),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<i5.TaskAction, String, String> $converteraction =
      const i0.EnumNameConverter<i5.TaskAction>(i5.TaskAction.values);
  static i0.JsonTypeConverter2<i5.TaskStatus, String, String> $converterstatus =
      const i0.EnumNameConverter<i5.TaskStatus>(i5.TaskStatus.values);
  static i0.TypeConverter<i5.TaskMetadata, String> $convertermetadata =
      i7.JsonSqlConverter<i5.TaskMetadata>(
        decode: (value) =>
            i5.TaskMetadata.fromJson(value as Map<String, dynamic>),
      );
  static i0.TypeConverter<i5.TaskMetadata?, String?> $convertermetadatan =
      i0.NullAwareTypeConverter.wrap($convertermetadata);
}

class TaskCompanion extends i0.UpdateCompanion<i5.Task> {
  final i0.Value<int> id;
  final i0.Value<i5.TaskAction> action;
  final i0.Value<int> postId;
  final i0.Value<i5.TaskStatus> status;
  final i0.Value<String?> error;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime?> completedAt;
  final i0.Value<i5.TaskMetadata?> metadata;
  const TaskCompanion({
    this.id = const i0.Value.absent(),
    this.action = const i0.Value.absent(),
    this.postId = const i0.Value.absent(),
    this.status = const i0.Value.absent(),
    this.error = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.completedAt = const i0.Value.absent(),
    this.metadata = const i0.Value.absent(),
  });
  TaskCompanion.insert({
    this.id = const i0.Value.absent(),
    required i5.TaskAction action,
    required int postId,
    required i5.TaskStatus status,
    this.error = const i0.Value.absent(),
    required DateTime createdAt,
    this.completedAt = const i0.Value.absent(),
    this.metadata = const i0.Value.absent(),
  }) : action = i0.Value(action),
       postId = i0.Value(postId),
       status = i0.Value(status),
       createdAt = i0.Value(createdAt);
  static i0.Insertable<i5.Task> custom({
    i0.Expression<int>? id,
    i0.Expression<String>? action,
    i0.Expression<int>? postId,
    i0.Expression<String>? status,
    i0.Expression<String>? error,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? completedAt,
    i0.Expression<String>? metadata,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (postId != null) 'post_id': postId,
      if (status != null) 'status': status,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (metadata != null) 'metadata': metadata,
    });
  }

  i2.TaskCompanion copyWith({
    i0.Value<int>? id,
    i0.Value<i5.TaskAction>? action,
    i0.Value<int>? postId,
    i0.Value<i5.TaskStatus>? status,
    i0.Value<String?>? error,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime?>? completedAt,
    i0.Value<i5.TaskMetadata?>? metadata,
  }) {
    return i2.TaskCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      postId: postId ?? this.postId,
      status: status ?? this.status,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (action.present) {
      map['action'] = i0.Variable<String>(
        i2.$TasksTableTable.$converteraction.toSql(action.value),
      );
    }
    if (postId.present) {
      map['post_id'] = i0.Variable<int>(postId.value);
    }
    if (status.present) {
      map['status'] = i0.Variable<String>(
        i2.$TasksTableTable.$converterstatus.toSql(status.value),
      );
    }
    if (error.present) {
      map['error'] = i0.Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = i0.Variable<DateTime>(completedAt.value);
    }
    if (metadata.present) {
      map['metadata'] = i0.Variable<String>(
        i2.$TasksTableTable.$convertermetadatan.toSql(metadata.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('postId: $postId, ')
          ..write('status: $status, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }
}

class _$TaskInsertable implements i0.Insertable<i5.Task> {
  i5.Task _object;
  _$TaskInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i2.TaskCompanion(
      id: i0.Value(_object.id),
      action: i0.Value(_object.action),
      postId: i0.Value(_object.postId),
      status: i0.Value(_object.status),
      error: i0.Value(_object.error),
      createdAt: i0.Value(_object.createdAt),
      completedAt: i0.Value(_object.completedAt),
      metadata: i0.Value(_object.metadata),
    ).toColumns(false);
  }
}

extension TaskToInsertable on i5.Task {
  _$TaskInsertable toInsertable() {
    return _$TaskInsertable(this);
  }
}

class $TasksIdentitiesTableTable extends i6.TasksIdentitiesTable
    with i0.TableInfo<$TasksIdentitiesTableTable, i2.TaskIdentity> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksIdentitiesTableTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _identityMeta = const i0.VerificationMeta(
    'identity',
  );
  @override
  late final i0.GeneratedColumn<int> identity = i0.GeneratedColumn<int>(
    'identity',
    aliasedName,
    false,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'REFERENCES identities_table (id) ON UPDATE NO ACTION ON DELETE NO ACTION',
    ),
  );
  static const i0.VerificationMeta _taskMeta = const i0.VerificationMeta(
    'task',
  );
  @override
  late final i0.GeneratedColumn<int> task = i0.GeneratedColumn<int>(
    'task',
    aliasedName,
    false,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks_table (id) ON UPDATE CASCADE ON DELETE CASCADE',
    ),
  );
  @override
  List<i0.GeneratedColumn> get $columns => [identity, task];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_identities_table';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i2.TaskIdentity> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('identity')) {
      context.handle(
        _identityMeta,
        identity.isAcceptableOrUnknown(data['identity']!, _identityMeta),
      );
    } else if (isInserting) {
      context.missing(_identityMeta);
    }
    if (data.containsKey('task')) {
      context.handle(
        _taskMeta,
        task.isAcceptableOrUnknown(data['task']!, _taskMeta),
      );
    } else if (isInserting) {
      context.missing(_taskMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {identity, task};
  @override
  i2.TaskIdentity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.TaskIdentity(
      identity: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}identity'],
      )!,
      task: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}task'],
      )!,
    );
  }

  @override
  $TasksIdentitiesTableTable createAlias(String alias) {
    return $TasksIdentitiesTableTable(attachedDatabase, alias);
  }
}

class TaskIdentity extends i0.DataClass
    implements i0.Insertable<i2.TaskIdentity> {
  final int identity;
  final int task;
  const TaskIdentity({required this.identity, required this.task});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['identity'] = i0.Variable<int>(identity);
    map['task'] = i0.Variable<int>(task);
    return map;
  }

  i2.TaskIdentityCompanion toCompanion(bool nullToAbsent) {
    return i2.TaskIdentityCompanion(
      identity: i0.Value(identity),
      task: i0.Value(task),
    );
  }

  factory TaskIdentity.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return TaskIdentity(
      identity: serializer.fromJson<int>(json['identity']),
      task: serializer.fromJson<int>(json['task']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'identity': serializer.toJson<int>(identity),
      'task': serializer.toJson<int>(task),
    };
  }

  i2.TaskIdentity copyWith({int? identity, int? task}) => i2.TaskIdentity(
    identity: identity ?? this.identity,
    task: task ?? this.task,
  );
  TaskIdentity copyWithCompanion(i2.TaskIdentityCompanion data) {
    return TaskIdentity(
      identity: data.identity.present ? data.identity.value : this.identity,
      task: data.task.present ? data.task.value : this.task,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskIdentity(')
          ..write('identity: $identity, ')
          ..write('task: $task')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(identity, task);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.TaskIdentity &&
          other.identity == this.identity &&
          other.task == this.task);
}

class TaskIdentityCompanion extends i0.UpdateCompanion<i2.TaskIdentity> {
  final i0.Value<int> identity;
  final i0.Value<int> task;
  final i0.Value<int> rowid;
  const TaskIdentityCompanion({
    this.identity = const i0.Value.absent(),
    this.task = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  TaskIdentityCompanion.insert({
    required int identity,
    required int task,
    this.rowid = const i0.Value.absent(),
  }) : identity = i0.Value(identity),
       task = i0.Value(task);
  static i0.Insertable<i2.TaskIdentity> custom({
    i0.Expression<int>? identity,
    i0.Expression<int>? task,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (identity != null) 'identity': identity,
      if (task != null) 'task': task,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i2.TaskIdentityCompanion copyWith({
    i0.Value<int>? identity,
    i0.Value<int>? task,
    i0.Value<int>? rowid,
  }) {
    return i2.TaskIdentityCompanion(
      identity: identity ?? this.identity,
      task: task ?? this.task,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (identity.present) {
      map['identity'] = i0.Variable<int>(identity.value);
    }
    if (task.present) {
      map['task'] = i0.Variable<int>(task.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskIdentityCompanion(')
          ..write('identity: $identity, ')
          ..write('task: $task, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}
