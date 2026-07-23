/// The app user's own profile — edited from the Settings screen, not part
/// of the admin-managed lists.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.father,
    required this.family,
    required this.email,
    required this.phone,
    this.weatherCity,
    this.weatherLat,
    this.weatherLon,
  });

  final String name;
  final String father;
  final String family;
  final String email;
  final String phone;

  /// The user's chosen city for the home-screen weather badge, and its
  /// resolved coordinates (from the Open-Meteo geocoding API). Null until
  /// the user picks a city in Settings.
  final String? weatherCity;
  final double? weatherLat;
  final double? weatherLon;

  static const empty = UserProfile(name: '', father: '', family: '', email: '', phone: '');

  Map<String, dynamic> toMap() => {
    'name': name,
    'father': father,
    'family': family,
    'email': email,
    'phone': phone,
    'weatherCity': weatherCity,
    'weatherLat': weatherLat,
    'weatherLon': weatherLon,
  };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
    name: map['name'] as String,
    father: map['father'] as String,
    family: map['family'] as String,
    email: map['email'] as String,
    phone: map['phone'] as String,
    weatherCity: map['weatherCity'] as String?,
    weatherLat: (map['weatherLat'] as num?)?.toDouble(),
    weatherLon: (map['weatherLon'] as num?)?.toDouble(),
  );
}
