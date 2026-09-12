import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SslPinning {
  static IOClient? _client;

  static Future<IOClient> createIOClient() async {
    if (_client != null) return _client!;

    final sslCert = await rootBundle.load('assets/themoviedb.cer');
    final securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    final httpClient = HttpClient(context: securityContext);
    httpClient.badCertificateCallback = (_, __, ___) => false;

    _client = IOClient(httpClient);
    return _client!;
  }
}
