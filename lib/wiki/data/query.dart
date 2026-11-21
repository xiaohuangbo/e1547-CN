import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/wiki/wiki.dart';

extension WikiQuerying on WikiClient {
  static const queryDomain = 'wikis';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Wiki, int> get wikiCache =>
      queryCache.bridge(queryKey, fromJson: Wiki.fromJson);

  Query<Wiki> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: wikiCache.getConfig(vendored: vendored),
  );

  Query<Wiki> useGetByTitle({required String title, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, 'title', title],
    queryFn: () async {
      final wiki = await getByTitle(title: title);
      wikiCache.set(wiki);
      return wiki;
    },
    config: wikiCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, query],
        getNextArg: (state) => state.nextPage,
        config: pagedIdConfig(),
        queryFn: (key) =>
            page(page: key, query: query).then(wikiCache.savePage),
      );
}
