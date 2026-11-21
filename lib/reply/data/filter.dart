import 'package:e1547/client/client.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/reply/reply.dart';

class ReplyFilter extends FilterController<Reply> {
  ReplyFilter(this.client) {
    client.traits.addListener(notifyListeners);
  }

  final Client client;

  @override
  Object idOf(Reply item) => item.id;

  @override
  bool filter(Reply item) =>
      !client.traits.value.denylist.contains('user:${item.creatorId}');

  @override
  void dispose() {
    client.traits.removeListener(notifyListeners);
    super.dispose();
  }
}
