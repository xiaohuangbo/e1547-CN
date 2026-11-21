import 'package:e1547/logs/logs.dart';
import 'package:flutter/widgets.dart';

class RouteLoggerObserver extends NavigatorObserver {
  final Logger logger = Logger('Routes');

  void logRoute(Route<dynamic>? route, String action) {
    if (route == null) return;
    final String? name = route.settings.name;
    if (name == null) return;
    logger.debug('Route {route} was {action}', {
      'route': name,
      'action': action,
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    logRoute(route, 'pushed');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    logRoute(route, 'removed');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    logRoute(oldRoute, 'replaced');
    logRoute(newRoute, 'pushed');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    logRoute(route, 'popped');
  }
}
