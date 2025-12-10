import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class ReplyListDrawer extends StatelessWidget {
  const ReplyListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReplyController>(
      builder: (context, controller, child) => ContextDrawer(
        title: const Text('Replies'),
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => SwitchListTile(
              secondary: const Icon(Icons.sort),
              title: const Text('Reply order'),
              subtitle: Text(
                controller.orderByOldest ? 'oldest first' : 'newest first',
              ),
              value: controller.orderByOldest,
              onChanged: (value) {
                controller.orderByOldest = value;
                Navigator.of(context).maybePop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
