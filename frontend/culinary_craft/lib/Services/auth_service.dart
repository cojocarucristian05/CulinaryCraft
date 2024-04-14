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
      retriveDataFromResponse(response);
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
      retriveDataFromResponse(response);
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      print("Error!");
    }
  }

  static void forgotPassword(BuildContext context, String email) async {
    var url = Uri.parse("$baseURL/forgot-password?email=$email");
    Map<String, String> cookies = {};

    http.Response response = await http.post(
        url,
        headers: headers,
    );

    print("status: ${response.statusCode}");

    if (response.statusCode == 200) {
      dynamic responseData = jsonDecode(response.body);
      if (responseData is int) {
        print("User ID: $responseData");
        Navigator.of(context).pushNamed('/reset_password_with_code');
      } else {
        print("Error: Unexpected response format");
      }
    } else {
      print("Error!");
    }
  }

  static void verifyCode(BuildContext context, String securityCode) async {

    int? id = await getId();

    var url = Uri.parse("$baseURL/verify-code?userId=$id");
    Map<String, String> cookies = {};

    http.Response response = await http.post(
      url,
      headers: headers,
      body: securityCode
    );

    print("status: ${response.statusCode}");

    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('/home');
    } else {
      print("Error!");
    }
  }

  static retriveDataFromResponse(http.Response response) {
    int id = 0;
    String username = "";
    String email = "";
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData.containsKey('id')) {
      print("Id: ${responseData['id']}");
      id = responseData['id'];
    }
    if (responseData.containsKey('username')) {
      print("Username: ${responseData['username']}");
      // setUserId(responseData['username']);
      username = responseData['username'];
    }
    if (responseData.containsKey('email')) {
      print("Email: ${responseData['email']}");
      email = responseData['email'];
    }
    setData(id, username, email);
  }

  static void setData(id, username, email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    prefs.setString('username', username);
    prefs.setString('email', email);
  }

  static void setId(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
  }

  static Future<int?> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }
}