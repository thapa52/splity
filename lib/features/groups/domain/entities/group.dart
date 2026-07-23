import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

/// Core business entity representing a group in Splity.
///
/// This is a pure Dart class with no dependency on Flutter,
/// Hive, or any external package except Freezed for immutability.
///
/// A group contains:
/// - A unique [id]
/// - A [name] and optional [description]
/// - A list of [members] (names of people in the group)
/// - An optional [emoji] for visual identification
/// - [createdAt] timestamp
@freezed
abstract class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required List<String> members,
    @Default('') String description,
    @Default('👥') String emoji,
    required DateTime createdAt,
  }) = _Group;
}
