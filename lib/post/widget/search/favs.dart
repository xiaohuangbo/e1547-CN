import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return RouterDrawerEntry<FavPage>(
      child: client.identity.username == null
          ? const AdaptiveScaffold(
              appBar: DefaultAppBar(title: Text('收藏')),
              body: IconMessage(
                icon: Icon(Icons.person_search),
                title: Text('匿名用户无法使用收藏功能'),
              ),
            )
          : FilterControllerProvider<PostFilter, Post>(
              create: (_) => FavoritePostFilter(client),
              keys: (_) => [client],
              child: ChangeNotifierProvider(
                create: (_) => PostParamsController(
                  initial: PostParams(tags: 'fav:${client.identity.username}'),
                ),
                child: PostPageHistoryConnector(
                  child: PostPageQueryBuilder(
                    builder: (context, state, query) => SelectionLayout<Post>(
                      items: state.data?.pages.expand((p) => p).toList(),
                      child: AdaptiveScaffold(
                        appBar: const PostSelectionAppBar(
                          child: PostPageAppBar(),
                        ),
                        floatingActionButton: const PostsPageFab(),
                        drawer: const RouterDrawer(),
                        endDrawer: ContextDrawer(
                          title: const Text('帖子'),
                          children: [
                            const FavoriteOrderSwitch(),
                            const Divider(),
                            const DrawerDenySwitch(),
                            DrawerTagCounter(
                              posts: state.data?.pages
                                  .expand((p) => p)
                                  .toList(),
                              error: state.error,
                            ),
                          ],
                        ),
                        body: LimitedWidthLayout(
                          child: ListenableBuilder(
                            listenable: context.watch<Settings>().tileSize,
                            builder: (context, child) => TileLayout(
                              tileSize: context
                                  .watch<Settings>()
                                  .tileSize
                                  .value,
                              child: const PostList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class FavoriteOrderSwitch extends StatelessWidget {
  const FavoriteOrderSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();
    final tags = TagMap(controller.value.tags);
    final order = tags['order'];
    final addedOrder = order == null || order == 'fav';
    return SwitchListTile(
      secondary: const Icon(Icons.sort),
      title: const Text('收藏排序'),
      subtitle: Text(addedOrder ? '按添加顺序' : '按 ID 顺序'),
      value: addedOrder,
      onChanged: (value) {
        final next = TagMap(controller.value.tags);
        if (value) {
          next.remove('order');
        } else {
          next['order'] = PostOrder.newest.value;
        }
        controller.update((p) => p.copyWith(tags: next.toString()));
      },
    );
  }
}
