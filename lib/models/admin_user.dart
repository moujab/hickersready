/// A registered user as seen by the admin — the account email plus the
/// profile fields. The password is never returned from the backend; it's
/// only set when the admin creates a user or resets it.
class AdminUser {
  const AdminUser({
    required this.email,
    required this.name,
    required this.father,
    required this.family,
    required this.phone,
  });

  final String email;
  final String name;
  final String father;
  final String family;
  final String phone;

  String get displayName => [name, father, family].where((s) => s.isNotEmpty).join(' ');

  factory AdminUser.fromMap(Map<String, dynamic> map) => AdminUser(
    email: map['email'] as String,
    name: (map['name'] as String?) ?? '',
    father: (map['father'] as String?) ?? '',
    family: (map['family'] as String?) ?? '',
    phone: (map['phone'] as String?) ?? '',
  );
}
