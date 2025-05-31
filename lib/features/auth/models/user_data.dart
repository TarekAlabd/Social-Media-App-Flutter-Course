import 'dart:convert';

class UserData {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? title;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.title,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'email': email});
    if(imageUrl != null){
      result.addAll({'image_url': imageUrl});
    }
    if(title != null){
      result.addAll({'title': title});
    }
  
    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['image_url'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source));

  UserData copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? imageUrl,
    String? title,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }
}
