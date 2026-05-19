class RemarkModel {
  final String id;
  final String authorName;
  final String authorRole;
  final DateTime timestamp;
  final String text;

  RemarkModel({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.timestamp,
    required this.text,
  });
}
