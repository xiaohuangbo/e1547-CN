import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentListDrawer extends StatelessWidget {
  const CommentListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentController>(
      builder: (context, controller, child) => ContextDrawer(
        title: const Text('Comments'),
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => SwitchListTile(
              secondary: const Icon(Icons.sort),
              title: const Text('Comment order'),
              subtitle: Text(
                controller.orderByOldest ? 'oldest first' : 'newest first',
              ),
              value: controller.orderByOldest,
              onChanged: (value) {
                controller.orderByOldest = value;
                Scaffold.of(context).closeEndDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
