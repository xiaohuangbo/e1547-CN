import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';

extension AppInfoQuerying on AppInfoClient {
  static const queryKey = 'appInfo';

  Query<List<AppVersion>> useNewVersions({bool beta = false}) => Query(
    cache: queryCache,
    key: [queryKey, 'versions', beta],
    queryFn: () => getNewVersions(beta: beta),
  );

  Query<List<Donor>> useBundledDonors() => Query(
    cache: queryCache,
    key: [queryKey, 'donors', 'bundled'],
    queryFn: getBundledDonors,
  );

  Query<List<Donor>> useDonors() =>
      Query(cache: queryCache, key: [queryKey, 'donors'], queryFn: getDonors);
}
