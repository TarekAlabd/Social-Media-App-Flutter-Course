import 'dart:convert';

class PostModel {
  final String id;
  final String text;
  final String authorId;
  final String createdAt;
  final String? authorName;
  final String? authorImageUrl;
  final String? file;
  final String? image;
  final List<String>? likes;
  final int commentsCount;
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.text,
    required this.authorId,
    required this.createdAt,
    this.authorName,
    this.authorImageUrl,
    this.file,
    this.image,
    this.likes,
    this.commentsCount = 0,
    this.isLiked = false,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'text': text});
    result.addAll({'author_id': authorId});
    result.addAll({'created_at': createdAt});
    if (authorName != null) {
      result.addAll({'author_name': authorName});
    }
    if (authorImageUrl != null) {
      result.addAll({'author_image_url': authorImageUrl});
    }
    if (file != null) {
      result.addAll({'file': file});
    }
    if (image != null) {
      result.addAll({'image': image});
    }
    if (likes != null) {
      result.addAll({'likes': likes});
    }

    return result;
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      authorId: map['author_id'] ?? '',
      createdAt: map['created_at'] ?? '',
      file: map['file'],
      image: map['image'],
      likes: map['likes'] != null ? List<String>.from(map['likes']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  PostModel copyWith({
    String? id,
    String? text,
    String? authorId,
    String? createdAt,
    String? authorName,
    String? authorImageUrl,
    String? file,
    String? image,
    List<String>? likes,
    bool? isLiked,
    int? commentsCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      file: file ?? this.file,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
