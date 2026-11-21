import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentListDrawer extends StatelessWidget {
  const CommentListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CommentParamsController>();
    return ContextDrawer(
      title: const Text('评论'),
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.sort),
          title: const Text('评论排序'),
          subtitle: Text(switch (controller.value.order) {
            CommentOrder.oldest => 'oldest first',
            CommentOrder.newest => 'newest first',
          }),
          value: controller.value.order == CommentOrder.oldest,
          onChanged: (value) {
            controller.update(
              (p) => p.copyWith(
                order: value ? CommentOrder.oldest : CommentOrder.newest,
              ),
            );
            Scaffold.of(context).closeEndDrawer();
          },
        ),
      ],
    );
  }
}
