import 'dart:convert';

class StoryModel {
  final String id;
  final String imageUrl;
  final String authorId;
  final String createdAt;
  final String authorName;

  const StoryModel({
    required this.id,
    required this.imageUrl,
    required this.authorId,
    required this.createdAt,
    this.authorName = '',
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'image_url': imageUrl});
    result.addAll({'author_id': authorId});
    result.addAll({'created_at': createdAt});

    return result;
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] ?? '',
      imageUrl: map['image_url'] ?? '',
      authorId: map['author_id'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) =>
      StoryModel.fromMap(json.decode(source));

  StoryModel copyWith({
    String? id,
    String? imageUrl,
    String? authorId,
    String? createdAt,
    String? authorName,
  }) {
    return StoryModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
    );
  }
}
