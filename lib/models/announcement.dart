class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.active,
  });

  final String id;
  final String title;

  /// Arabic-language body of the reminder, shown when the notification is
  /// opened.
  final String message;
  final DateTime createdAt;

  /// When false the announcement is kept in the database but hidden from the
  /// notification bell shown to users.
  final bool active;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'active': active,
  };

  factory Announcement.fromMap(Map<String, dynamic> map) => Announcement(
    id: map['id'] as String,
    title: map['title'] as String,
    message: map['message'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    active: map['active'] as bool? ?? true,
  );
}
