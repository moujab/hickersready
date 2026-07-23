import 'dart:convert';

import 'package:http/http.dart' as http;

class CurrentWeather {
  const CurrentWeather({required this.temperatureC, required this.weatherCode});

  final double temperatureC;
  final int weatherCode;
}

class GeoCity {
  const GeoCity({
    required this.name,
    required this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String? admin1;
  final String? country;
  final double latitude;
  final double longitude;

  String get displayName => [name, admin1, country].whereType<String>().where((s) => s.isNotEmpty).join('، ');
}

/// Talks to Open-Meteo's free geocoding and forecast APIs (no API key needed).
class WeatherClient {
  WeatherClient._();

  static Future<List<GeoCity>> searchCity(String query) async {
    if (query.trim().isEmpty) return [];
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query.trim(),
      'count': '5',
      'language': 'ar',
      'format': 'json',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return [];
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>?;
    if (results == null) return [];
    return results
        .cast<Map<String, dynamic>>()
        .map(
          (r) => GeoCity(
            name: r['name'] as String,
            admin1: r['admin1'] as String?,
            country: r['country'] as String?,
            latitude: (r['latitude'] as num).toDouble(),
            longitude: (r['longitude'] as num).toDouble(),
          ),
        )
        .toList();
  }

  static Future<CurrentWeather?> fetchCurrent(double latitude, double longitude) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'temperature_2m,weather_code',
      'timezone': 'auto',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) return null;
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final current = body['current'] as Map<String, dynamic>?;
    if (current == null) return null;
    return CurrentWeather(
      temperatureC: (current['temperature_2m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
    );
  }
}
