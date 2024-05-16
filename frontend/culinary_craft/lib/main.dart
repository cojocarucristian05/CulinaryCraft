import 'package:culinary_craft_wireframe/Models/change_password_model.dart';
import 'package:culinary_craft_wireframe/Pages/change_password_widget.dart';
import 'package:culinary_craft_wireframe/Pages/create_account_widget.dart';
import 'package:culinary_craft_wireframe/Pages/forgot_password_widget.dart';
import 'package:culinary_craft_wireframe/Pages/onboarding_slideshow_widget.dart';
import 'package:culinary_craft_wireframe/Pages/reset_password_with_code_widget.dart';
import 'package:culinary_craft_wireframe/Pages/view_recipes_widget.dart';
import 'package:culinary_craft_wireframe/Services/recipe_service.dart';
import 'package:culinary_craft_wireframe/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Components/Recipe.dart';
import 'Pages/edit_profile_widget.dart';
import 'Pages/get_started_widget.dart';
import 'Pages/home_widget.dart';
import 'Pages/profile_widget.dart';
import 'Pages/sign_in_widget.dart';
import 'Pages/sign_in_with_google_or_facebook_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 // List<Recipe> testRecipes = RecipeService.getAllRecipesPagination() as List<Recipe>;
  runApp(MaterialApp(
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
      '/forgot_password':(context) => ForgotPasswordWidget(),
      '/reset_password_with_code':(context) => ResetPasswordWithCodeWidget(),
      '/change_password':(context) => ChangePasswordWidget(),
      '/view_recipes': (context) => ViewRecipesWidget(),
    },
  ));
}