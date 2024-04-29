import 'package:flutter/material.dart';
import '../Models/forgot_password_model.dart';
import '../Services/auth_service.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordModel _model;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _model = ForgotPasswordModel();
    _model.emailAddressController = TextEditingController();
    _model.emailAddressControllerValidator = _model.validateEmailAddress;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _resetPassword() {
    setState(() {
      _emailError = _model.emailAddressControllerValidator!(context, _model.emailAddressController!.text);
    });
    if (_emailError == null) {
      AuthService.forgotPassword(context, _model.emailAddressController!.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "We'll send you an email to reset your password.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _model.emailAddressController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _resetPassword,
                  child: Text('Reset Password', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all(Color(0xFF0077B6)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
