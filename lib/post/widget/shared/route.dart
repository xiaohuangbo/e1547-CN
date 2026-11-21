import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostRouteScope extends StatelessWidget {
  const PostRouteScope({
    super.key,
    required this.params,
    required this.filter,
    required this.child,
  });

  final PostParamsController? params;
  final PostFilter? filter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    final filter = this.filter;
    if (filter != null) {
      result = FilterControllerProvider<PostFilter, Post>.value(
        value: filter,
        child: result,
      );
    }
    final params = this.params;
    if (params != null) {
      result = ChangeNotifierProvider<PostParamsController>.value(
        value: params,
        child: result,
      );
    }
    return result;
  }
}
