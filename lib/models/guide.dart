class Guide {
  const Guide({
    required this.id,
    required this.name,
    required this.bio,
  });

  final String id;
  final String name;
  final String bio;

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'bio': bio};

  factory Guide.fromMap(Map<String, dynamic> map) =>
      Guide(id: map['id'] as String, name: map['name'] as String, bio: map['bio'] as String);
}
