import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'select_tag_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);

class SelectAsobiDatetimeScreen extends HookWidget {
  const SelectAsobiDatetimeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);
    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        body: Center(child: Text('DateTime')),
        index: 3,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          slidePageTransition(
            context: context,
            to: const SelectAsobiTagScreen(),
          );
        },
        title: 'ジカンを決める',
      ),
    );
  }
}
