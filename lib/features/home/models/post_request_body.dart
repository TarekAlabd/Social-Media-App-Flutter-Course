import 'dart:convert';
class PostRequestBody {
  final String text;
  final String authorId;
  final String? image;
  final String? file;

  const PostRequestBody({
    required this.text,
    required this.authorId,
    this.image,
    this.file,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'text': text});
    result.addAll({'author_id': authorId});
    if (image != null) {
      result.addAll({'image': image});
    }
    if (file != null) {
      result.addAll({'file': file});
    }
  
    return result;
  }

  String toJson() => json.encode(toMap());

  PostRequestBody copyWith({
    String? text,
    String? authorId,
    String? image,
    String? file,
  }) {
    return PostRequestBody(
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      image: image ?? this.image,
      file: file ?? this.file,
    );
  }
}
