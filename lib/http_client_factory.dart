import 'package:http/http.dart' as http;
import 'http_client_factory_stub.dart' if (dart.library.io) 'http_client_factory_io.dart' as impl;

abstract class HttpClientFactory {
  static Future<void> get init => impl.initHttpClientFactory();

  static http.Client getHttpClient() => impl.getHttpClient();
}
