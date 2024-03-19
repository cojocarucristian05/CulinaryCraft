import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInWithGoogleOrFacebookWidget extends StatefulWidget {
  const SignInWithGoogleOrFacebookWidget({super.key});

  @override
  State<SignInWithGoogleOrFacebookWidget> createState() =>
      _SignInWithGoogleOrFacebookWidgetState();
}

class _SignInWithGoogleOrFacebookWidgetState
    extends State<SignInWithGoogleOrFacebookWidget> {
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
                                // Handle sign up
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
}
