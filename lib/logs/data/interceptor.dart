import 'package:dio/dio.dart';
import 'package:e1547/logs/logs.dart';

class LoggingDioInterceptor extends Interceptor {
  LoggingDioInterceptor();

  static const String requestIdKey = 'log.request_id';
  static const String startedKey = 'log.started';
  static const int reasonLimit = 200;

  final Logger logger = Logger('Dio');

  static int _sequence = 0;

  Logger _scope(RequestOptions options) {
    final Uri uri = options.uri;
    return logger.child({
      'request_id': options.extra[requestIdKey],
      'method': options.method,
      'host': uri.host,
      'path': describePath(uri),
    });
  }

  static String describePath(Uri uri) {
    final Map<String, String> query = uri.queryParameters;
    if (query.isEmpty) return uri.path;
    final String rendered = query.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '${uri.path}?$rendered';
  }

  static String? describeReason(Object? data) {
    if (data is! Map) return null;
    final Object? reason = data['reason'] ?? data['message'];
    if (reason is! String || reason.isEmpty) return null;
    if (reason.length <= reasonLimit) return reason;
    return '${reason.substring(0, reasonLimit)}…';
  }

  int? _elapsed(RequestOptions options) {
    final Object? started = options.extra[startedKey];
    if (started is! int) return null;
    return DateTime.now().millisecondsSinceEpoch - started;
  }

  bool get _verbose => logger.isLoggable(LogLevel.trace);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[requestIdKey] = _sequence++;
    options.extra[startedKey] = DateTime.now().millisecondsSinceEpoch;

    if (logger.isLoggable(LogLevel.debug)) {
      final Logger scope = _scope(options);
      scope.debug('{method} {path}');
      if (_verbose) {
        scope.trace('Sent {method} {path}', {'headers': options.headers});
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final RequestOptions options = response.requestOptions;

    if (logger.isLoggable(LogLevel.debug)) {
      final Logger scope = _scope(options);
      scope.debug('{status} {method} {path} in {duration_ms}ms', {
        'status': response.statusCode,
        if (_elapsed(options) case final int ms) 'duration_ms': ms,
      });
      if (_verbose) {
        scope.trace('Received {method} {path}', {
          'headers': response.headers.map,
        });
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final RequestOptions options = err.requestOptions;
    final int? status = err.response?.statusCode;
    final bool failed =
        !CancelToken.isCancel(err) && (status == null || status >= 400);

    if (logger.isLoggable(failed ? LogLevel.warn : LogLevel.debug)) {
      final Logger scope = _scope(options);
      final String? reason = describeReason(err.response?.data);
      final Map<String, Object?> attributes = {
        'type': err.type.name,
        if (status != null) 'status': status,
        if (_elapsed(options) case final int ms) 'duration_ms': ms,
        if (reason != null) 'reason': reason,
      };

      if (CancelToken.isCancel(err)) {
        scope.debug('{method} {path} cancelled', attributes);
      } else if (status != null && status < 400) {
        scope.debug('{status} {method} {path}', attributes);
      } else {
        scope.warn(
          reason == null
              ? '{method} {path} failed with {status}'
              : '{method} {path} failed with {status}: {reason}',
          attributes,
          err,
        );
      }
    }

    super.onError(err, handler);
  }
}
