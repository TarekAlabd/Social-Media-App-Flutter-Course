import 'dart:convert';
import 'dart:io';

class PostRequestBody {
  final String text;
  final String authorId;
  final File? image;
  final File? file;

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
    if(image != null){
      result.addAll({'image': base64Encode(image!.readAsBytesSync())});
    }
    if(file != null){
      result.addAll({'file': base64Encode(file!.readAsBytesSync())});
    }
  
    return result;
  }

  String toJson() => json.encode(toMap());
}
