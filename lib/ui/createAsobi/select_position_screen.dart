import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'select_datetime_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);

class SelectAsobiPositionScreen extends HookWidget {
  const SelectAsobiPositionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);
    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        body: Center(child: Text('Map')),
        index: 2,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          slidePageTransition(
            context: context,
            to: const SelectAsobiDatetimeScreen(),
          );
        },
        title: 'バショを決める',
      ),
    );
  }
}
