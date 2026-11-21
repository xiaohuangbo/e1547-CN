import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';

class UserHistoryConnector extends StatelessWidget {
  const UserHistoryConnector({
    super.key,
    required this.user,
    required this.child,
  });

  final User user;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final avatarId = user.avatarId;
    if (avatarId == null) {
      return ItemHistoryConnector<User>(
        item: user,
        getEntry: (context, item) => UserHistoryRequest.item(user: item),
        child: child,
      );
    }
    final query = client.posts.useGet(id: avatarId);
    return QueryHistoryConnector<QueryStatus<Post>>(
      query: query,
      getEntry: (context, state) {
        if (state is! QuerySuccess<Post>) {
          return UserHistoryRequest.item(user: user);
        }
        return UserHistoryRequest.item(user: user, avatar: state.data);
      },
      child: child,
    );
  }
}
