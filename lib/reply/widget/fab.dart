import 'package:e1547/reply/reply.dart';
import 'package:flutter/material.dart';

class ReplyCreateFab extends StatelessWidget {
  const ReplyCreateFab({super.key, required this.topicId});

  final int topicId;

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    heroTag: 'float',
    backgroundColor: Theme.of(context).cardColor,
    child: Icon(Icons.reply, color: Theme.of(context).iconTheme.color),
    onPressed: () => writeReply(context: context, topicId: topicId),
  );
}
