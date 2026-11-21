import 'package:e1547/app/app.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:workmanager/workmanager.dart';

/// Handles all background tasks that the app registered.
@pragma('vm:entry-point')
void executeBackgroundTasks() => Workmanager().executeTask((
  task,
  inputData,
) async {
  await initializeAppInfo();
  final logs = await initializeLogger(postfix: 'background');

  final logger = Logger('BackgroundTasks', {'task': task});
  logger.info('Running {task}');

  AppStorage? storage;

  try {
    storage = await initializeAppStorage();
    setLogLevel(
      verboseLogLevel(verbose: Settings(storage.preferences).verboseLogs.value),
    );

    final cancelToken = createBackgroundCancelToken(task);
    cancelToken.whenCancel.then((e) {
      logger.info('已取消 {task}：{reason}', {'reason': '${e.error}'});
    });

    FlutterLocalNotificationsPlugin notifications =
        await initializeNotifications();

    switch (task) {
      case followsBackgroundTaskKey:
        await runFollowUpdates(
          storage: storage,
          notifications: notifications,
          cancelToken: cancelToken,
        );
      default:
        throw StateError('未知任务 $task！');
    }

    return true;
  } on Object catch (e, stack) {
    logger.error('任务 {task} 失败', null, e, stack);
    rethrow;
  } finally {
    await storage?.close();
    logger.info('Finished {task}');
    await logs.close();
  }
});
