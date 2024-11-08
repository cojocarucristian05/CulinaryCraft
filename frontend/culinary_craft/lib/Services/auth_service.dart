import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:culinary_craft_wireframe/Services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static Future<String?> register(BuildContext context, String username, String email, String password) async {
    var bytesPassword = utf8.encode(password);
    var hashPassword = sha256.convert(bytesPassword);
    Map data = {
      "username": username,
      "email": email,
      "password": hashPassword.toString(),
    };

    var body = jsonEncode(data);
    var url = Uri.parse("$baseURL/$registerPath");

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print("status: ${response.statusCode}");

    if (response.statusCode == 201) {
      Navigator.of(context).pushReplacementNamed('/signin');
      return null; // Fără eroare
    } else if (response.statusCode == 409) {
      return "Email is already in use";
    } else {
      return "Email is already in use";
    }
  }

  static Future<String?> login(BuildContext context, String username, String password) async {
    var bytesPassword = utf8.encode(password);
    var hashPassword = sha256.convert(bytesPassword);

    Map data = {
      "username": username,
      "password": hashPassword.toString(),
    };

    var body = jsonEncode(data);
    var url = Uri.parse("$baseURL/$loginPath");
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
      return null;  // Fără eroare
    } else if (response.statusCode == 409) {
      // Specific pentru cazurile de conflict, cum ar fi email-ul deja folosit
      return "Please enter a valid account !";
    } else {
      return "Please enter a valid account !";
    }
  }

  static void logout() async {
    deleteId();
  }

  static void signInWithGoogle(BuildContext context, String username, String email) async {
    Map data = {
      "username": username,
      "email": email,
    };

    var body = jsonEncode(data);
    var url = Uri.parse("$baseURL/$signInWithGooglePath");

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
    var url = Uri.parse("$baseURL/$forgotPasswordPath$EMAIL_REQUEST_PARAMETER=$email");
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
    var url = Uri.parse("$baseURL/$verifyCodePath$ID_REQUEST_PARAMETER=$id");
    Map<String, String> cookies = {};

    http.Response response = await http.post(
      url,
      headers: headers,
      body: securityCode
    );

    print("status: ${response.statusCode}");

    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('/change_password');
    } else {
      print("Error!");
    }
  }

  static void changePassword(BuildContext context, String password) async {
    var bytesPassword = utf8.encode(password);
    var hashPassword = sha256.convert(bytesPassword);
    int? id = await getId();
    var url = Uri.parse("$baseURL/change-password$ID_REQUEST_PARAMETER=$id");
    Map<String, String> cookies = {};

    http.Response response = await http.put(
        url,
        headers: headers,
        body: hashPassword.toString()
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

  static Future<void> deactivateAccount() async {
    int? id = await getId();
    var url = Uri.parse("$baseURL/deactivate-account/$id");

    http.Response response = await http.put(url, headers: headers);

    print("status: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Account deactivated successfully");
      deleteId(); // Optionally clear user data from local storage
    } else {
      print("Error deactivating account");
    }
  }

  static Future<void> deleteAccount() async {
    int? id = await getId();
    var url = Uri.parse("$baseURL/delete-account/$id");

    http.Response response = await http.delete(url, headers: headers);

    print("status: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Account deleted successfully");
      deleteId(); // Optionally clear user data from local storage
    } else {
      print("Error deleting account");
    }
  }

  static void setData(id, username, email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(ID, id);
    prefs.setString(USERNAME, username);
    prefs.setString(EMAIL, email);
  }

  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USERNAME);
  }

  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(EMAIL);
  }
  static void setId(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(ID, id);
  }

  static Future<int?> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(ID);
  }

  static void deleteId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(ID);
  }
}