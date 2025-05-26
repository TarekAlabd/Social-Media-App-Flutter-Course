import 'dart:convert';

class StoryModel {
  final String id;
  final String imagUrl;
  final String authorId;
  final String createdAt;

  const StoryModel({
    required this.id,
    required this.imagUrl,
    required this.authorId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'image_url': imagUrl});
    result.addAll({'author_id': authorId});
    result.addAll({'created_at': createdAt});
  
    return result;
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] ?? '',
      imagUrl: map['image_url'] ?? '',
      authorId: map['author_id'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) => StoryModel.fromMap(json.decode(source));
}
