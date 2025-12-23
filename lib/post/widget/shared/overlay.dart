import 'package:e1547/app/app.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';

class PostImageOverlay extends StatelessWidget {
  const PostImageOverlay({
    super.key,
    required this.post,
    required this.builder,
  });

  final Post post;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    PostController? controller = context.read<PostController?>();

    Widget centerText(String text) {
      return Center(child: Text(text, textAlign: TextAlign.center));
    }

    if (post.isDeleted) {
      return centerText('帖子已被删除');
    }
    if (post.file == null) {
      return const IconMessage(
        title: Text('图片不可用'),
        icon: Icon(Icons.image_not_supported_outlined),
      );
    }
    if ((controller?.isDenied(post) ?? false) && !post.isFavorited) {
      return centerText('帖子已被加入黑名单');
    }

    if (post.type == PostType.unsupported) {
      return IconMessage(
        title: Text('不支持 ${post.ext} 文件'),
        icon: const Icon(Icons.image_not_supported_outlined),
        action: Padding(
          padding: const EdgeInsets.all(4),
          child: TextButton(
            onPressed: () async => launch(post.file!),
            child: const Text('打开'),
          ),
        ),
      );
    }

    return builder(context);
  }
}
