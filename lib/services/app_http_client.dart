import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:mindflasher_4/services/logging/app_logger.dart';

class AppHttpException implements Exception {
  const AppHttpException(this.message, {this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() => 'AppHttpException(message: $message, statusCode: $statusCode)';
}

class AppHttpClient {
  AppHttpClient({http.Client? client, Duration? timeout, AppLogger? logger})
      : _client = client ?? http.Client(),
        timeout = timeout ?? const Duration(seconds: 30),
        _logger = logger ?? AppLogger.instance;

  final http.Client _client;
  final Duration timeout;
  final AppLogger _logger;

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _runRequest('GET', url, () => _client.get(url, headers: headers));
  }

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) {
    return _runRequest('POST', url, () => _client.post(url, headers: headers, body: body));
  }

  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body}) {
    return _runRequest('PUT', url, () => _client.put(url, headers: headers, body: body));
  }

  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body}) {
    return _runRequest('PATCH', url, () => _client.patch(url, headers: headers, body: body));
  }

  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body}) {
    return _runRequest('DELETE', url, () => _client.delete(url, headers: headers, body: body));
  }

  Map<String, String> jsonHeaders({String? bearerToken, Map<String, String>? extraHeaders}) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (bearerToken != null && bearerToken.isNotEmpty) 'Authorization': 'Bearer $bearerToken',
      ...?extraHeaders,
    };
  }

  Future<http.Response> _runRequest(String method, Uri url, Future<http.Response> Function() request) async {
    _logger.debug('http', '$method ${url.path} started');
    try {
      final response = await request().timeout(timeout);
      _logger.info('http', '$method ${url.path} -> ${response.statusCode}');
      return response;
    } on TimeoutException catch (e) {
      _logger.warning('http', '$method ${url.path} timed out');
      throw AppHttpException('Request timed out', cause: e);
    } on http.ClientException catch (e) {
      _logger.error('http', '$method ${url.path} failed: ${e.message}');
      throw AppHttpException('Network request failed', cause: e);
    } catch (e) {
      _logger.error('http', '$method ${url.path} unexpected failure: $e');
      throw AppHttpException('Unexpected request failure', cause: e);
    }
  }
}