import 'dart:io';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

http.Client? _client;

Future<void> initHttpClientFactory() async {
  if (_client != null) return;
  final ioClient = HttpClient()
    ..badCertificateCallback = (cert, host, port) => true;
  _client = _HostOverrideClient(IOClient(ioClient));
}

http.Client getHttpClient() => _client ?? http.Client();

/// Intercepts requests to cribhub.sscadcam.com and rewrites the URL to use
/// the server's local IP directly, bypassing Android OS DNS resolution.
/// The Host header is preserved so Nginx routes the request correctly.
class _HostOverrideClient extends http.BaseClient {
  final http.Client _inner;

  _HostOverrideClient(this._inner);

  static const String _targetHost = 'cribhub.sscadcam.com';
  static const String _localIp = '192.168.20.102';

  Uri _rewrite(Uri uri) {
    if (uri.host != _targetHost) return uri;
    return uri.replace(host: _localIp, port: 443);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final rewritten = _rewrite(request.url);
    if (rewritten == request.url) return _inner.send(request);

    http.BaseRequest newRequest;
    if (request is http.Request) {
      final r = http.Request(request.method, rewritten)
        ..headers.addAll(request.headers)
        ..bodyBytes = request.bodyBytes
        ..encoding = request.encoding
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection;
      r.headers['Host'] = _targetHost;
      newRequest = r;
    } else if (request is http.StreamedRequest) {
      final r = http.StreamedRequest(request.method, rewritten)
        ..headers.addAll(request.headers)
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection;
      r.headers['Host'] = _targetHost;
      request.finalize().pipe(r.sink);
      newRequest = r;
    } else {
      return _inner.send(request);
    }

    return _inner.send(newRequest);
  }

  @override
  void close() => _inner.close();
}
