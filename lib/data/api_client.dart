import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks to the Spring Boot backend. During local development this points
/// at the backend running on the same machine; swap [baseUrl] when the
/// backend gets a real production home.
class ApiClient {
  ApiClient._();

  static const String baseUrl = 'http://localhost:8080/api';

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<List<dynamic>> getList(String path) async {
    final response = await http.get(_uri(path));
    _checkOk(response);
    return jsonDecode(response.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getObject(String path) async {
    final response = await http.get(_uri(path));
    _checkOk(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    _checkOk(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<void> delete(String path) async {
    final response = await http.delete(_uri(path));
    _checkOk(response);
  }

  /// POST that returns the response regardless of status code (2xx/4xx),
  /// used for auth/admin endpoints where a non-2xx body still carries a
  /// meaningful result (e.g. "invalidCredentials").
  static Future<http.Response> post(String path, Map<String, dynamic> body) {
    return http.post(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static void _checkOk(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}

class ApiException implements Exception {
  ApiException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'ApiException($statusCode): $body';
}
