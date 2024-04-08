import 'package:flutter/material.dart';
import '../Models/edit_profile_model.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({Key? key}) : super(key: key);

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;

  @override
  void initState() {
    super.initState();
    _model = EditProfileModel();

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
              Navigator.of(context).pushNamed('/profile');
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
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                const Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                const Text(
                  '---- aici se va afisa numele ----',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                // Widget-ul TitleWithSubtitleWidget
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                SizedBox(height: 8),
                const Text(
                  'Receive a link via email to reset your password.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                const SizedBox(height: 14),
                // Butonul de resetare a parolei
                ElevatedButton(
                  onPressed: () async {
                    // Adăugați aici logica pentru resetarea parolei
                    Navigator.of(context).pushNamed('/forgot_password');
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
                const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The data from your account will be deleted.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                SizedBox(height: 12),
                // Butonul de ștergere a contului
                ElevatedButton(
                  onPressed: () async {
                    // Adăugați aici logica pentru ștergerea contului
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFD4D4)),
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
                    'Delete Account',
                    style: TextStyle(
                      color: Color(0xFFB74D4D),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // Utilizăm fontul Roboto
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
