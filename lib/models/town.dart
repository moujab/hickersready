class Town {
  const Town({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'description': description};

  factory Town.fromMap(Map<String, dynamic> map) => Town(
    id: map['id'] as String,
    name: map['name'] as String,
    description: map['description'] as String,
  );
}
