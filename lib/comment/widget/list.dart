import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentController>(
      builder: (context, controller, child) => PullToRefresh(
        onRefresh: () => controller.refresh(force: true, background: true),
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverPadding(
              padding: defaultActionListPadding,
              sliver: const SliverCommentList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverCommentList extends StatelessWidget {
  const SliverCommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentController>(
      builder: (context, controller, child) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) => PagedSliverList<int, Comment>(
          state: controller.state,
          fetchNextPage: controller.getNextPage,
          builderDelegate: defaultPagedChildBuilderDelegate(
            onRetry: controller.getNextPage,
            itemBuilder: (context, item, index) => CommentTile(comment: item),
            onEmpty: const Text('No comments'),
            onError: const Text('Failed to load comments'),
          ),
        ),
      ),
    );
  }
}
