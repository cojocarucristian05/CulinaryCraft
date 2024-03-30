import 'dart:convert';

import 'package:culinary_craft_wireframe/Services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
      Navigator.of(context).pushReplacementNamed('/signin');
    } else {
      print("Error!");
    }
  }

  static void login(BuildContext context, String username, String password) async {
    Map data = {
      "username": username,
      "password": password,
    };

    var body = jsonEncode(data);
    var url = Uri.parse("$baseURL/login");
    Map<String, String> cookies = {};

    http.Response response = await http.post(
        url,
        headers: headers,
        body: body
    );

    print("status: ${response.statusCode}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      if (responseData.containsKey('id')) {
        print("Id: ${responseData['id']}");
      }
      if (responseData.containsKey('username')) {
        print("Username: ${responseData['username']}");
        setUserId(responseData['username']);
      }
      if (responseData.containsKey('email')) {
        print("Email: ${responseData['email']}");
      }
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      print("Error!");
    }
  }

  static void signInWithGoogle(BuildContext context, String username, String email) async {
    Map data = {
      "username": username,
      "email": email,
    };

    var body = jsonEncode(data);
    var url = Uri.parse("$baseURL/sign-in-with-google");

    http.Response response = await http.post(
        url,
        headers: headers,
        body: body
    );

    print("status: ${response.statusCode}");

    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      print("Error!");
    }
  }

  static Future<bool> setUserId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("id", value);
  }

  static Future<String?> getUserId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("id");
  }
}