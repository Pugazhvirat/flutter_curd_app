import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, // http response form the request

  required BuildContext context, // the context is to show snackbar
  required VoidCallback
  onSuccess, // the callback to excute on a successfull response
}) {
  //switch statement to handle different http status codes
  switch (response.statusCode) {
    case 200: //status code  200 indicates a successfull request
      onSuccess();
      break;
    case 400: // indicate bad request
      showSnackBar(context, json.decode(response.body)['msg']);
      break;

    case 500: //  indicate a server error
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    case 201: //indicate a resource was created successfully
      onSuccess();
      break;
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
