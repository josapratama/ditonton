import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SslPinning {
  static IOClient? _client;

  static Future<IOClient> createIOClient() async {
    if (_client != null) return _client!;

    // Load PEM certificate (TMDB API certificate)
    final sslCert = await rootBundle.load('assets/themoviedb.pem');

    // withTrustedRoots: true = keep system CAs (needed for Firebase, etc.)
    // We ADD our cert on top of system roots for pinning TMDB
    final securityContext = SecurityContext(withTrustedRoots: true);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    final httpClient = HttpClient(context: securityContext);
    // Only allow valid certificates — reject bad certs
    httpClient.badCertificateCallback = (cert, host, port) => false;

    _client = IOClient(httpClient);
    return _client!;
  }
}
