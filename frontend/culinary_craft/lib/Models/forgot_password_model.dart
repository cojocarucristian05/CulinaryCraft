// În ForgotPasswordModel:

import 'package:flutter/material.dart';

class ForgotPasswordModel {
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  final unfocusNode = FocusNode();

  // Funcție pentru validarea adresei de email utilizând expresii regulate (regex)
  String? validateEmailAddress(BuildContext context, String? value) {
    // Expresia regulată pentru validarea adresei de email
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // Verificăm dacă adresa de email respectă expresia regulată
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null; // Adresa de email este validă
  }

  void initState(BuildContext context) {}

  void dispose() {}
}

