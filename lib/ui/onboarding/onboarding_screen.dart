import 'package:flutter/material.dart';
import 'package:konoyubi/app.dart';
import 'package:konoyubi/ui/components/typography.dart';
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
          const Spacer(flex: 4),
          const OnboardingCarousel(),
          const Spacer(flex: 3),
          const Text('Create your account'),
          const Spacer(flex: 1),
          const SignInIcons(),
          const Spacer(flex: 3),
          ActionText(
            'Skip now',
            onPressed: () {
              fadeAndReplacePage(context: context);
            },
          ),
          const Spacer(flex: 6),
        ],
      ),
    );
  }
}
