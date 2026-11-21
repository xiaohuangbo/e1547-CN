import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PoolPageQueryBuilder extends StatefulWidget {
  const PoolPageQueryBuilder({super.key, required this.builder});

  final PageQueryBuilderCallback<Pool, int> builder;

  @override
  State<PoolPageQueryBuilder> createState() => _PoolPageQueryBuilderState();
}

class _PoolPageQueryBuilderState extends State<PoolPageQueryBuilder> {
  final Object _filterKey = Object();
  FilterController<Post>? _filter;

  @override
  void dispose() {
    _filter?.untrack(_filterKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<PoolParamsController>();
    final query = client.pools.usePage(query: controller.value.toQuery());
    final filter = context.watch<FilterController<Post>?>();
    if (!identical(_filter, filter)) {
      _filter?.untrack(_filterKey);
      _filter = filter;
    }

    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.pools.useGet(id: id, vendored: true),
      builder: (context, state) {
        for (final pagePools in state.data?.pages ?? const <List<Pool>>[]) {
          final thumbs = pagePools
              .map((p) => p.postIds.isEmpty ? null : p.postIds.first)
              .whereType<int>()
              .toList();
          if (thumbs.isNotEmpty) {
            client.posts.useByIds(ids: thumbs).fetch();
          }
        }
        if (filter != null) {
          final thumbnails = (state.data?.pages.expand((p) => p) ?? const [])
              .map(
                (p) => p.postIds.isEmpty
                    ? null
                    : client.posts.postCache.get(p.postIds.first),
              )
              .whereType<Post>()
              .toList();
          filter.track(_filterKey, thumbnails);
        }
        return QueryFilter<Pool, int>(
          state: state,
          builder: (context, state) => widget.builder(context, state, query),
        );
      },
    );
  }
}
