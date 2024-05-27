import 'package:flutter/material.dart';
import '../Models/create_account_model.dart';
import '../Services/auth_service.dart';

class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({Key? key}) : super(key: key);

  @override
  _CreateAccountWidgetState createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  late CreateAccountModel _model;
  String? _emailError;
  String? _passwordError;
  String? _usernameError;
  String? _authError; // New field for authentication error

  @override
  void initState() {
    super.initState();
    _model = CreateAccountModel();
    _model.initState(context);

    _model.usernameController = TextEditingController();
    _model.emailAddressController = TextEditingController();
    _model.passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _createAccount() async {
    setState(() {
      _emailError = _model.emailAddressControllerValidator!(context, _model.emailAddressController!.text);
      _passwordError = _model.passwordControllerValidator!(context, _model.passwordController!.text);
      _usernameError = _model.usernameControllerValidator!(context, _model.usernameController!.text);
      _authError = null; // Reset authentication error
    });

    if (_emailError == null && _passwordError == null && _usernameError == null) {
      String? error = await AuthService.register(
        context,
        _model.usernameController!.text,
        _model.emailAddressController!.text,
        _model.passwordController!.text,
      );
      if (error != null) {
        setState(() {
          _authError = error;
        });
      }
    }
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
                  'Create Account',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                if (_authError != null) // Display authentication error
                  Text(
                    _authError!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                SizedBox(height: 10),
                TextField(
                  controller: _model.usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: _usernameError,
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
                    errorText: _emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _model.passwordController,
                  obscureText: !_model.passwordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordError,
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
                  onPressed: _createAccount,
                  child: Text('Create Account', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(0xFF0077B6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'By clicking "Create Account" you agree to CulinaryCraft\'s Terms of Use',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signin');
                  },
                  child: Text(
                    'I already have an account',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
