import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class FollowPageQueryBuilder extends StatelessWidget {
  const FollowPageQueryBuilder({super.key, required this.builder});

  final PageQueryBuilderCallback<Follow, int> builder;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<FollowParamsController>();
    final query = client.follows.usePage(query: controller.value.toQuery());

    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.follows.useGet(id: id, vendored: true),
      builder: (context, state) => builder(context, state, query),
    );
  }
}
