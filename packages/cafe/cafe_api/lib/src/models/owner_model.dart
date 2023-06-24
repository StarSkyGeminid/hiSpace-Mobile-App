import 'package:equatable/equatable.dart';

class OwnerModel extends Equatable {
  final String fullName;
  final String email;
  final String? profilePic;

  const OwnerModel({
    required this.fullName,
    required this.email,
    this.profilePic,
  });

  OwnerModel copyWith({
    String? fullName,
    String? email,
    String? profilePic,
  }) {
    return OwnerModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePic: profilePic ?? profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      if (profilePic != null) 'profilePic': profilePic,
    };
  }

  factory OwnerModel.fromMap(Map<String, dynamic> json) {
    return OwnerModel(
        fullName: json.containsKey('fullName') ? json['fullName'] : '',
        email: json.containsKey('email') ? json['email'] : '',
        profilePic: json['profilePic']);
  }

  static const empty = OwnerModel(fullName: '', email: '');

  @override
  List<Object?> get props => [fullName, email, profilePic];
}
