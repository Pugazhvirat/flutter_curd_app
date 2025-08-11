import 'dart:convert';

class Admin {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String token;

  Admin({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fullName": fullName,
      "email": email,
      "password": password,
      "token": token,
    };
  }

  String toJson() => jsonEncode(toMap());
}
