import 'package:equatable/equatable.dart';

import 'dart:convert';

class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? profilePic;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.profilePic,
  });

  String get userName => fullName.split(' ').first;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': id,
      'fullName': fullName,
      'profilePic': profilePic,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['userId'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJsonString(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  static const empty = User(id: '', fullName: '', email: '');

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profilePic,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, profilePic];
}
