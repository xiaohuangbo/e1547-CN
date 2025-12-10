import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentCreateFab extends StatelessWidget {
  const CommentCreateFab({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentController>(
      builder: (context, controller, child) => FloatingActionButton(
        heroTag: 'float',
        backgroundColor: Theme.of(context).cardColor,
        child: Icon(Icons.comment, color: Theme.of(context).iconTheme.color),
        onPressed: () =>
            writeComment(context: context, postId: postId).then((value) {
              if (value) {
                controller.refresh(force: true);
              }
            }),
      ),
    );
  }
}
