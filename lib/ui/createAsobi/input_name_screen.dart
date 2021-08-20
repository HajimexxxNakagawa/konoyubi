import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'input_description_screen.dart';

final asobiNameControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());

final l10n = useL10n();

class InputAsobiNameScreen extends HookWidget {
  const InputAsobiNameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final asobiNameController = useProvider(asobiNameControllerProvider);
    final l10n = useL10n();

    return CreateAsobiScreenTemplate(
      title: l10n.createAsobi,
      body: Body(
        controller: asobiNameController.state!,
      ),
      index: 0,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        if (asobiNameValidation(
            name: asobiNameController.state!.text, context: context)) {
          pageTransition(
            context: context,
            to: const InputAsobiDescriptionScreen(),
          );
        }
      },
    );
  }
}

class Body extends HookWidget {
  const Body({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        controller: controller,
      ),
    );
  }
}

bool asobiNameValidation({
  required String? name,
  required BuildContext context,
}) {
  final isNotNameEmpty = name != "";
  final isNameLengthNotOver = name!.length <= 20;
  final isNameContainsSpace = name.contains(" ") || name.contains("　");
  final isNameNotOnlySpace = isNameContainsSpace
      ? isNameContainsSpace && name.trim().isNotEmpty
      : true;
  if (!isNotNameEmpty) {
    showPrimaryDialog(context: context, content: l10n.inputAsobiName);
  }
  if (!isNameLengthNotOver) {
    showPrimaryDialog(context: context, content: l10n.underTwenty);
  }
  return isNotNameEmpty && isNameLengthNotOver && isNameNotOnlySpace;
}
