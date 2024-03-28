import 'dart:convert';

import 'package:culinary_craft_wireframe/Services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AuthService {
  static void register(BuildContext context, String username, String email,
      String password) async {
    Map data = {
      "username": username,
      "email": email,
      "password": password,
    };

    var body = jsonEncode(data);
    var url = Uri.parse("$baseURL/register");

    http.Response response = await http.post(
        url,
        headers: headers,
        body: body
    );

    print("status: ${response.statusCode}");

    if (response.statusCode == 201) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      print("Error!");
    }
  }
}