import 'dart:convert';

class PostModel {
  final String id;
  final String text;
  final String authorId;
  final String createdAt;
  final String? authorName;
  final String? authorImageUrl;
  final String? videoUrl;
  final String? imageUrl;
  final List<String>? likes;
  final List<String>? comments;

  const PostModel({
    required this.id,
    required this.text,
    required this.authorId,
    required this.createdAt,
    this.authorName,
    this.authorImageUrl,
    this.videoUrl,
    this.imageUrl,
    this.likes,
    this.comments,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'text': text});
    result.addAll({'author_id': authorId});
    result.addAll({'created_at': createdAt});
    if(authorName != null){
      result.addAll({'author_name': authorName});
    }
    if(authorImageUrl != null){
      result.addAll({'author_image_url': authorImageUrl});
    }
    if(videoUrl != null){
      result.addAll({'video_url': videoUrl});
    }
    if(imageUrl != null){
      result.addAll({'image_url': imageUrl});
    }
    if(likes != null){
      result.addAll({'likes': likes});
    }
    if(comments != null){
      result.addAll({'comments': comments});
    }
  
    return result;
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      authorId: map['author_id'] ?? '',
      createdAt: map['created_at'] ?? '',
      // videoUrl: map['video_url'],
      imageUrl: map['image_url'],
      likes: map['likes'] != null ? List<String>.from(map['likes']) : null,
      // comments: List<String>.from(map['comments']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source));

  PostModel copyWith({
    String? id,
    String? text,
    String? authorId,
    String? createdAt,
    String? authorName,
    String? authorImageUrl,
    String? videoUrl,
    String? imageUrl,
    List<String>? likes,
    List<String>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      authorName: authorName ?? this.authorName,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }
}
