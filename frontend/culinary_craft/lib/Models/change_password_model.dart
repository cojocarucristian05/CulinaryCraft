
import '../Pages/change_password_widget.dart' show ChangePasswordWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangePasswordModel  {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  FocusNode? passwordFocusNode1;
  TextEditingController? passwordController1;
  String? Function(BuildContext, String?)? passwordController1Validator;

  // State field(s) for Password widget.
  FocusNode? passwordFocusNode2;
  TextEditingController? passwordController2;
  String? Function(BuildContext, String?)? passwordController2Validator;

  @override
  void initState(BuildContext context) {
    passwordController1Validator = passwordController1Validator;
    passwordController2Validator = passwordController2Validator;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    passwordFocusNode1?.dispose();
    passwordController1?.dispose();

    passwordFocusNode2?.dispose();
    passwordController2?.dispose();
  }
}
