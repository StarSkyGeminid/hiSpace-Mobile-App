import 'package:equatable/equatable.dart';

import 'dart:convert';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? profilePic;

  const UserModel({
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['userId'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJsonString(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserModel.fromJsonMap(Map<String, dynamic> source) =>
      UserModel.fromMap(source);

  static const empty = UserModel(id: '', fullName: '', email: '');

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profilePic,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, profilePic];
}
