import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Models/sign_in_model.dart';
import '../Services/auth_service.dart'; // Import the AuthService

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;
  final bool isWeb = kIsWeb;
  late SignInModel _model;
  String? _usernameError;
  String? _passwordError;
  String? _authError; // New field for authentication error

  @override
  void initState() {
    super.initState();
    _model = SignInModel();
    _model.initState(context);

    _model.emailAddressController = TextEditingController(); // Inițializăm controllerul de email
    _model.passwordController = TextEditingController(); // Inițializăm controllerul de parolă

    if (!isWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
            setState(() {
              _isKeyboardVisible = visible;
            });
          });
    }
  }

  @override
  void dispose() {
    if (!isWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
    _model.dispose();
    super.dispose();
  }

  void _signIn() async {
    setState(() {
      _usernameError = _model.emailAddressController?.text.isEmpty == true ? 'Please enter your username' : null;
      _passwordError = _model.passwordController?.text.isEmpty == true ? 'Please enter your password' : null;
      _authError = null; // Reset authentication error
    });

    if (_usernameError == null && _passwordError == null) {
      // Call the AuthService.login and handle the error message
      String? error = await AuthService.login(context, _model.emailAddressController!.text, _model.passwordController!.text);
      if (error != null) {
        setState(() {
          _authError = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign In',
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                if (_authError != null) // Display authentication error
                  Text(
                    _authError!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                SizedBox(height: 10),
                TextField(
                  controller: _model.emailAddressController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: _usernameError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _model.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _signIn,
                  child: Text('Sign In', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all(Color(0xFF0077B6)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // Handle forgot password
                    Navigator.of(context).pushNamed('/forgot_password');
                  },
                  child: Text(
                    'I don\'t remember my password',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: _isKeyboardVisible ? 12 : 24), // Muta putin mai jos cand tastatura e vizibila
                if (!_isKeyboardVisible)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account yet?',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text('Create Account', style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                            backgroundColor: MaterialStateProperty.all(Color(0xFF90E0EF)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
