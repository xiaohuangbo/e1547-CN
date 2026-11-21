import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift_flutter/drift_flutter.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/app/widget/initialize.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

typedef DatabaseInfo = ({String name, String size});

final _logger = Logger('DbManagement');

class DatabaseManagementPage extends StatelessWidget {
  const DatabaseManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TransparentAppBar(
        child: DefaultAppBar(leading: CloseButton()),
      ),
      body: LimitedWidthLayout.builder(
        builder: (context) => ListView(
          padding: defaultActionListPadding.add(
            LimitedWidthLayout.of(context).padding,
          ),
          children: const [
            DatabaseInfoDisplay(),
            SizedBox(height: 64),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                child: Column(
                  children: [DatabaseExportTile(), DatabaseImportTile()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseInfoDisplay extends StatelessWidget {
  const DatabaseInfoDisplay({super.key});

  Future<DatabaseInfo> _loadDatabaseInfo() async {
    final dbPath = await getAppDatabasePath();
    final dbFile = File(dbPath);

    final name = dbPath.split(Platform.pathSeparator).last;
    final size = dbFile.existsSync()
        ? filesize(dbFile.lengthSync())
        : 'Unknown';

    return (name: name, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return SubFuture<DatabaseInfo>(
      create: _loadDatabaseInfo,
      builder: (context, snapshot) {
        final dbInfo =
            snapshot.data ??
            (snapshot.error != null
                ? (name: '加载数据库出错', size: '无')
                : (name: 'Loading...', size: '...'));

        return Center(
          child: Column(
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.primary,
                radius: 64,
                child: const Icon(Icons.storage, size: 64),
              ),
              const SizedBox(height: 16),
              Text(dbInfo.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Dimmed(
                child: Text(
                  dbInfo.size,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class DatabaseExportTile extends StatelessWidget {
  const DatabaseExportTile({super.key});

  Future<void> _exportDatabase(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: HexagonalLoadingIndicator(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('正在导出数据库…'),
              ),
            ],
          ),
        ),
      );

      final dbPath = await getAppDatabasePath();
      final dbFile = File(dbPath);
      if (!dbFile.existsSync()) {
        throw Exception('数据库文件不存在');
      }

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: '导出数据库',
        fileName: 'e1547_database_backup.db',
        type: FileType.custom,
        allowedExtensions: ['db'],
        bytes: await dbFile.readAsBytes(),
      );

      navigator.pop();
      if (outputFile != null) {
        messenger.showSnackBar(const SnackBar(content: Text('数据库导出成功')));
      }
    } on Exception catch (e) {
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('导出失败')));
      _logger.warn('数据库导出失败', null, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_download),
      title: const Text('导出'),
      subtitle: const Text('保存数据库的备份副本', overflow: TextOverflow.ellipsis),
      onTap: () => _exportDatabase(context),
    );
  }
}

class DatabaseImportTile extends StatelessWidget {
  const DatabaseImportTile({super.key});

  Future<void> _importDatabase(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await _showImportWarning(context);
    if (!confirmed) return;

    try {
      // iOS needs custom file type declarations but we are lazy so we pick any
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: '导入数据库',
        type: Platform.isIOS ? FileType.any : FileType.custom,
        allowedExtensions: Platform.isIOS ? null : ['db'],
      );

      final path = result?.files.single.path;

      if (path == null) return;
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: HexagonalLoadingIndicator(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('正在导入数据库…'),
              ),
            ],
          ),
        ),
      );

      try {
        driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
        final importDb = AppDatabase(
          driftDatabase(
            name: 'import',
            native: DriftNativeOptions(databasePath: () async => path),
          ),
        );
        await importDb.customSelect('SELECT 1').get();
        await importDb.close();
      } on Exception catch (e) {
        navigator.pop();
        messenger.showSnackBar(SnackBar(content: Text('无效的数据库文件：$e')));
        _logger.warn('数据库校验失败', null, e);
        return;
      } finally {
        driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
      }

      final importFile = File(path);
      final dbPath = await getAppDatabasePath();
      final newDbPath = '$dbPath.new';
      await importFile.copy(newDbPath);

      navigator.pop();
      if (context.mounted) {
        await _showRestartDialog(context);
      }
    } on Exception catch (e) {
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text('导入失败：$e')));
    }
  }

  Future<bool> _showImportWarning(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AlertDialog(
          title: const Text('导入数据库'),
          content: const Text(
            '这将替换您当前的数据库。\n'
            '所有数据都将丢失，且无法恢复！',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('导入'),
            ),
          ],
        ),
      ),
    ),
  ).then((value) => value ?? false);

  Future<void> _showRestartDialog(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('需要重启'),
      content: const Text('应用需要重启才能应用更改。'),
      actions: [
        TextButton(
          onPressed: () => AppInit.of(context).reinitialize(),
          child: const Text('立即重启'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_upload),
      title: const Text('导入'),
      subtitle: const Text('用导入的数据库替换当前数据库', overflow: TextOverflow.ellipsis),
      onTap: () => _importDatabase(context),
    );
  }
}
