import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class FollowConnector extends StatelessWidget {
  const FollowConnector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return SubEffect(
      effect: () {
        client.followServer.sync();
        return null;
      },
      keys: [client],
      child: SubStream<List<Follow>>(
        create: () => client.follows.all().streamed,
        keys: [client],
        listener: (event) => client.followServer.sync(),
        builder: (context, _) => child,
      ),
    );
  }
}
