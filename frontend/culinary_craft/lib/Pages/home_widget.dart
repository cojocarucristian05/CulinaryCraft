import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Components/appbar_widget.dart';
import '../Models/home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  @override
  void initState() {
    super.initState();
    _model = HomeModel();

    // On page load action.
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      HapticFeedback.mediumImpact();
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Setează culoarea fundalului pentru AppBar la alb
        elevation: 0, // Elimină umbra AppBar-ului
      ),
      bottomNavigationBar: CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Craft recipes',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Text(
                'Select your ingredients:',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'RecipePage');
                  },
                  child: Text(
                    'Search Recipes',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0077B6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
