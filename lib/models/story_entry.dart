import 'package:hive/hive.dart';

part 'story_entry.g.dart'; // این فایل با build_runner ساخته می‌شود

@HiveType(typeId: 0)
class StoryEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String story;

  @HiveField(2)
  final String emotion;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final List<String> selectedDeficiencies;

  @HiveField(5)
  final Map<String, String> harmedPeople;

  StoryEntry({
    required this.id,
    required this.story,
    required this.emotion,
    required this.createdAt,
    required this.selectedDeficiencies,
    required this.harmedPeople,
  });
}
