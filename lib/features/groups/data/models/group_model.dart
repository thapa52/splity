import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/group.dart';

part 'group_model.g.dart';

/// Hive model for persisting [Group] data locally.
///
/// This is the data layer representation of a [Group].
/// It knows about Hive but the domain entity does not.
///
/// Conversion flow:
/// Hive storage → [GroupModel] → [Group] entity → UI
/// UI → [Group] entity → [GroupModel] → Hive storage
@HiveType(typeId: 0)
class GroupModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> members;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String emoji;

  @HiveField(5)
  final DateTime createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.description,
    required this.emoji,
    required this.createdAt,
  });

  /// Converts a domain [Group] entity to a [GroupModel].
  ///
  /// Used when saving to Hive.
  factory GroupModel.fromEntity(Group group) {
    return GroupModel(
      id: group.id,
      name: group.name,
      members: group.members,
      description: group.description,
      emoji: group.emoji,
      createdAt: group.createdAt,
    );
  }

  /// Converts this [GroupModel] to a domain [Group] entity.
  ///
  /// Used when reading from Hive.
  Group toEntity() {
    return Group(
      id: id,
      name: name,
      members: members,
      description: description,
      emoji: emoji,
      createdAt: createdAt,
    );
  }
}
