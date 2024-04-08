import 'package:flutter/material.dart';
import '../Models/forgot_password_model.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordModel _model;

  // Adăugați inițializarea aici
  _ForgotPasswordWidgetState() {
    _model = ForgotPasswordModel();
    _model.emailAddressController = TextEditingController();
  }

  @override
  void initState() {
    super.initState();

    // Eliminați apelurile Firebase log.
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aliniați textul la stânga
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),

                SizedBox(height: 8),
                const Text(
                  "We'll send you an email to reset your password.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _model.emailAddressController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Butonul de resetare a parolei
                ElevatedButton(
                  onPressed: () async {
                    if (_model.emailAddressController != null) {
                      String emailAddress = _model.emailAddressController!.text;
                      print(emailAddress);
                      // Adăugați aici logica pentru resetarea parolei
                    } else {
                      print("Email address controller is null.");
                    }
                    Navigator.of(context).pushNamed('/reset_password_with_code');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0077B6)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 15),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 0)),
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // Utilizăm fontul Roboto
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
