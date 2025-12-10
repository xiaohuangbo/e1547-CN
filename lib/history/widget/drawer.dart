import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/interface/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:intl/intl.dart';

class HistoryEnableTile extends StatelessWidget {
  const HistoryEnableTile({super.key});

  @override
  Widget build(BuildContext context) {
    Client client = context.watch<Client>();
    return SubStream<int>(
      create: () => client.histories.count().asStream(),
      keys: [client],
      builder: (context, countSnapshot) => SubStream<bool>(
        initialData: client.histories.enabled,
        create: () => client.histories.enabledStream,
        builder: (context, enabledSnapshot) => SwitchListTile(
          title: const Text('已启用'),
          subtitle: Text('${countSnapshot.data ?? 0} 个页面已访问'),
          secondary: const Icon(Icons.history),
          value: enabledSnapshot.data!,
          onChanged: (value) => client.histories.enabled = value,
        ),
      ),
    );
  }
}

class HistoryLimitTile extends StatelessWidget {
  const HistoryLimitTile({super.key});

  @override
  Widget build(BuildContext context) {
    Client client = context.watch<Client>();
    return SubStream<bool>(
      create: () => client.histories.trimmingStream,
      initialData: client.histories.trimming,
      builder: (context, snapshot) => SwitchListTile(
        value: snapshot.data!,
        onChanged: (value) {
          if (value) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('历史记录限制'),
                content: Text(
                  '启用历史记录限制意味着将自动删除超过 ${NumberFormat.compact().format(client.histories.trimAmount)} 条的所有历史记录条目以及所有早于 ${client.histories.trimAge.inDays ~/ 30} 个月的条目。',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      client.histories.trimming = value;
                      Navigator.of(context).maybePop();
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
            );
          } else {
            client.histories.trimming = value;
          }
        },
        secondary: Icon(
          snapshot.data! ? Icons.hourglass_bottom : Icons.hourglass_empty,
        ),
        title: const Text('限制历史记录'),
        subtitle: snapshot.data!
            ? Text(
                '限制为新于 ${client.histories.trimAge.inDays ~/ 30} 个月或少于 ${NumberFormat.compact().format(client.histories.trimAmount)} 个条目。',
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
    return Consumer<HistoryController>(
      builder: (context, controller, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: ListTileHeader(title: '条目'),
          ),
          for (final filter in HistoryCategory.values)
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                HistoryQuery query = HistoryQuery.from(controller.search);
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CheckboxListTile(
                    secondary: filter.icon,
                    title: Text(filter.title),
                    value: query.categories?.contains(filter) ?? true,
                    onChanged: (value) {
                      if (value == null) return;
                      Set<HistoryCategory> filters =
                          query.categories ?? HistoryCategory.values.toSet();
                      if (value) {
                        filters.add(filter);
                      } else {
                        filters.remove(filter);
                      }
                      controller.search = query.copy()..categories = filters;
                    },
                  ),
                );
              },
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
    return Consumer<HistoryController>(
      builder: (context, controller, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: ListTileHeader(title: '类型'),
          ),
          for (final filter in HistoryType.values)
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                HistoryQuery query = HistoryQuery.from(controller.search);
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CheckboxListTile(
                    secondary: filter.icon,
                    title: Text(filter.title),
                    value: query.types?.contains(filter) ?? true,
                    onChanged: (value) {
                      if (value == null) return;
                      Set<HistoryType> filters =
                          query.types ?? HistoryType.values.toSet();
                      if (value) {
                        filters.add(filter);
                      } else {
                        filters.remove(filter);
                      }
                      controller.search = query.copy()..types = filters;
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
