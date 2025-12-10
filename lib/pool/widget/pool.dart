import 'package:e1547/history/history.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PoolPage extends StatefulWidget {
  const PoolPage({super.key, required this.pool, this.orderByOldest});

  final Pool pool;
  final bool? orderByOldest;

  @override
  State<PoolPage> createState() => _PoolPageState();
}

class _PoolPageState extends State<PoolPage> {
  bool readerMode = true;

  @override
  Widget build(BuildContext context) {
    return PostProvider.builder(
      create: (context, client) => PoolPostController(
        client: client,
        id: widget.pool.id,
        orderByOldest: widget.orderByOldest ?? true,
      ),
      child: Consumer<PostController>(
        builder: (context, controller, child) => ControllerHistoryConnector(
          controller: controller,
          addToHistory: (context, client, data) {
            client.histories.addPool(
              pool: widget.pool,
              posts: controller.items,
            );
          },
          child: PostsPage(
            controller: controller,
            displayType: readerMode ? PostDisplayType.comic : null,
            appBar: DefaultAppBar(
              title: Text(tagToName(widget.pool.name)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: '信息',
                  onPressed: () =>
                      showPoolPrompt(context: context, pool: widget.pool),
                ),
                const ContextDrawerButton(),
              ],
            ),
            drawerActions: [
              Builder(
                builder: (context) => PoolReaderSwitch(
                  readerMode: readerMode,
                  onChange: (value) {
                    setState(() => readerMode = value);
                    Scaffold.of(context).closeEndDrawer();
                  },
                ),
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) => PoolOrderSwitch(
                  oldestFirst: controller.orderPools,
                  onChange: (value) {
                    controller.orderPools = value;
                    Scaffold.of(context).closeEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PoolOrderSwitch extends StatelessWidget {
  const PoolOrderSwitch({
    super.key,
    required this.oldestFirst,
    required this.onChange,
  });

  final bool oldestFirst;
  final ValueChanged<bool> onChange;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.sort),
      title: const Text('池顺序'),
      subtitle: Text(oldestFirst ? '最旧的在前' : '最新的在前'),
      value: oldestFirst,
      onChanged: onChange,
    );
  }
}

class PoolReaderSwitch extends StatelessWidget {
  const PoolReaderSwitch({
    super.key,
    required this.readerMode,
    required this.onChange,
  });

  final bool readerMode;
  final ValueChanged<bool> onChange;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.auto_stories),
      title: const Text('池阅读器模式'),
      subtitle: Text(readerMode ? '大图' : '普通网格'),
      value: readerMode,
      onChanged: onChange,
    );
  }
}
