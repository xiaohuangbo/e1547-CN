import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentLoadingPage extends StatelessWidget {
  const CommentLoadingPage(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return QueryBuilder(
      query: client.comments.useGet(id: id),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading || state.isInitial,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(leading: const CloseButton(), title: Text('评论 #$id')),
          body: child(context),
        ),
        skeleton: (context) =>
            PostCommentsPage(postId: const CommentGhost().postId),
        onError: const Text('加载评论失败'),
        onEmpty: const Text('未找到评论'),
        child: (context) => PostCommentsPage(postId: state.data!.postId),
      ),
    );
  }
}
