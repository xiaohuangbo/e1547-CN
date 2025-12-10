import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostCommentsPage extends StatelessWidget {
  const PostCommentsPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return CommentProvider(
      postId: postId,
      child: AdaptiveScaffold(
        appBar: DefaultAppBar(
          title: Text('#$postId comments'),
          actions: const [ContextDrawerButton()],
        ),
        floatingActionButton: client.hasLogin
            ? CommentCreateFab(postId: postId)
            : null,
        endDrawer: const CommentListDrawer(),
        body: const CommentList(),
      ),
    );
  }
}
