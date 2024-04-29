import 'package:flutter/material.dart';
import '../Models/change_password_model.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  late ChangePasswordModel _model;
  String? _passwordError1;
  String? _passwordError2;

  @override
  void initState() {
    super.initState();
    _model = ChangePasswordModel();

    _model.passwordController1 = TextEditingController();
    _model.passwordController2 = TextEditingController();

    _model.passwordFocusNode1 = FocusNode();
    _model.passwordFocusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _changePassword() {
    setState(() {
      _passwordError1 = _model.passwordController1.text.isEmpty ? 'Please enter a new password' : null;
      _passwordError2 = _model.passwordController2.text.isEmpty ? 'Please confirm your new password' : null;

      if (_passwordError1 == null && _passwordError2 == null) {
        if (_model.passwordController1.text != _model.passwordController2.text) {
          _passwordError2 = 'Passwords do not match';
        } else {
          // Perform password change logic
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _model.passwordController1,
              focusNode: _model.passwordFocusNode1,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                errorText: _passwordError1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _model.passwordController2,
              focusNode: _model.passwordFocusNode2,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: _passwordError2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF0077B6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
