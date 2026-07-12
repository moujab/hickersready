/// The app user's own profile — edited from the Settings screen, not part
/// of the admin-managed lists.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.father,
    required this.family,
    required this.email,
    required this.phone,
  });

  final String name;
  final String father;
  final String family;
  final String email;
  final String phone;

  static const empty = UserProfile(name: '', father: '', family: '', email: '', phone: '');

  Map<String, dynamic> toMap() => {
    'name': name,
    'father': father,
    'family': family,
    'email': email,
    'phone': phone,
  };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
    name: map['name'] as String,
    father: map['father'] as String,
    family: map['family'] as String,
    email: map['email'] as String,
    phone: map['phone'] as String,
  );
}
