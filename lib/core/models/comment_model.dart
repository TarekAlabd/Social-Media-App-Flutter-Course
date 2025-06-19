import 'dart:convert';

class CommentModel {
  final String id;
  final String createdAt;
  final String authorId;
  final String text;
  final String? authorName;
  final String? authorImageUrl;
  final String postId;
  final String? image;

  const CommentModel({
    required this.id,
    required this.createdAt,
    required this.authorId,
    required this.text,
    this.authorName,
    this.authorImageUrl,
    required this.postId,
    this.image,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'created_at': createdAt});
    result.addAll({'author_id': authorId});
    result.addAll({'text': text});
    result.addAll({'post_id': postId});
    if(image != null){
      result.addAll({'image': image});
    }
  
    return result;
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      createdAt: map['created_at'] ?? '',
      authorId: map['author_id'] ?? '',
      text: map['text'] ?? '',
      postId: map['post_id'] ?? '',
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source));

  CommentModel copyWith({
    String? id,
    String? createdAt,
    String? authorId,
    String? text,
    String? authorName,
    String? authorImageUrl,
    String? postId,
    String? image,
  }) {
    return CommentModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      authorName: authorName ?? this.authorName,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      postId: postId ?? this.postId,
      image: image ?? this.image,
    );
  }
}
