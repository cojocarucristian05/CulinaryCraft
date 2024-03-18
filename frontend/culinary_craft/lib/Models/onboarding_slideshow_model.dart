//import '/Components/custom_appbar_widget.dart';
import '../Pages/onboarding_slideshow_widget.dart' show OnboardingSlideshowWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardingSlideshowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
      pageViewController!.hasClients &&
      pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
  }

  @override
  void dispose() {
    unfocusNode.dispose();
  }

/// Action blocks are added here.

/// Additional helper methods are added here.
}
