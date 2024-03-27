import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Models/create_account_model.dart'; // Importăm modelul de creare a contului
export '../Models/create_account_model.dart';

class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({Key? key}) : super(key: key);

  @override
  _CreateAccountWidgetState createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;
  final bool isWeb = kIsWeb;
  late CreateAccountModel _model; // Schimbăm modelul asociat

  @override
  void initState() {
    super.initState();
    _model = CreateAccountModel(); // Inițializăm modelul de creare a contului
    _model.initState(context);

    _model.fullNameController = TextEditingController(); // Inițializăm controllerul pentru nume
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
                  'Create Account', // Schimbăm textul pentru pagina de creare a contului
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _model.fullNameController, // Schimbăm controllerul pentru nume
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Full Name', // Schimbăm eticheta câmpului
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _model.emailAddressController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _model.passwordController,
                  obscureText: !_model.passwordVisibility, // Schimbăm vizibilitatea parolei conform modelului
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _model.passwordVisibility ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _model.passwordVisibility = !_model.passwordVisibility;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_model.fullNameController?.text.isNotEmpty == true &&
                        _model.emailAddressController?.text.isNotEmpty == true &&
                        _model.passwordController?.text.isNotEmpty == true) {
                      _model.createAccount(context, _model.fullNameController!.text,
                          _model.emailAddressController!.text, _model.passwordController!.text); // Apelăm metoda de creare a contului
                    } else {
                      // Tratează cazurile în care unul dintre câmpuri este necompletat
                    }
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Mărim scrisul butonului
                    ),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all(Color(0xFF0077B6)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                  ),
                ),
                SizedBox(height: 10), // Adăugăm spațiu între buton și textul de sub buton
                Text(
                  'By clicking "Create Account" you agree to CulinaryCraft\'s Terms of Use', // Adăugăm textul specificat
                  textAlign: TextAlign.center, // Afișăm textul în centru
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20), // Mărim spațiul sub text
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signin');
                  },
                  child: Text(
                    'I already have an account', // Schimbăm textul pentru link-ul către pagina de sign-in
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: _isKeyboardVisible ? 12 : 24), // Muta putin mai jos cand tastatura e vizibila
              ],
            ),
          ),
        ),
      ),
    );
  }
}
