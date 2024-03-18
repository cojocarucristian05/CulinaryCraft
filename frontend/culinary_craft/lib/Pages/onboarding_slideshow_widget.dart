import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/onboarding_slideshow_model.dart';
export '../Models/onboarding_slideshow_model.dart';

class OnboardingSlideshowWidget extends StatefulWidget {
  const OnboardingSlideshowWidget({Key? key}) : super(key: key);

  @override
  State<OnboardingSlideshowWidget> createState() => _OnboardingSlideshowWidgetState();
}

class _OnboardingSlideshowWidgetState extends State<OnboardingSlideshowWidget> {
  late OnboardingSlideshowModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = OnboardingSlideshowModel();

    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {}));
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
        key: scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cook with inspiration, flavor, and ease - discover new tastes every day!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Image.asset(
                          'assets/images/Chef-Illustration-1.jpg',
                          width: 250,
                          height: 250,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Introducing our innovative recipe app! With a vast collection of culinary delights from around the world, cooking has never been easier or more exciting.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();

                            // Navigator.of(context).pushNamed('Onboarding_Slideshow');
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                            backgroundColor: MaterialStateProperty.all(Color(0xFF0077B6)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Continue',
                              style: GoogleFonts.roboto(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
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
      ),
    );
  }
}
