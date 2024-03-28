import 'package:culinary_craft_wireframe/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogleOrFacebookWidget extends StatefulWidget {
  const SignInWithGoogleOrFacebookWidget({super.key});

  @override
  State<SignInWithGoogleOrFacebookWidget> createState() =>
      _SignInWithGoogleOrFacebookWidgetState();
}

class _SignInWithGoogleOrFacebookWidgetState
    extends State<SignInWithGoogleOrFacebookWidget> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  // User? user;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   auth.authStateChanges().listen((event) {
  //     setState(() {
  //       user = event;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sau orice culoare dorești
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/icon2.png',
                          width: 208,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Handle continue with Google
                            _handleGoogleSignIn();
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 50),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all(Color(0xFF90E0EF)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Continue with Google',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Handle continue with Facebook
                            print("Facebook signed in successfully!");
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 50),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all(Color(0xFF90E0EF)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Continue with Facebook',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                Navigator.of(context).pushNamed('/signin');
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                  Size(170, 50),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xFF0077B6)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pushNamed('/signup');
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                  Size(170, 50),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xFF0077B6)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        // Sign in with Firebase Auth
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        // Extract user's email and name
        final String? userEmail = user?.email;
        final String? userName = user?.displayName;

        // Print or use user's email and name
        print("User email: $userEmail");
        print("User name: $userName");

        print("Sign in successfully!");
        Navigator.pushNamed(context, "/home");
      }
    } catch(e) {
      print(e);
      // showToast()
    }
  }
}
