import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_curd_app/models/user.dart';
import 'package:flutter_curd_app/services/manage.http_response.dart';
import 'package:flutter_curd_app/views/screens/authentication_screens/login_screen.dart';
import 'package:flutter_curd_app/views/screens/global_variable.dart';
import 'package:flutter_curd_app/views/screens/nav_screens/home_screen.dart';
import 'package:http/http.dart' as http;

class AuthController {
  Future<void> signUpUser({
    required context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),

        body: user
            .toJson(), //convert the user object to json for the request body

        headers: <String, String>{
          //set this header for the request
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          showSnackBar(context, "Account has been created for you");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  //signin

  Future<void> signInUsers({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({
          "email": email, //include the email in the request body,
          "password": password,
        }),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      //hand the response using the managehttpresponse
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
          showSnackBar(context, "Logged In");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }
}
