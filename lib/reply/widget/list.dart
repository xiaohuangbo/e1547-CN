import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class ReplyList extends StatelessWidget {
  const ReplyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReplyController>(
      builder: (context, controller, child) => PullToRefresh(
        onRefresh: () => controller.refresh(force: true, background: true),
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverPadding(
              padding: defaultActionListPadding,
              sliver: const SliverReplyList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverReplyList extends StatelessWidget {
  const SliverReplyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReplyController>(
      builder: (context, controller, child) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) => PagedSliverList<int, Reply>(
          state: controller.state,
          fetchNextPage: controller.getNextPage,
          builderDelegate: defaultPagedChildBuilderDelegate(
            onRetry: controller.getNextPage,
            itemBuilder: (context, item, index) => ReplyTile(reply: item),
            onEmpty: const IconMessage(
              icon: Icon(Icons.clear),
              title: Text('No replies'),
            ),
            onError: const IconMessage(
              icon: Icon(Icons.warning_amber_outlined),
              title: Text('Failed to load replies'),
            ),
          ),
        ),
      ),
    );
  }
}
