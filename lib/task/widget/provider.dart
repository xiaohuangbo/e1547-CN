import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TasksControllerProvider
    extends
        SubChangeNotifierProvider5<
          Client,
          AppStorage,
          BaseCacheManager,
          Settings,
          IdentityClient,
          TasksController
        > {
  TasksControllerProvider({super.child, super.builder})
    : super(
        create: (context, client, storage, cache, settings, identity) =>
            TasksController(
              repository: TaskRepository(database: storage.sqlite),
              client: client,
              cacheManager: cache,
              settings: settings,
              identity: identity.identity.id,
            ),
      );
}
