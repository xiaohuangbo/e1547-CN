// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:drift/src/runtime/api/runtime_api.dart' as i1;
import 'package:e1547/files/data/storage.drift.dart' as i2;
import 'package:drift/internal/modular.dart' as i3;
import 'package:e1547/files/data/storage.dart' as i4;

typedef $$FileCacheTableTableCreateCompanionBuilder =
    i2.FileCacheTableDataCompanion Function({
      i0.Value<int> id,
      required String cache,
      required String key,
      required String url,
      required String relativePath,
      required DateTime validTill,
      i0.Value<String?> eTag,
      i0.Value<int?> length,
      required DateTime touched,
    });
typedef $$FileCacheTableTableUpdateCompanionBuilder =
    i2.FileCacheTableDataCompanion Function({
      i0.Value<int> id,
      i0.Value<String> cache,
      i0.Value<String> key,
      i0.Value<String> url,
      i0.Value<String> relativePath,
      i0.Value<DateTime> validTill,
      i0.Value<String?> eTag,
      i0.Value<int?> length,
      i0.Value<DateTime> touched,
    });

class $$FileCacheTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$FileCacheTableTable> {
  $$FileCacheTableTableFilterComposer({
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

  i0.ColumnFilters<String> get cache => $composableBuilder(
    column: $table.cache,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get validTill => $composableBuilder(
    column: $table.validTill,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get eTag => $composableBuilder(
    column: $table.eTag,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<int> get length => $composableBuilder(
    column: $table.length,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get touched => $composableBuilder(
    column: $table.touched,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$FileCacheTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$FileCacheTableTable> {
  $$FileCacheTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get cache => $composableBuilder(
    column: $table.cache,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get validTill => $composableBuilder(
    column: $table.validTill,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get eTag => $composableBuilder(
    column: $table.eTag,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get length => $composableBuilder(
    column: $table.length,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get touched => $composableBuilder(
    column: $table.touched,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$FileCacheTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$FileCacheTableTable> {
  $$FileCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get cache =>
      $composableBuilder(column: $table.cache, builder: (column) => column);

  i0.GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  i0.GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  i0.GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  i0.GeneratedColumn<DateTime> get validTill =>
      $composableBuilder(column: $table.validTill, builder: (column) => column);

  i0.GeneratedColumn<String> get eTag =>
      $composableBuilder(column: $table.eTag, builder: (column) => column);

  i0.GeneratedColumn<int> get length =>
      $composableBuilder(column: $table.length, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get touched =>
      $composableBuilder(column: $table.touched, builder: (column) => column);
}

class $$FileCacheTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i2.$FileCacheTableTable,
          i2.FileCacheTableData,
          i2.$$FileCacheTableTableFilterComposer,
          i2.$$FileCacheTableTableOrderingComposer,
          i2.$$FileCacheTableTableAnnotationComposer,
          $$FileCacheTableTableCreateCompanionBuilder,
          $$FileCacheTableTableUpdateCompanionBuilder,
          (
            i2.FileCacheTableData,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i2.$FileCacheTableTable,
              i2.FileCacheTableData
            >,
          ),
          i2.FileCacheTableData,
          i0.PrefetchHooks Function()
        > {
  $$FileCacheTableTableTableManager(
    i0.GeneratedDatabase db,
    i2.$FileCacheTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$FileCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i2.$$FileCacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => i2
              .$$FileCacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<int> id = const i0.Value.absent(),
                i0.Value<String> cache = const i0.Value.absent(),
                i0.Value<String> key = const i0.Value.absent(),
                i0.Value<String> url = const i0.Value.absent(),
                i0.Value<String> relativePath = const i0.Value.absent(),
                i0.Value<DateTime> validTill = const i0.Value.absent(),
                i0.Value<String?> eTag = const i0.Value.absent(),
                i0.Value<int?> length = const i0.Value.absent(),
                i0.Value<DateTime> touched = const i0.Value.absent(),
              }) => i2.FileCacheTableDataCompanion(
                id: id,
                cache: cache,
                key: key,
                url: url,
                relativePath: relativePath,
                validTill: validTill,
                eTag: eTag,
                length: length,
                touched: touched,
              ),
          createCompanionCallback:
              ({
                i0.Value<int> id = const i0.Value.absent(),
                required String cache,
                required String key,
                required String url,
                required String relativePath,
                required DateTime validTill,
                i0.Value<String?> eTag = const i0.Value.absent(),
                i0.Value<int?> length = const i0.Value.absent(),
                required DateTime touched,
              }) => i2.FileCacheTableDataCompanion.insert(
                id: id,
                cache: cache,
                key: key,
                url: url,
                relativePath: relativePath,
                validTill: validTill,
                eTag: eTag,
                length: length,
                touched: touched,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FileCacheTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i2.$FileCacheTableTable,
      i2.FileCacheTableData,
      i2.$$FileCacheTableTableFilterComposer,
      i2.$$FileCacheTableTableOrderingComposer,
      i2.$$FileCacheTableTableAnnotationComposer,
      $$FileCacheTableTableCreateCompanionBuilder,
      $$FileCacheTableTableUpdateCompanionBuilder,
      (
        i2.FileCacheTableData,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i2.$FileCacheTableTable,
          i2.FileCacheTableData
        >,
      ),
      i2.FileCacheTableData,
      i0.PrefetchHooks Function()
    >;
mixin $FileCacheRepositoryMixin on i0.DatabaseAccessor<i1.GeneratedDatabase> {
  i2.$FileCacheTableTable get fileCacheTable => i3.ReadDatabaseContainer(
    attachedDatabase,
  ).resultSet<i2.$FileCacheTableTable>('file_cache_table');
  FileCacheRepositoryManager get managers => FileCacheRepositoryManager(this);
}

class FileCacheRepositoryManager {
  final $FileCacheRepositoryMixin _db;
  FileCacheRepositoryManager(this._db);
  i2.$$FileCacheTableTableTableManager get fileCacheTable =>
      i2.$$FileCacheTableTableTableManager(
        _db.attachedDatabase,
        _db.fileCacheTable,
      );
}

class $FileCacheTableTable extends i4.FileCacheTable
    with i0.TableInfo<$FileCacheTableTable, i2.FileCacheTableData> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileCacheTableTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _cacheMeta = const i0.VerificationMeta(
    'cache',
  );
  @override
  late final i0.GeneratedColumn<String> cache = i0.GeneratedColumn<String>(
    'cache',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _keyMeta = const i0.VerificationMeta('key');
  @override
  late final i0.GeneratedColumn<String> key = i0.GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _urlMeta = const i0.VerificationMeta('url');
  @override
  late final i0.GeneratedColumn<String> url = i0.GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _relativePathMeta =
      const i0.VerificationMeta('relativePath');
  @override
  late final i0.GeneratedColumn<String> relativePath =
      i0.GeneratedColumn<String>(
        'relative_path',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _validTillMeta = const i0.VerificationMeta(
    'validTill',
  );
  @override
  late final i0.GeneratedColumn<DateTime> validTill =
      i0.GeneratedColumn<DateTime>(
        'valid_till',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _eTagMeta = const i0.VerificationMeta(
    'eTag',
  );
  @override
  late final i0.GeneratedColumn<String> eTag = i0.GeneratedColumn<String>(
    'e_tag',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _lengthMeta = const i0.VerificationMeta(
    'length',
  );
  @override
  late final i0.GeneratedColumn<int> length = i0.GeneratedColumn<int>(
    'length',
    aliasedName,
    true,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _touchedMeta = const i0.VerificationMeta(
    'touched',
  );
  @override
  late final i0.GeneratedColumn<DateTime> touched =
      i0.GeneratedColumn<DateTime>(
        'touched',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    cache,
    key,
    url,
    relativePath,
    validTill,
    eTag,
    length,
    touched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_cache_table';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i2.FileCacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cache')) {
      context.handle(
        _cacheMeta,
        cache.isAcceptableOrUnknown(data['cache']!, _cacheMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('valid_till')) {
      context.handle(
        _validTillMeta,
        validTill.isAcceptableOrUnknown(data['valid_till']!, _validTillMeta),
      );
    } else if (isInserting) {
      context.missing(_validTillMeta);
    }
    if (data.containsKey('e_tag')) {
      context.handle(
        _eTagMeta,
        eTag.isAcceptableOrUnknown(data['e_tag']!, _eTagMeta),
      );
    }
    if (data.containsKey('length')) {
      context.handle(
        _lengthMeta,
        length.isAcceptableOrUnknown(data['length']!, _lengthMeta),
      );
    }
    if (data.containsKey('touched')) {
      context.handle(
        _touchedMeta,
        touched.isAcceptableOrUnknown(data['touched']!, _touchedMeta),
      );
    } else if (isInserting) {
      context.missing(_touchedMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i2.FileCacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.FileCacheTableData(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cache: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}cache'],
      )!,
      key: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      url: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      validTill: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}valid_till'],
      )!,
      eTag: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}e_tag'],
      ),
      length: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}length'],
      ),
      touched: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}touched'],
      )!,
    );
  }

  @override
  $FileCacheTableTable createAlias(String alias) {
    return $FileCacheTableTable(attachedDatabase, alias);
  }
}

class FileCacheTableData extends i0.DataClass
    implements i0.Insertable<i2.FileCacheTableData> {
  final int id;
  final String cache;
  final String key;
  final String url;
  final String relativePath;
  final DateTime validTill;
  final String? eTag;
  final int? length;
  final DateTime touched;
  const FileCacheTableData({
    required this.id,
    required this.cache,
    required this.key,
    required this.url,
    required this.relativePath,
    required this.validTill,
    this.eTag,
    this.length,
    required this.touched,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['cache'] = i0.Variable<String>(cache);
    map['key'] = i0.Variable<String>(key);
    map['url'] = i0.Variable<String>(url);
    map['relative_path'] = i0.Variable<String>(relativePath);
    map['valid_till'] = i0.Variable<DateTime>(validTill);
    if (!nullToAbsent || eTag != null) {
      map['e_tag'] = i0.Variable<String>(eTag);
    }
    if (!nullToAbsent || length != null) {
      map['length'] = i0.Variable<int>(length);
    }
    map['touched'] = i0.Variable<DateTime>(touched);
    return map;
  }

  i2.FileCacheTableDataCompanion toCompanion(bool nullToAbsent) {
    return i2.FileCacheTableDataCompanion(
      id: i0.Value(id),
      cache: i0.Value(cache),
      key: i0.Value(key),
      url: i0.Value(url),
      relativePath: i0.Value(relativePath),
      validTill: i0.Value(validTill),
      eTag: eTag == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(eTag),
      length: length == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(length),
      touched: i0.Value(touched),
    );
  }

  factory FileCacheTableData.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return FileCacheTableData(
      id: serializer.fromJson<int>(json['id']),
      cache: serializer.fromJson<String>(json['cache']),
      key: serializer.fromJson<String>(json['key']),
      url: serializer.fromJson<String>(json['url']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      validTill: serializer.fromJson<DateTime>(json['validTill']),
      eTag: serializer.fromJson<String?>(json['eTag']),
      length: serializer.fromJson<int?>(json['length']),
      touched: serializer.fromJson<DateTime>(json['touched']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cache': serializer.toJson<String>(cache),
      'key': serializer.toJson<String>(key),
      'url': serializer.toJson<String>(url),
      'relativePath': serializer.toJson<String>(relativePath),
      'validTill': serializer.toJson<DateTime>(validTill),
      'eTag': serializer.toJson<String?>(eTag),
      'length': serializer.toJson<int?>(length),
      'touched': serializer.toJson<DateTime>(touched),
    };
  }

  i2.FileCacheTableData copyWith({
    int? id,
    String? cache,
    String? key,
    String? url,
    String? relativePath,
    DateTime? validTill,
    i0.Value<String?> eTag = const i0.Value.absent(),
    i0.Value<int?> length = const i0.Value.absent(),
    DateTime? touched,
  }) => i2.FileCacheTableData(
    id: id ?? this.id,
    cache: cache ?? this.cache,
    key: key ?? this.key,
    url: url ?? this.url,
    relativePath: relativePath ?? this.relativePath,
    validTill: validTill ?? this.validTill,
    eTag: eTag.present ? eTag.value : this.eTag,
    length: length.present ? length.value : this.length,
    touched: touched ?? this.touched,
  );
  FileCacheTableData copyWithCompanion(i2.FileCacheTableDataCompanion data) {
    return FileCacheTableData(
      id: data.id.present ? data.id.value : this.id,
      cache: data.cache.present ? data.cache.value : this.cache,
      key: data.key.present ? data.key.value : this.key,
      url: data.url.present ? data.url.value : this.url,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      validTill: data.validTill.present ? data.validTill.value : this.validTill,
      eTag: data.eTag.present ? data.eTag.value : this.eTag,
      length: data.length.present ? data.length.value : this.length,
      touched: data.touched.present ? data.touched.value : this.touched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileCacheTableData(')
          ..write('id: $id, ')
          ..write('cache: $cache, ')
          ..write('key: $key, ')
          ..write('url: $url, ')
          ..write('relativePath: $relativePath, ')
          ..write('validTill: $validTill, ')
          ..write('eTag: $eTag, ')
          ..write('length: $length, ')
          ..write('touched: $touched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cache,
    key,
    url,
    relativePath,
    validTill,
    eTag,
    length,
    touched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.FileCacheTableData &&
          other.id == this.id &&
          other.cache == this.cache &&
          other.key == this.key &&
          other.url == this.url &&
          other.relativePath == this.relativePath &&
          other.validTill == this.validTill &&
          other.eTag == this.eTag &&
          other.length == this.length &&
          other.touched == this.touched);
}

class FileCacheTableDataCompanion
    extends i0.UpdateCompanion<i2.FileCacheTableData> {
  final i0.Value<int> id;
  final i0.Value<String> cache;
  final i0.Value<String> key;
  final i0.Value<String> url;
  final i0.Value<String> relativePath;
  final i0.Value<DateTime> validTill;
  final i0.Value<String?> eTag;
  final i0.Value<int?> length;
  final i0.Value<DateTime> touched;
  const FileCacheTableDataCompanion({
    this.id = const i0.Value.absent(),
    this.cache = const i0.Value.absent(),
    this.key = const i0.Value.absent(),
    this.url = const i0.Value.absent(),
    this.relativePath = const i0.Value.absent(),
    this.validTill = const i0.Value.absent(),
    this.eTag = const i0.Value.absent(),
    this.length = const i0.Value.absent(),
    this.touched = const i0.Value.absent(),
  });
  FileCacheTableDataCompanion.insert({
    this.id = const i0.Value.absent(),
    required String cache,
    required String key,
    required String url,
    required String relativePath,
    required DateTime validTill,
    this.eTag = const i0.Value.absent(),
    this.length = const i0.Value.absent(),
    required DateTime touched,
  }) : cache = i0.Value(cache),
       key = i0.Value(key),
       url = i0.Value(url),
       relativePath = i0.Value(relativePath),
       validTill = i0.Value(validTill),
       touched = i0.Value(touched);
  static i0.Insertable<i2.FileCacheTableData> custom({
    i0.Expression<int>? id,
    i0.Expression<String>? cache,
    i0.Expression<String>? key,
    i0.Expression<String>? url,
    i0.Expression<String>? relativePath,
    i0.Expression<DateTime>? validTill,
    i0.Expression<String>? eTag,
    i0.Expression<int>? length,
    i0.Expression<DateTime>? touched,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (cache != null) 'cache': cache,
      if (key != null) 'key': key,
      if (url != null) 'url': url,
      if (relativePath != null) 'relative_path': relativePath,
      if (validTill != null) 'valid_till': validTill,
      if (eTag != null) 'e_tag': eTag,
      if (length != null) 'length': length,
      if (touched != null) 'touched': touched,
    });
  }

  i2.FileCacheTableDataCompanion copyWith({
    i0.Value<int>? id,
    i0.Value<String>? cache,
    i0.Value<String>? key,
    i0.Value<String>? url,
    i0.Value<String>? relativePath,
    i0.Value<DateTime>? validTill,
    i0.Value<String?>? eTag,
    i0.Value<int?>? length,
    i0.Value<DateTime>? touched,
  }) {
    return i2.FileCacheTableDataCompanion(
      id: id ?? this.id,
      cache: cache ?? this.cache,
      key: key ?? this.key,
      url: url ?? this.url,
      relativePath: relativePath ?? this.relativePath,
      validTill: validTill ?? this.validTill,
      eTag: eTag ?? this.eTag,
      length: length ?? this.length,
      touched: touched ?? this.touched,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (cache.present) {
      map['cache'] = i0.Variable<String>(cache.value);
    }
    if (key.present) {
      map['key'] = i0.Variable<String>(key.value);
    }
    if (url.present) {
      map['url'] = i0.Variable<String>(url.value);
    }
    if (relativePath.present) {
      map['relative_path'] = i0.Variable<String>(relativePath.value);
    }
    if (validTill.present) {
      map['valid_till'] = i0.Variable<DateTime>(validTill.value);
    }
    if (eTag.present) {
      map['e_tag'] = i0.Variable<String>(eTag.value);
    }
    if (length.present) {
      map['length'] = i0.Variable<int>(length.value);
    }
    if (touched.present) {
      map['touched'] = i0.Variable<DateTime>(touched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileCacheTableDataCompanion(')
          ..write('id: $id, ')
          ..write('cache: $cache, ')
          ..write('key: $key, ')
          ..write('url: $url, ')
          ..write('relativePath: $relativePath, ')
          ..write('validTill: $validTill, ')
          ..write('eTag: $eTag, ')
          ..write('length: $length, ')
          ..write('touched: $touched')
          ..write(')'))
        .toString();
  }
}

i0.Index get fileCacheLookup => i0.Index(
  'file_cache_lookup',
  'CREATE UNIQUE INDEX file_cache_lookup ON file_cache_table (cache, "key")',
);
i0.Index get fileCacheTouched => i0.Index(
  'file_cache_touched',
  'CREATE INDEX file_cache_touched ON file_cache_table (cache, touched)',
);
