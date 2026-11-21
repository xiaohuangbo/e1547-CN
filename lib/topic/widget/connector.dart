import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicHistoryConnector extends StatelessWidget {
  const TopicHistoryConnector({
    super.key,
    required this.topic,
    required this.child,
  });

  final Topic topic;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<ReplyParamsController>();
    final query = client.replies.usePage(query: controller.value.toQuery());

    return QueryHistoryConnector<InfiniteQueryStatus<List<int>, int>>(
      query: query,
      getEntry: (context, state) {
        final data = state.data;
        if (data == null || data.pages.isEmpty) return null;
        final replies = data.pages
            .expand((p) => p)
            .map((id) => client.replies.replyCache.get(id))
            .whereType<Reply>()
            .toList();
        return TopicHistoryRequest.item(
          topic: topic,
          replies: replies.isEmpty ? null : replies,
        );
      },
      child: child,
    );
  }
}

class TopicsHistoryConnector extends StatelessWidget {
  const TopicsHistoryConnector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<TopicParamsController>();
    final query = client.topics.usePage(query: controller.value.toQuery());

    return QueryHistoryConnector<InfiniteQueryStatus<List<int>, int>>(
      query: query,
      getEntry: (context, state) {
        final data = state.data;
        if (data == null || data.pages.isEmpty) return null;
        final topics = data.pages
            .expand((p) => p)
            .map((id) => client.topics.topicCache.get(id))
            .whereType<Topic>()
            .toList();
        return TopicHistoryRequest.search(
          query: controller.value.toQuery(),
          topics: topics,
        );
      },
      child: child,
    );
  }
}
