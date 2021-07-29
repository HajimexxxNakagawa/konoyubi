import 'package:flutter/material.dart';
import 'package:konoyubi/app.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'onboarding_carousel.dart';
import 'sign_in_icons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 4),
          OnboardingCarousel(),
          Spacer(flex: 3),
          Text('Create your account'),
          Spacer(flex: 1),
          SignInIcons(),
          Spacer(flex: 3),
          TextButton(
            onPressed: () {
              pageTransition(context: context, to: ScreenContainer());
            },
            child: Text('Skip now'),
          ),
          Spacer(flex: 6),
        ],
      ),
    );
  }
}
