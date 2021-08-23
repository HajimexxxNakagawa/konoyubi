import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/components/styled_text_field.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'input_description_screen.dart';

final asobiNameControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());

class InputAsobiNameScreen extends HookWidget {
  const InputAsobiNameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final asobiNameController = useProvider(asobiNameControllerProvider);
    final l10n = useL10n(context);

    bool _validation({
      required String? name,
      required BuildContext context,
    }) {
      //final l10n = useL10n(context);
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
      if (!isNameNotOnlySpace) {
        showPrimaryDialog(context: context, content: l10n.notOnlySpace);
      }
      return isNotNameEmpty && isNameLengthNotOver && isNameNotOnlySpace;
    }

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
        final isValid = _validation(
          name: asobiNameController.state!.text,
          context: context,
        );
        if (isValid) {
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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 4),
          const H1("魅力的なナマエを付けよう！"),
          const SizedBox(height: 16),
          StyledTextField(controller: controller),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
