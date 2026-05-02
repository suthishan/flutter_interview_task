import 'package:flutter/foundation.dart';

@immutable
class RemarkModel {
  final String id;
  final String authorName;

  /// 'Manager' or 'Sales Officer' — drives avatar color in the timeline.
  final String authorRole;
  final DateTime timestamp;
  final String text;

  const RemarkModel({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.timestamp,
    required this.text,
  });

  RemarkModel copyWith({
    String? authorName,
    String? authorRole,
    DateTime? timestamp,
    String? text,
  }) {
    return RemarkModel(
      id: id,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      timestamp: timestamp ?? this.timestamp,
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is RemarkModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}