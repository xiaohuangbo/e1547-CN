import 'package:dio/dio.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';

class ReplyClient {
  ReplyClient({required this.dio});

  final Dio dio;

  Future<Reply> get({required int id, CancelToken? cancelToken}) => dio
      .get('/forum_posts/$id.json', cancelToken: cancelToken)
      .then((response) => E621Reply.fromJson(response.data));

  Future<List<Reply>> page({
    int? page,
    int? limit,
    QueryMap? query,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/forum_posts.json',
        queryParameters: {'page': page, 'limit': limit, ...?query}.toQuery(),
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) => (response.data as List)
            .map<Reply>((e) => E621Reply.fromJson(e))
            .toList(),
      );

  Future<void> create({required int topicId, required String content}) =>
      dio.post(
        '/forum_posts.json',
        data: FormData.fromMap({
          'forum_post[body]': content,
          'forum_post[topic_id]': topicId,
        }),
      );

  Future<void> update({required int id, required String content}) => dio.patch(
    '/forum_posts/$id.json',
    data: FormData.fromMap({'forum_post[body]': content}),
  );
}
