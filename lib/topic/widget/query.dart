import 'package:e1547/client/client.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicPageQueryBuilder extends StatelessWidget {
  const TopicPageQueryBuilder({super.key, required this.builder});

  final PageQueryBuilderCallback<Topic, int> builder;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<TopicParamsController>();
    final query = client.topics.usePage(query: controller.value.toQuery());

    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.topics.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter(
        state: state,
        builder: (context, state) => builder(context, state, query),
      ),
    );
  }
}
