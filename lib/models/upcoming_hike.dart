class UpcomingHike {
  const UpcomingHike({
    required this.id,
    required this.trailName,
    required this.date,
    required this.description,
  });

  final String id;
  final String trailName;
  final DateTime date;
  final String description;

  Map<String, dynamic> toMap() => {
    'id': id,
    'trailName': trailName,
    'date': date.millisecondsSinceEpoch,
    'description': description,
  };

  factory UpcomingHike.fromMap(Map<String, dynamic> map) => UpcomingHike(
    id: map['id'] as String,
    trailName: map['trailName'] as String,
    date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    description: map['description'] as String,
  );
}
