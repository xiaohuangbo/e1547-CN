import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';

extension TopicQuerying on TopicClient {
  static const queryDomain = 'topics';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Topic, int> get topicCache =>
      queryCache.bridge(queryKey, fromJson: Topic.fromJson);

  Query<Topic> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: topicCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, query],
        getNextArg: (state) => state.nextPage,
        config: pagedIdConfig(),
        queryFn: (key) =>
            page(page: key, query: query).then(topicCache.savePage),
      );
}
