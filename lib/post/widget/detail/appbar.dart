import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostDetailAppBar({super.key, required this.post});

  final Post post;

  @override
  Size get preferredSize => const Size.fromHeight(defaultAppBarHeight);

  @override
  Widget build(BuildContext context) {
    return DismissFade(
      child: TransparentAppBar(
        child: DefaultAppBar(
          actions: [
            PopupMenuButton<VoidCallback>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) => value(),
              itemBuilder: (context) => [
                ...postMenuPostActions(context, post),
                ...postMenuUserActions(context, post),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
