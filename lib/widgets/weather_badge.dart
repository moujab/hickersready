import 'package:flutter/material.dart';

import '../data/auth_session.dart';
import '../data/local_store.dart';
import '../data/weather_client.dart';
import '../data/weather_codes.dart';

/// Shows the current temperature + condition for the logged-in user's saved
/// weather city, next to the app name in the home-screen app bar. Renders
/// nothing until a city is set or if the lookup fails.
class WeatherBadge extends StatefulWidget {
  const WeatherBadge({super.key});

  @override
  State<WeatherBadge> createState() => _WeatherBadgeState();
}

class _WeatherBadgeState extends State<WeatherBadge> {
  late Future<CurrentWeather?> _weather;

  @override
  void initState() {
    super.initState();
    _weather = _load();
  }

  Future<CurrentWeather?> _load() async {
    final email = AuthSession.instance.currentEmail;
    if (email == null) return null;
    final profile = await LocalStore.getUserProfile(email);
    final lat = profile.weatherLat;
    final lon = profile.weatherLon;
    if (lat == null || lon == null) return null;
    return WeatherClient.fetchCurrent(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrentWeather?>(
      future: _weather,
      builder: (context, snapshot) {
        final weather = snapshot.data;
        if (weather == null) return const SizedBox.shrink();
        final (icon, label) = describeWeatherCode(weather.weatherCode);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              '${weather.temperatureC.round()}°',
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ],
        );
      },
    );
  }
}
