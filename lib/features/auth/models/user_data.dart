import 'dart:convert';

class UserData {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? imageUrl;
  final String? title;

  const UserData({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.imageUrl,
    this.title,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'username': username});
    result.addAll({'email': email});
    if(imageUrl != null){
      result.addAll({'imageUrl': imageUrl});
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
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'],
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
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }
}
