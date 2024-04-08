import 'package:flutter/material.dart';
import '../Models/change_password_model.dart';


class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  late ChangePasswordModel _model;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Eliminăm umbra AppBar-ului
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed('/edit_profile');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _model.passwordController1,
              focusNode: _model.passwordFocusNode1,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _model.passwordController2,
              focusNode: _model.passwordFocusNode2,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_model.passwordController1?.text.isNotEmpty == true &&
                    _model.passwordController2?.text.isNotEmpty == true) {
                  if (_model.passwordController1!.text == _model.passwordController2!.text) {
                    // Passwords match
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Success'),
                        content: Text('Password changed successfully!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pushReplacementNamed('/profile'); // Redirect to '/profile'
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Passwords don't match
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Passwords do not match!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  // Handle the case when one or both fields are empty
                }
              },
              child: const Text('Change Password', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), backgroundColor: const Color(0xFF0077B6),
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
