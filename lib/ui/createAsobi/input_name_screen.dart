import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'input_description_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);

class InputAsobiNameScreen extends HookWidget {
  const InputAsobiNameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);
    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        body: Center(child: Text('ナマエ')),
        index: 0,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          slidePageTransition(
            context: context,
            to: const InputAsobiDescriptionScreen(),
          );
        },
        title: 'アソビを作る',
      ),
    );
  }
}
