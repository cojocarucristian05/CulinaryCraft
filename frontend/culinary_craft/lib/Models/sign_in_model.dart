import 'dart:async';

import 'package:flutter/material.dart';

class SignInModel {
  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );
  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  String? _emailAddressControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email is required.';
    }

    if (!emailRegex.hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  String? _passwordControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required.';
    }

    return null;
  }

  void initState(BuildContext context) {
    emailAddressControllerValidator = _emailAddressControllerValidator;
    passwordVisibility = false;
    passwordControllerValidator = _passwordControllerValidator;
  }

  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();
  }

  void signIn(BuildContext context, String email, String password) {
    // Verificăm dacă adresa de email este validă folosind expresia regulată
    if (!emailRegex.hasMatch(email)) {
      // Afisam un mesaj de eroare dacă adresa de email nu este validă
      print('Email is not valid.');
      return;
    }

    print('Attempting to sign in with email: $email and password: $password');
  }
}
