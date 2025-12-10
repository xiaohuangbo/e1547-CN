import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/pool/pool.dart';
import 'package:flutter/material.dart';

class PoolLoadingPage extends StatefulWidget {
  const PoolLoadingPage(this.id, {super.key, this.orderByOldest});

  final int id;
  final bool? orderByOldest;

  @override
  State<PoolLoadingPage> createState() => _PoolLoadingPageState();
}

class _PoolLoadingPageState extends State<PoolLoadingPage> {
  late Future<Pool> pool = context.read<Client>().pools.get(id: widget.id);

  @override
  Widget build(BuildContext context) {
    return FutureLoadingPage<Pool>(
      future: pool,
      builder: (context, value) =>
          PoolPage(pool: value, orderByOldest: widget.orderByOldest),
      title: Text('池 #${widget.id}'),
      onError: const Text('加载池失败'),
      onEmpty: const Text('未找到池'),
    );
  }
}
