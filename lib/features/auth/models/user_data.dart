import 'dart:convert';

class UserData {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? title;
  final num? followersCount;
  final num? followingCount;
  final List<String>? following;
  final List<String>? followers;
  final num? postsCount;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.title,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.following,
    this.followers,
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
    if(followersCount != null){
      result.addAll({'followers_count': followersCount});
    }
    if(followingCount != null){
      result.addAll({'following_count': followingCount});
    }
    if(following != null){
      result.addAll({'following': following});
    }
    if(followers != null){
      result.addAll({'followers': followers});
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
      followersCount: map['followers_count'],
      followingCount: map['following_count'],
      following: map['following'] != null ? List<String>.from(map['following'] ?? []) : null,
      followers: map['followers'] != null ? List<String>.from(map['followers'] ?? []) : null,
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
    num? followersCount,
    num? followingCount,
    num? postsCount,
    List<String>? following,
    List<String>? followers,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
