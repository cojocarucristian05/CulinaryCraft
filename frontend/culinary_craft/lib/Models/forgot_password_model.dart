
import '../Pages/forgot_password_widget.dart' show ForgotPasswordWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPasswordModel{

  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {
  }

  @override
  void dispose() {

  }

/// Action blocks are added here.

/// Additional helper methods are added here.
}
