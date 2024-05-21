import 'package:culinary_craft_wireframe/Services/auth_service.dart';
import 'package:flutter/material.dart';

import '../Components/appbar_widget.dart';
import '../Models/profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  @override
  void initState() {
    super.initState();
    _model = ProfileModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: const CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   FutureBuilder<String?>(
                      future: AuthService.getUsername(),
                      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            'Loading...',
                            style: Theme.of(context).textTheme.headline1!,
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: Theme.of(context).textTheme.headline1!,
                          );
                        } else {
                          final username = snapshot.data ?? 'Guest';
                          return Text(
                            'Hello, $username',
                            style: Theme.of(context).textTheme.headline1!,
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 12),
                  _buildProfileButton(
                    icon: Icons.person_outline_rounded,
                    text: 'Edit Profile',
                    onTap: () {
                      Navigator.of(context).pushNamed('/edit_profile');
                    },
                  ),
                  _buildProfileButton(
                    icon: Icons.restaurant_rounded,
                    text: 'My Recipes',
                    onTap: () {
                      Navigator.of(context).pushNamed('/view_my_recipes');
                    },
                  ),
                  _buildProfileButton(
                    icon: Icons.favorite_border_sharp,
                    text: 'Saved Recipes',
                    onTap: () {
                      Navigator.of(context).pushNamed('/view_favorite_recipes');
                    },
                  ),
                  _buildProfileButton(
                    icon: Icons.info_outlined,
                    text: 'About Us',
                    onTap: () {},
                  ),
                  _buildProfileButton(
                    icon: Icons.logout,
                    text: 'Log out',
                    onTap: () {
                      AuthService.logout();
                      Navigator.of(context).pushNamed('/signin_with_google_or_facebook');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildProfileButton(
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFCAF0F8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Color(0xFF0077B6),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ],
        ),
      ),
    );
  }
}
