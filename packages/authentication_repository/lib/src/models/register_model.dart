import 'dart:convert';

class RegisterModel {
  final String fullName;
  final String email;
  final String? password;

  const RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      if (password != null) 'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}
