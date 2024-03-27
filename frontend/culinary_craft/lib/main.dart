import 'package:culinary_craft_wireframe/Pages/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:culinary_craft_wireframe/Pages/create_account_widget.dart';
import 'package:culinary_craft_wireframe/Pages/home_widget.dart';
import 'package:culinary_craft_wireframe/Pages/onboarding_slideshow_widget.dart';
import 'package:culinary_craft_wireframe/Pages/sign_in_widget.dart';
import 'package:culinary_craft_wireframe/Pages/sign_in_with_google_or_facebook_widget.dart';


import 'Components/appbar_widget.dart';
import 'Pages/edit_profile_widget.dart';
import 'Pages/get_started_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetStartedWidget(),
      routes: {
        '/start': (context) => GetStartedWidget(),
        '/onboarding': (context) => OnboardingSlideshowWidget(),
        '/signin_with_google_or_facebook': (context) => SignInWithGoogleOrFacebookWidget(),
        '/signin': (context) => SignInWidget(),
        '/signup': (context) => CreateAccountWidget(),
        '/profile': (context) => ProfileWidget(),
        '/home': (context) => HomeWidget(),
        '/edit_profile': (context) => EditProfileWidget(),
        // Adăugați alte rute numite pentru alte pagini care utilizează CustomAppbarWidget
      },
    );
  }
}
