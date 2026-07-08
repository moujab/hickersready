class Invitation {
  const Invitation({
    required this.id,
    required this.trailName,
    required this.date,
    required this.description,
  });

  final String id;
  final String trailName;
  final DateTime date;

  /// Arabic-language description of the hike, shown when the invitation is
  /// opened.
  final String description;
}
