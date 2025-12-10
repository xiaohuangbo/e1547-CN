import 'package:e1547/interface/interface.dart';
import 'package:e1547/logs/logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogSelectionAppBar extends StatelessWidget with AppBarBuilderWidget {
  const LogSelectionAppBar({super.key, required this.child});

  @override
  final PreferredSizeWidget child;

  @override
  Widget build(BuildContext context) {
    return SelectionAppBar<LogString>(
      child: child,
      titleBuilder: (context, data) => data.selections.length == 1
          ? Text(data.selections.first.body, maxLines: 1)
          : Text('${data.selections.length} 条日志'),
      actionBuilder: (context, data) => [
        IconButton(
          tooltip: '复制',
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: data.selections.map((e) => e.toString()).join('\n'),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('已复制到剪贴板'),
              ),
            );
            data.onChanged({});
          },
        ),
      ],
    );
  }
}

class LogFileSelectionAppBar extends StatelessWidget with AppBarBuilderWidget {
  const LogFileSelectionAppBar({super.key, required this.child, this.onDelete});

  @override
  final PreferredSizeWidget child;
  final ValueSetter<List<LogFileInfo>>? onDelete;

  @override
  Widget build(BuildContext context) {
    return SelectionAppBar<LogFileInfo>(
      child: child,
      titleBuilder: (context, data) => data.selections.length == 1
          ? Text('日志 - ${data.selections.first.date}')
          : Text('${data.selections.length} 个日志文件'),
      actionBuilder: (context, data) => [
        if (onDelete != null)
          IconButton(
            tooltip: '删除',
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => LogFileDeleteConfirmation(
                files: data.selections.toList(),
                onConfirm: () {
                  onDelete?.call(data.selections.toList());
                  data.onChanged({});
                },
              ),
            ),
          ),
      ],
    );
  }
}

class LogFileDeleteConfirmation extends StatelessWidget {
  const LogFileDeleteConfirmation({
    super.key,
    required this.files,
    required this.onConfirm,
  });

  final List<LogFileInfo> files;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('删除 ${files.length} 个日志文件？'),
      content: const Text('此操作无法撤消。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop();
          },
          child: const Text('删除'),
        ),
      ],
    );
  }
}
