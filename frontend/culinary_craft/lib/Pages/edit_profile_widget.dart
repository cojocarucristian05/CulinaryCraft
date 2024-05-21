import 'package:flutter/material.dart';
import '../Models/edit_profile_model.dart';
import '../Services/auth_service.dart';

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
                  'Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Utilizăm fontul Roboto
                  ),
                ),
                FutureBuilder<String?>(
                  future: AuthService.getEmail(),
                  builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading...',
                        style: Theme.of(context).textTheme.bodyText1!,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: Theme.of(context).textTheme.bodyText1!,
                      );
                    } else {
                      final email = snapshot.data ?? 'Guest';
                      return Text(
                        '$email',
                        style: Theme.of(context).textTheme.bodyText1!,
                      );
                    }
                  },
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
                    // Adăugați aici logica pentru afișarea dialogului de confirmare
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteAccountConfirmationDialog();
                      },
                    );
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



class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Account"),
      content: Text("Are you sure you want to delete your account?"),
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Dezactivează contul și închide dialogul
                await AuthService.deactivateAccount();
                Navigator.of(context).pushNamed('/signin_with_google_or_facebook');
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
              ),
              child: const Text(
                'Deactivate Account',
                style: TextStyle(
                  color: Color(0xFFB74D4D),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 10), // Spațiu între butoane
            ElevatedButton(
              onPressed: () async {
                // Șterge contul și închide dialogul
                await AuthService.deleteAccount();
                Navigator.of(context).pushNamed('/signin_with_google_or_facebook');
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
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Color(0xFFB74D4D),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

