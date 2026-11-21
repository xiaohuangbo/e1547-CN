import 'package:dio/dio.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/wiki/wiki.dart';

class WikiClient {
  WikiClient({required this.dio});

  final Dio dio;

  Future<Wiki> get({required int id, CancelToken? cancelToken}) =>
      _get(id.toString(), cancelToken: cancelToken);

  Future<Wiki> getByTitle({required String title, CancelToken? cancelToken}) =>
      _get(title, cancelToken: cancelToken);

  Future<Wiki> _get(String lookup, {CancelToken? cancelToken}) => dio
      .get('/wiki_pages/$lookup.json', cancelToken: cancelToken)
      .then((response) => E621Wiki.fromJson(response.data));

  Future<List<Wiki>> page({
    int? page,
    int? limit,
    QueryMap? query,
    CancelToken? cancelToken,
  }) => dio
      .get(
        '/wiki_pages.json',
        queryParameters: {'page': page, 'limit': limit, ...?query},
        cancelToken: cancelToken,
      )
      .then(unwrapRailsArray)
      .then(
        (response) =>
            (response.data as List).map<Wiki>(E621Wiki.fromJson).toList(),
      );
}
