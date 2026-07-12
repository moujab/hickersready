/// A local user account: email + salted/hashed password, stored so the
/// login screen can gate entry to the app. This is a stand-in until real
/// backend auth exists.
class Account {
  const Account({required this.email, required this.salt, required this.passwordHash});

  final String email;
  final String salt;
  final String passwordHash;

  Map<String, dynamic> toMap() => {'email': email, 'salt': salt, 'passwordHash': passwordHash};

  factory Account.fromMap(Map<String, dynamic> map) => Account(
    email: map['email'] as String,
    salt: map['salt'] as String,
    passwordHash: map['passwordHash'] as String,
  );
}
