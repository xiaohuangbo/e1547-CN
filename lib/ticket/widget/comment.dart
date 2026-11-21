import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';

class CommentReportScreen extends StatelessWidget {
  const CommentReportScreen({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return ReasonReportScreen(
      title: Text('评论 #${comment.id}'),
      onReport: (reason) => validateCall(
        () => context.read<Client>().tickets.create(
          type: TicketType.comment,
          item: comment.id,
          reason: reason,
        ),
      ),
      onSuccess: '已举报评论 #${comment.id}',
      onFailure: '举报评论 #${comment.id} 失败',
      previewBuilder: (context, isLoading) => Card(
        clipBehavior: Clip.antiAlias,
        child: ReportLoadingOverlay(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CommentTile(comment: comment, hasActions: false),
          ),
        ),
      ),
    );
  }
}
