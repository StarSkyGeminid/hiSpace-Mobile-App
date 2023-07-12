// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String userId;
  final String fullname;
  final String email;
  final String? profilePic;

  const UserModel({
    required this.userId,
    required this.fullname,
    required this.email,
    this.profilePic,
  });

  UserModel copyWith({
    String? userId,
    String? fullname,
    String? email,
    String? profilePic,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'fullName': fullname,
      'email': email,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      fullname: map['fullName'] as String,
      email: map['email'] as String,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, fullname: $fullname, email: $email, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.fullname == fullname &&
        other.email == email &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fullname.hashCode ^
        email.hashCode ^
        profilePic.hashCode;
  }

  static const empty = UserModel(userId: '', fullname: '', email: '');
}
