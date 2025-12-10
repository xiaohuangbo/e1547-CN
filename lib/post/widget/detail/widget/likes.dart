import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class LikeDisplay extends StatelessWidget {
  const LikeDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    Client client = context.watch<Client>();
    PostController controller = context.watch<PostController>();
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    bool canVote = client.hasLogin;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VoteDisplay(
              status: post.vote.status,
              score: post.vote.score,
              onUpvote: canVote
                  ? (isLiked) async {
                      controller
                          .vote(post: post, upvote: true, replace: !isLiked)
                          .then((value) {
                            if (!value) {
                              messenger.showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text(
                                    '点赞帖子 #${post.id} 失败',
                                  ),
                                ),
                              );
                            }
                          });
                      return !isLiked;
                    }
                  : null,
              onDownvote: canVote
                  ? (isLiked) async {
                      controller
                          .vote(post: post, upvote: false, replace: !isLiked)
                          .then((value) {
                            if (!value) {
                              messenger.showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text(
                                    '点踩帖子 #${post.id} 失败',
                                  ),
                                ),
                              );
                            }
                          });
                      return !isLiked;
                    }
                  : null,
            ),
            Row(
              children: [
                Text(post.favCount.toString()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.favorite,
                    color: post.isFavorited
                        ? Colors.pinkAccent
                        : IconTheme.of(context).color,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {},
      child: LikeButton(
        isLiked: post.isFavorited,
        circleColor: const CircleColor(start: Colors.pink, end: Colors.red),
        bubblesColor: const BubblesColor(
          dotPrimaryColor: Colors.pink,
          dotSecondaryColor: Colors.red,
        ),
        likeBuilder: (isLiked) => Icon(
          Icons.favorite,
          color: isLiked ? Colors.pinkAccent : IconTheme.of(context).color,
        ),
        onTap: (isLiked) async {
          PostController controller = context.read<PostController>();
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
          if (isLiked) {
            controller.unfav(post).then((value) {
              if (!value) {
                messenger.showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(
                      '从收藏夹中移除帖子 #${post.id} 失败',
                    ),
                  ),
                );
              }
            });
            return false;
          } else {
            bool upvote = context.read<Settings>().upvoteFavs.value;
            controller.fav(post).then((value) {
              if (value) {
                if (upvote) {
                  controller.vote(
                    post: controller.postById(post.id)!,
                    upvote: true,
                    replace: true,
                  );
                }
              } else {
                messenger.showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(
                      '将帖子 #${post.id} 添加到收藏夹失败',
                    ),
                  ),
                );
              }
            });
            return true;
          }
        },
      ),
    );
  }
}
