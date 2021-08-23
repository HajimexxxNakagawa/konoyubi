import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/components/styled_text_field.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'select_position_screen.dart';

final asobiDescriptionControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());

class InputAsobiDescriptionScreen extends HookWidget {
  const InputAsobiDescriptionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final asobiDescriptionController =
        useProvider(asobiDescriptionControllerProvider);

    bool _validation({
      required String? description,
      required BuildContext context,
    }) {
      final isNotDescriptionEmpty = description != "";
      final isDescriptionLengthNotOver = description!.length <= 200;
      final isDescriptionContainsSpace =
          description.contains(" ") || description.contains("　");
      final isDescriptionNotOnlySpace = isDescriptionContainsSpace
          ? isDescriptionContainsSpace && description.trim().isNotEmpty
          : true;
      if (!isNotDescriptionEmpty) {
        showPrimaryDialog(context: context, content: l10n.inputDescription);
      }
      if (!isDescriptionLengthNotOver) {
        showPrimaryDialog(context: context, content: l10n.underThirty);
      }
      if (!isDescriptionNotOnlySpace) {
        showPrimaryDialog(context: context, content: l10n.notOnlySpace);
      }
      return isNotDescriptionEmpty &&
          isDescriptionLengthNotOver &&
          isDescriptionNotOnlySpace;
    }

    return CreateAsobiScreenTemplate(
      title: l10n.writeAboutAsobi,
      body: Body(
        controller: asobiDescriptionController.state!,
      ),
      index: 1,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        final isValid = _validation(
          description: asobiDescriptionController.state!.text,
          context: context,
        );
        if (isValid) {
          pageTransition(
            context: context,
            to: const SelectAsobiPositionScreen(),
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
          const H1("ワクワクするセツメイを書こう！"),
          const SizedBox(height: 16),
          StyledTextField(
            controller: controller,
            maxLines: 8,
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
