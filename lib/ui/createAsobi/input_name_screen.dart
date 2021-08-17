import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'input_description_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);
final asobiNameControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());

class InputAsobiNameScreen extends HookWidget {
  const InputAsobiNameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);
    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        title: 'アソビを作る',
        body: const Body(),
        index: 0,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          pageTransition(
            context: context,
            to: const InputAsobiDescriptionScreen(),
          );
        },
      ),
    );
  }
}

class Body extends HookWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asobiNameController = useProvider(asobiNameControllerProvider);
    return Center(
      child: TextField(
        controller: asobiNameController.state,
      ),
    );
  }
}
