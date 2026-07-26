class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Announcement.fromMap(Map<String, dynamic> map) => Announcement(
    id: map['id'] as String,
    title: map['title'] as String,
    body: map['body'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}
