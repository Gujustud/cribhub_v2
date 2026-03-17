import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

http.Client? _client;

Future<void> initHttpClientFactory() async {
  if (_client != null) return;
  try {
    final bytes = await rootBundle.load('assets/certs/cribhub.pem');
    final cert = bytes.buffer.asUint8List();
    final context = SecurityContext()
      ..setTrustedCertificatesBytes(cert);
    final ioClient = HttpClient(context: context);
    _client = IOClient(ioClient);
  } catch (e) {
    _client = null;
  }
}

http.Client getHttpClient() => _client ?? http.Client();
