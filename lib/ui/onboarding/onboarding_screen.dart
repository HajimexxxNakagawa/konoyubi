import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'onboarding_carousel.dart';
import 'sign_in_icons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(flex: 2),
          const OnboardingCarousel(),
          const Spacer(),
          const H1('Create your account'),
          const Spacer(flex: 1),
          const SignInIcons(),
          const Spacer(flex: 1),
          ActionText(
            'Skip now',
            onPressed: () {
              fadeAndReplacePage(context: context);
            },
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
