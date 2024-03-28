import 'package:flutter/material.dart';

class CreateAccountModel {
  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );
  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameController;
  String? Function(BuildContext, String?)? fullNameControllerValidator;
  String? _fullNameControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Full name is required.';
    }

    return null;
  }

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
    fullNameControllerValidator = _fullNameControllerValidator;
    emailAddressControllerValidator = _emailAddressControllerValidator;
    passwordVisibility = false;
    passwordControllerValidator = _passwordControllerValidator;
  }

  void dispose() {
    unfocusNode.dispose();
    fullNameFocusNode?.dispose();
    fullNameController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();
  }

  void createAccount(BuildContext context, String fullName, String email, String password) {
    // Implementarea procesului de creare a contului
    print('Attempting to create account with full name: $fullName, email: $email, and password: $password');
  }
}