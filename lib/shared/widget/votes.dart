import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:like_button/like_button.dart';

part 'votes.freezed.dart';
part 'votes.g.dart';

typedef VoteRequest = ({bool upvote, bool replace});

({int score, int? vote}) applyVote({
  required int score,
  required int? vote,
  required bool upvote,
  required bool replace,
}) {
  final current = vote ?? 0;
  final target = upvote ? 1 : -1;
  if (current == target) {
    if (replace) return (score: score, vote: current);
    return (score: score - target, vote: 0);
  }
  if (current == -target) {
    return (score: score + 2 * target, vote: target);
  }
  return (score: score + target, vote: target);
}

@freezed
abstract class VoteResult with _$VoteResult {
  const factory VoteResult({required int score, required int ourScore}) =
      _VoteResult;

  factory VoteResult.fromJson(Map<String, dynamic> json) =>
      _$VoteResultFromJson(json);
}

class VoteDisplay extends StatelessWidget {
  const VoteDisplay({
    super.key,
    required this.vote,
    required this.score,
    this.onUpvote,
    this.onDownvote,
    this.padding,
  });

  final int? vote;
  final int score;
  final Future<bool> Function(bool isVoted)? onUpvote;
  final Future<bool> Function(bool isVoted)? onDownvote;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isUpvoted = vote == 1;
    final isDownvoted = vote == -1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkResponse(
          onTap: onUpvote != null ? () {} : null,
          child: LikeButton(
            isLiked: isUpvoted,
            circleColor: const CircleColor(
              start: Colors.orange,
              end: Colors.amber,
            ),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.amber,
              dotSecondaryColor: Colors.orange,
              dotThirdColor: Colors.deepOrange,
              dotLastColor: Colors.redAccent,
            ),
            likeBuilder: (bool isLiked) => Icon(
              Icons.arrow_upward,
              color: isLiked ? Colors.deepOrange : null,
            ),
            onTap: onUpvote ?? (_) async => isUpvoted,
          ),
        ),
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            score.toString(),
            style: TextStyle(
              color: isUpvoted
                  ? Colors.deepOrange
                  : isDownvoted
                  ? Colors.blue
                  : null,
            ),
          ),
        ),
        InkResponse(
          onTap: onDownvote != null ? () {} : null,
          child: LikeButton(
            isLiked: isDownvoted,
            circleColor: const CircleColor(
              start: Colors.blue,
              end: Colors.cyanAccent,
            ),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.cyanAccent,
              dotSecondaryColor: Colors.blue,
              dotThirdColor: Colors.indigoAccent,
              dotLastColor: Colors.indigo,
            ),
            likeBuilder: (bool isLiked) =>
                Icon(Icons.arrow_downward, color: isLiked ? Colors.blue : null),
            onTap: onDownvote ?? (_) async => isDownvoted,
          ),
        ),
      ],
    );
  }
}
