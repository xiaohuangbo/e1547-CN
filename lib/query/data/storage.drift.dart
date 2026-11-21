// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:drift/src/runtime/api/runtime_api.dart' as i1;
import 'package:e1547/query/data/storage.drift.dart' as i2;
import 'package:drift/internal/modular.dart' as i3;
import 'package:e1547/query/data/storage.dart' as i4;

typedef $$QueryStorageTableTableCreateCompanionBuilder =
    i2.QueryStorageTableDataCompanion Function({
      required String key,
      required String data,
      required DateTime createdAt,
      i0.Value<int?> duration,
      i0.Value<DateTime?> expiresAt,
      i0.Value<int> rowid,
    });
typedef $$QueryStorageTableTableUpdateCompanionBuilder =
    i2.QueryStorageTableDataCompanion Function({
      i0.Value<String> key,
      i0.Value<String> data,
      i0.Value<DateTime> createdAt,
      i0.Value<int?> duration,
      i0.Value<DateTime?> expiresAt,
      i0.Value<int> rowid,
    });

class $$QueryStorageTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$QueryStorageTableTable> {
  $$QueryStorageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$QueryStorageTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$QueryStorageTableTable> {
  $$QueryStorageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$QueryStorageTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$QueryStorageTableTable> {
  $$QueryStorageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  i0.GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  i0.GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$QueryStorageTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i2.$QueryStorageTableTable,
          i2.QueryStorageTableData,
          i2.$$QueryStorageTableTableFilterComposer,
          i2.$$QueryStorageTableTableOrderingComposer,
          i2.$$QueryStorageTableTableAnnotationComposer,
          $$QueryStorageTableTableCreateCompanionBuilder,
          $$QueryStorageTableTableUpdateCompanionBuilder,
          (
            i2.QueryStorageTableData,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i2.$QueryStorageTableTable,
              i2.QueryStorageTableData
            >,
          ),
          i2.QueryStorageTableData,
          i0.PrefetchHooks Function()
        > {
  $$QueryStorageTableTableTableManager(
    i0.GeneratedDatabase db,
    i2.$QueryStorageTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$QueryStorageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => i2
              .$$QueryStorageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i2.$$QueryStorageTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                i0.Value<String> key = const i0.Value.absent(),
                i0.Value<String> data = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<int?> duration = const i0.Value.absent(),
                i0.Value<DateTime?> expiresAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.QueryStorageTableDataCompanion(
                key: key,
                data: data,
                createdAt: createdAt,
                duration: duration,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String data,
                required DateTime createdAt,
                i0.Value<int?> duration = const i0.Value.absent(),
                i0.Value<DateTime?> expiresAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.QueryStorageTableDataCompanion.insert(
                key: key,
                data: data,
                createdAt: createdAt,
                duration: duration,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueryStorageTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i2.$QueryStorageTableTable,
      i2.QueryStorageTableData,
      i2.$$QueryStorageTableTableFilterComposer,
      i2.$$QueryStorageTableTableOrderingComposer,
      i2.$$QueryStorageTableTableAnnotationComposer,
      $$QueryStorageTableTableCreateCompanionBuilder,
      $$QueryStorageTableTableUpdateCompanionBuilder,
      (
        i2.QueryStorageTableData,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i2.$QueryStorageTableTable,
          i2.QueryStorageTableData
        >,
      ),
      i2.QueryStorageTableData,
      i0.PrefetchHooks Function()
    >;
mixin $QueryStorageRepositoryMixin
    on i0.DatabaseAccessor<i1.GeneratedDatabase> {
  i2.$QueryStorageTableTable get queryStorageTable => i3.ReadDatabaseContainer(
    attachedDatabase,
  ).resultSet<i2.$QueryStorageTableTable>('query_storage_table');
  QueryStorageRepositoryManager get managers =>
      QueryStorageRepositoryManager(this);
}

class QueryStorageRepositoryManager {
  final $QueryStorageRepositoryMixin _db;
  QueryStorageRepositoryManager(this._db);
  i2.$$QueryStorageTableTableTableManager get queryStorageTable =>
      i2.$$QueryStorageTableTableTableManager(
        _db.attachedDatabase,
        _db.queryStorageTable,
      );
}

class $QueryStorageTableTable extends i4.QueryStorageTable
    with i0.TableInfo<$QueryStorageTableTable, i2.QueryStorageTableData> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueryStorageTableTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _keyMeta = const i0.VerificationMeta('key');
  @override
  late final i0.GeneratedColumn<String> key = i0.GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _dataMeta = const i0.VerificationMeta(
    'data',
  );
  @override
  late final i0.GeneratedColumn<String> data = i0.GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const i0.VerificationMeta _durationMeta = const i0.VerificationMeta(
    'duration',
  );
  @override
  late final i0.GeneratedColumn<int> duration = i0.GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _expiresAtMeta = const i0.VerificationMeta(
    'expiresAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> expiresAt =
      i0.GeneratedColumn<DateTime>(
        'expires_at',
        aliasedName,
        true,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<i0.GeneratedColumn> get $columns => [
    key,
    data,
    createdAt,
    duration,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'query_storage_table';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i2.QueryStorageTableData> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {key};
  @override
  i2.QueryStorageTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.QueryStorageTableData(
      key: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      data: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $QueryStorageTableTable createAlias(String alias) {
    return $QueryStorageTableTable(attachedDatabase, alias);
  }
}

class QueryStorageTableData extends i0.DataClass
    implements i0.Insertable<i2.QueryStorageTableData> {
  final String key;
  final String data;
  final DateTime createdAt;
  final int? duration;
  final DateTime? expiresAt;
  const QueryStorageTableData({
    required this.key,
    required this.data,
    required this.createdAt,
    this.duration,
    this.expiresAt,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['key'] = i0.Variable<String>(key);
    map['data'] = i0.Variable<String>(data);
    map['created_at'] = i0.Variable<DateTime>(createdAt);
    if (!nullToAbsent || duration != null) {
      map['duration'] = i0.Variable<int>(duration);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = i0.Variable<DateTime>(expiresAt);
    }
    return map;
  }

  i2.QueryStorageTableDataCompanion toCompanion(bool nullToAbsent) {
    return i2.QueryStorageTableDataCompanion(
      key: i0.Value(key),
      data: i0.Value(data),
      createdAt: i0.Value(createdAt),
      duration: duration == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(duration),
      expiresAt: expiresAt == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(expiresAt),
    );
  }

  factory QueryStorageTableData.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return QueryStorageTableData(
      key: serializer.fromJson<String>(json['key']),
      data: serializer.fromJson<String>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      duration: serializer.fromJson<int?>(json['duration']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'data': serializer.toJson<String>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'duration': serializer.toJson<int?>(duration),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  i2.QueryStorageTableData copyWith({
    String? key,
    String? data,
    DateTime? createdAt,
    i0.Value<int?> duration = const i0.Value.absent(),
    i0.Value<DateTime?> expiresAt = const i0.Value.absent(),
  }) => i2.QueryStorageTableData(
    key: key ?? this.key,
    data: data ?? this.data,
    createdAt: createdAt ?? this.createdAt,
    duration: duration.present ? duration.value : this.duration,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  QueryStorageTableData copyWithCompanion(
    i2.QueryStorageTableDataCompanion data,
  ) {
    return QueryStorageTableData(
      key: data.key.present ? data.key.value : this.key,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      duration: data.duration.present ? data.duration.value : this.duration,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueryStorageTableData(')
          ..write('key: $key, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('duration: $duration, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, data, createdAt, duration, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.QueryStorageTableData &&
          other.key == this.key &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.duration == this.duration &&
          other.expiresAt == this.expiresAt);
}

class QueryStorageTableDataCompanion
    extends i0.UpdateCompanion<i2.QueryStorageTableData> {
  final i0.Value<String> key;
  final i0.Value<String> data;
  final i0.Value<DateTime> createdAt;
  final i0.Value<int?> duration;
  final i0.Value<DateTime?> expiresAt;
  final i0.Value<int> rowid;
  const QueryStorageTableDataCompanion({
    this.key = const i0.Value.absent(),
    this.data = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.duration = const i0.Value.absent(),
    this.expiresAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  QueryStorageTableDataCompanion.insert({
    required String key,
    required String data,
    required DateTime createdAt,
    this.duration = const i0.Value.absent(),
    this.expiresAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  }) : key = i0.Value(key),
       data = i0.Value(data),
       createdAt = i0.Value(createdAt);
  static i0.Insertable<i2.QueryStorageTableData> custom({
    i0.Expression<String>? key,
    i0.Expression<String>? data,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<int>? duration,
    i0.Expression<DateTime>? expiresAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (key != null) 'key': key,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (duration != null) 'duration': duration,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i2.QueryStorageTableDataCompanion copyWith({
    i0.Value<String>? key,
    i0.Value<String>? data,
    i0.Value<DateTime>? createdAt,
    i0.Value<int?>? duration,
    i0.Value<DateTime?>? expiresAt,
    i0.Value<int>? rowid,
  }) {
    return i2.QueryStorageTableDataCompanion(
      key: key ?? this.key,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (key.present) {
      map['key'] = i0.Variable<String>(key.value);
    }
    if (data.present) {
      map['data'] = i0.Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<DateTime>(createdAt.value);
    }
    if (duration.present) {
      map['duration'] = i0.Variable<int>(duration.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = i0.Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueryStorageTableDataCompanion(')
          ..write('key: $key, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('duration: $duration, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}
