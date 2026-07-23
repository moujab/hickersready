import 'package:flutter/material.dart';

/// Maps Open-Meteo's WMO weather codes to an icon and a short Arabic label.
/// https://open-meteo.com/en/docs#weathervariables
(IconData, String) describeWeatherCode(int code) {
  if (code == 0) return (Icons.wb_sunny, 'صافٍ');
  if (code <= 2) return (Icons.wb_cloudy, 'غائم جزئياً');
  if (code == 3) return (Icons.cloud, 'غائم');
  if (code == 45 || code == 48) return (Icons.foggy, 'ضباب');
  if (code >= 51 && code <= 57) return (Icons.grain, 'رذاذ');
  if (code >= 61 && code <= 67) return (Icons.water_drop, 'مطر');
  if (code >= 71 && code <= 77) return (Icons.ac_unit, 'ثلج');
  if (code >= 80 && code <= 82) return (Icons.water_drop, 'زخات مطر');
  if (code >= 85 && code <= 86) return (Icons.ac_unit, 'زخات ثلج');
  if (code >= 95) return (Icons.thunderstorm, 'عاصفة رعدية');
  return (Icons.thermostat, '');
}
