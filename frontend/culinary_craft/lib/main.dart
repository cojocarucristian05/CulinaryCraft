import 'package:culinary_craft_wireframe/Models/change_password_model.dart';
import 'package:culinary_craft_wireframe/Pages/change_password_widget.dart';
import 'package:culinary_craft_wireframe/Pages/create_account_widget.dart';
import 'package:culinary_craft_wireframe/Pages/forgot_password_widget.dart';
import 'package:culinary_craft_wireframe/Pages/onboarding_slideshow_widget.dart';
import 'package:culinary_craft_wireframe/Pages/reset_password_with_code_widget.dart';
import 'package:culinary_craft_wireframe/Pages/view_recipes_widget.dart';
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
  List<Recipe> testRecipes = [
    Recipe(
      name: 'Pasta Carbonara',
      description: '''STEP 1
        Put a large saucepan of water on to boil.

    STEP 2
        Finely chop the 100g pancetta, having first removed any rind. Finely grate 50g pecorino cheese and 50g parmesan and mix them together.

    STEP 3
    Beat the 3 large eggs in a medium bowl and season with a little freshly grated black pepper. Set everything aside.

    STEP 4
    Add 1 tsp salt to the boiling water, add 350g spaghetti and when the water comes back to the boil, cook at a constant simmer, covered, for 10 minutes or until al dente (just cooked).

    STEP 5
  Squash 2 peeled plump garlic cloves with the blade of a knife, just to bruise it.

  STEP 6
  While the spaghetti is cooking, fry the pancetta with the garlic. Drop 50g unsalted butter into a large frying pan or wok and, as soon as the butter has melted, tip in the pancetta and garlic.

  STEP 7
  Leave to cook on a medium heat for about 5 minutes, stirring often, until the pancetta is golden and crisp. The garlic has now imparted its flavour, so take it out with a slotted spoon and discard.

  STEP 8
  Keep the heat under the pancetta on low. When the pasta is ready, lift it from the water with a pasta fork or tongs and put it in the frying pan with the pancetta. Don’t worry if a little water drops in the pan as well (you want this to happen) and don’t throw the pasta water away yet.

  STEP 9
  Mix most of the cheese in with the eggs, keeping a small handful back for sprinkling over later.

  STEP 10
  Take the pan of spaghetti and pancetta off the heat. Now quickly pour in the eggs and cheese. Using the tongs or a long fork, lift up the spaghetti so it mixes easily with the egg mixture, which thickens but doesn’t scramble, and everything is coated.

  STEP 11
  Add extra pasta cooking water to keep it saucy (several tablespoons should do it). You don’t want it wet, just moist. Season with a little salt, if needed.

  STEP 12
  Use a long-pronged fork to twist the pasta on to the serving plate or bowl. Serve immediately with a little sprinkling of the remaining cheese and a grating of black pepper. If the dish does get a little dry before serving, splash in some more hot pasta water and the glossy sauciness will be revived.''',
      imageURL: 'https://www.retetepractice.ro/wp-content/uploads/2017/08/Paste-Carbonara-reteta-originala.jpg',
    ),
    Recipe(
      name: 'Chicken Alfredo',
      description: 'Creamy chicken pasta',
      imageURL: 'https://hips.hearstapps.com/hmg-prod/images/chicken-alfredo-index-64ee1026c82a9.jpg?crop=0.9994472084024323xw:1xh;center,top&resize=1200:*',
    ),
    Recipe(
      name: 'Chocolate Cake',
      description: 'Decadent chocolate dessert',
      imageURL: 'https://hips.hearstapps.com/hmg-prod/images/chocolate-cake-index-64b83bce2df26.jpg?crop=0.8891145524808891xw:1xh;center,top&resize=1200:*',
    ),
    // Mai adaugă alte rețete dacă dorești
  ];
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
      '/view_recipes': (context) => ViewRecipesWidget(recipes: testRecipes),
    },
  ));
}