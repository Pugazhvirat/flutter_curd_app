import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_curd_app/services/manage.http_response.dart';
import 'package:flutter_curd_app/views/screens/authentication_screens/admin_login_screen.dart';
import 'package:flutter_curd_app/views/screens/global_variable.dart';
import 'package:flutter_curd_app/views/screens/product_screen.dart';
import 'package:http/http.dart' as http;

class AdminAuthController {
  // Admin signup
  Future<void> signUpAdmin({
    required BuildContext context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final body = jsonEncode({
        "fullName": fullName,
        "email": email,
        "password": password,
      });

      http.Response response = await http.post(
        Uri.parse('$uri/api/admin/signup'),
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          );
          showSnackBar(context, "Admin account created successfully");
        },
      );
    } catch (e) {
      print("Admin SignUp Error: $e");
    }
  }

  // Admin signin
  Future<void> signInAdmin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/admin/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen()),
            (route) => false,
          );
          showSnackBar(context, "Admin Logged In");
        },
      );
    } catch (e) {
      print("Admin SignIn Error: $e");
    }
  }
}
