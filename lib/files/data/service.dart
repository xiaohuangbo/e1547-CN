import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mime/mime.dart';

class DioFileService extends FileService {
  DioFileService(this.dio, {this.receiveTimeout = const Duration(seconds: 30)});

  final Dio dio;

  final Duration receiveTimeout;

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async => DioFileServiceResponse(
    await dio.get<ResponseBody>(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: headers,
        receiveTimeout: receiveTimeout,
        // The cache reads the status itself, and evicts on 404.
        validateStatus: (status) => true,
      ),
    ),
  );
}

class DioFileServiceResponse implements FileServiceResponse {
  DioFileServiceResponse(this.response);

  final Response<ResponseBody> response;

  final DateTime _received = DateTime.now();

  String? _header(String name) => response.headers.value(name);

  @override
  Stream<List<int>> get content =>
      response.data?.stream ?? const Stream.empty();

  @override
  int? get contentLength {
    if (int.tryParse(_header(HttpHeaders.contentLengthHeader) ?? '')
        case final int length) {
      return length;
    }
    if (response.data?.contentLength case final int length when length >= 0) {
      return length;
    }
    return null;
  }

  @override
  int get statusCode => response.statusCode ?? 0;

  @override
  String? get eTag => _header(HttpHeaders.etagHeader);

  @override
  DateTime get validTill {
    Duration age = const Duration(days: 7);
    if (_header(HttpHeaders.cacheControlHeader) case final String control) {
      for (final setting in control.split(',')) {
        final String sanitized = setting.trim().toLowerCase();
        if (sanitized == 'no-cache') {
          age = Duration.zero;
        }
        if (sanitized.startsWith('max-age=')) {
          final int seconds = int.tryParse(sanitized.split('=')[1]) ?? 0;
          if (seconds > 0) {
            age = Duration(seconds: seconds);
          }
        }
      }
    }
    return _received.add(age);
  }

  @override
  String get fileExtension {
    if (_header(HttpHeaders.contentTypeHeader) case final String type) {
      if (extensionFromMime(ContentType.parse(type).mimeType)
          case final String extension) {
        return '.$extension';
      }
    }
    return '';
  }
}
