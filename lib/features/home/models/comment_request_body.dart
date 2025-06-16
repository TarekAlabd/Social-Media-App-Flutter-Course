import 'dart:convert';

class CommentRequestBody {
  final String text;
  final String authorId;
  final String postId;
  final String? image;

  const CommentRequestBody({
    required this.text,
    required this.authorId,
    required this.postId,
    this.image,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'text': text});
    result.addAll({'author_id': authorId});
    result.addAll({'post_id': postId});
    if(image != null){
      result.addAll({'image': image});
    }
  
    return result;
  }

  factory CommentRequestBody.fromMap(Map<String, dynamic> map) {
    return CommentRequestBody(
      text: map['text'] ?? '',
      authorId: map['author_id'] ?? '',
      postId: map['post_id'] ?? '',
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentRequestBody.fromJson(String source) => CommentRequestBody.fromMap(json.decode(source));
}
