import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:intl/intl.dart';

class HistoryEnableTile extends StatelessWidget {
  const HistoryEnableTile({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return SubStream<int>(
      create: () => client.histories.count().streamed,
      keys: [client],
      builder: (context, countSnapshot) => ValueListenableBuilder(
        valueListenable: client.traits,
        builder: (context, traits, child) => SwitchListTile(
          title: const Text('已启用'),
          subtitle: Text('${countSnapshot.data ?? 0} 个页面已访问'),
          secondary: const Icon(Icons.history),
          value: traits.writeHistory ?? true,
          onChanged: (value) => client.traits.value = client.traits.value
              .copyWith(writeHistory: value),
        ),
      ),
    );
  }
}

class HistoryClearTile extends StatelessWidget {
  const HistoryClearTile({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return ListTile(
      title: const Text('清除历史'),
      subtitle: const Text('删除所有条目'),
      leading: const Icon(Icons.clear_all),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('清除历史记录？'),
          content: const Text('所有历史记录都将被永久删除，此操作无法撤消。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                client.histories.useClear().mutate();
              },
              child: const Text('清除'),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryLimitTile extends StatelessWidget {
  const HistoryLimitTile({super.key});

  static const int trimAmount = 5000;
  static const Duration trimAge = Duration(days: 30 * 3);

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return ValueListenableBuilder(
      valueListenable: client.traits,
      builder: (context, traits, child) => SwitchListTile(
        value: traits.trimHistory ?? false,
        onChanged: (value) {
          if (value) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('历史记录上限'),
                content: Text(
                  '启用历史记录上限后，超过 ${NumberFormat.compact().format(trimAmount)} '
                  '条的以及早于 ${trimAge.inDays ~/ 30} 个月的所有条目都会被自动删除。',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      client.traits.value = client.traits.value.copyWith(
                        trimHistory: value,
                      );
                      Navigator.of(context).maybePop();
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
            );
          } else {
            client.traits.value = client.traits.value.copyWith(
              trimHistory: value,
            );
          }
        },
        secondary: Icon(
          (traits.trimHistory ?? false)
              ? Icons.hourglass_bottom
              : Icons.hourglass_empty,
        ),
        title: const Text('限制历史记录'),
        subtitle: (traits.trimHistory ?? false)
            ? Text(
                '仅保留新于 ${trimAge.inDays ~/ 30} 个月或少于 ${NumberFormat.compact().format(trimAmount)} 个条目的记录。',
              )
            : const Text('历史记录是无限的'),
      ),
    );
  }
}

class HistoryCategoryFilterTile extends StatelessWidget {
  const HistoryCategoryFilterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryParamsController>(
      builder: (context, controller, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: SectionHeader(
              indent: SectionHeader.listTileIndent,
              title: '条目',
            ),
          ),
          for (final filter in HistoryCategory.values)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CheckboxListTile(
                secondary: filter.icon,
                title: Text(filter.title),
                value: controller.value.categories?.contains(filter) ?? true,
                onChanged: (value) {
                  if (value == null) return;
                  controller.update((p) {
                    final filters =
                        p.categories?.toSet() ?? HistoryCategory.values.toSet();
                    if (value) {
                      filters.add(filter);
                    } else {
                      filters.remove(filter);
                    }
                    return p.copyWith(categories: filters);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class HistoryTypeFilterTile extends StatelessWidget {
  const HistoryTypeFilterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryParamsController>(
      builder: (context, controller, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: SectionHeader(
              indent: SectionHeader.listTileIndent,
              title: '类型',
            ),
          ),
          for (final filter in HistoryType.values)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CheckboxListTile(
                secondary: filter.icon,
                title: Text(filter.title),
                value: controller.value.types?.contains(filter) ?? true,
                onChanged: (value) {
                  if (value == null) return;
                  controller.update((p) {
                    final filters =
                        p.types?.toSet() ?? HistoryType.values.toSet();
                    if (value) {
                      filters.add(filter);
                    } else {
                      filters.remove(filter);
                    }
                    return p.copyWith(types: filters);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
