import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

final Logger _logger = Logger('FollowQuery');

extension FollowQuerying on FollowClient {
  static const queryDomain = 'follows';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Follow, int> get followCache => queryCache.bridge(queryKey);

  Query<Follow> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: followCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, int> usePage({QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, 'page', query],
        getNextArg: (state) => state.nextPage,
        queryFn: (pageKey) async {
          try {
            final result = await page(page: pageKey, query: query);
            return followCache.savePage(result);
          } catch (e, st) {
            _logger.warn(
              'Page {page} failed',
              {'page': pageKey, 'query': query},
              e,
              st,
            );
            rethrow;
          }
        },
      );

  Query<List<Follow>> useAll({QueryMap? query}) => Query(
    cache: queryCache,
    key: [...queryKey, 'all', query],
    queryFn: () => all(query: query),
  );

  Query<Map<FollowType, List<String>>> useTimelineTags() => Query(
    cache: queryCache,
    key: [...queryKey, 'timeline_tags'],
    queryFn: () async {
      final follows = await all(
        query: FollowsQuery(types: [FollowType.update, FollowType.notify]),
      );

      final Map<FollowType, List<String>> result = {
        FollowType.update: [],
        FollowType.notify: [],
      };

      for (final follow in follows) {
        if (!follow.tags.contains(' ')) {
          result[follow.type]?.add(follow.tags);
        }
      }

      return result;
    },
  );
}

typedef FollowSeenRequest = ({String tags, List<Post>? posts, Pool? pool});

extension FollowSeeing on Client {
  Mutation<void, FollowSeenRequest> useFollowSeen() => Mutation(
    mutationFn: (request) async {
      final follow = await follows.getByTags(tags: request.tags);
      if (follow == null) return;
      await followServer.syncWith(
        id: follow.id,
        posts: request.posts,
        pool: request.pool,
      );
    },
    onSuccess: (_, __) => follows.queryCache.invalidateKey(follows.queryKey),
  );
}
