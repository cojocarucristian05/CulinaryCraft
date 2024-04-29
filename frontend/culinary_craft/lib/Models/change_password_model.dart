
import '../Pages/change_password_widget.dart' show ChangePasswordWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangePasswordModel {
  late TextEditingController passwordController1;
  late TextEditingController passwordController2;
  late FocusNode passwordFocusNode1;
  late FocusNode passwordFocusNode2;

  String? passwordsMatchError;



  void dispose() {
    passwordController1.dispose();
    passwordController2.dispose();
    passwordFocusNode1.dispose();
    passwordFocusNode2.dispose();
  }
}