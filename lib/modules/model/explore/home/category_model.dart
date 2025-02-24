import 'video_model.dart';

class Category {
  final String id;
  final String level;
  final String levelName;
  final String name;
  final List<Video> videos;

  Category({
    required this.id,
    required this.level,
    required this.levelName,
    required this.name,
    required this.videos,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      level: json['level'] ?? '',
      levelName: json['level_name'] ?? '',
      name: json['name'] ?? '',
      videos: (json['videos'] as List)
          .map((video) => Video.fromJson(video))
          .toList(),
    );
  }
}