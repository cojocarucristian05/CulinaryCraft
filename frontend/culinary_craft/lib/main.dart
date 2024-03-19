import 'package:culinary_craft_wireframe/Pages/onboarding_slideshow_widget.dart';
import 'package:flutter/material.dart';
import 'Pages/get_started_widget.dart';
import 'Pages/sign_in_with_google_or_facebook_widget.dart';

void main() => runApp(MaterialApp(
  home: GetStartedWidget(),
  routes: {
    '/home': (context) => GetStartedWidget(),
    '/onboarding': (context) => OnboardingSlideshowWidget(),
    '/signin_with_google_or_facebook': (context) => SignInWithGoogleOrFacebookWidget(),
  },
));