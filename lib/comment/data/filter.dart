import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/query/query.dart';

class CommentFilter extends FilterController<Comment> {
  CommentFilter(this.client) {
    client.traits.addListener(notifyListeners);
  }

  final Client client;

  @override
  Object idOf(Comment item) => item.id;

  @override
  bool filter(Comment item) =>
      !client.traits.value.denylist.contains('user:${item.creatorId}');

  @override
  void dispose() {
    client.traits.removeListener(notifyListeners);
    super.dispose();
  }
}
