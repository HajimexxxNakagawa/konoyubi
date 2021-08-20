import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/components/styled_text_field.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'input_description_screen.dart';

final asobiNameControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());

class InputAsobiNameScreen extends HookWidget {
  const InputAsobiNameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final asobiNameController = useProvider(asobiNameControllerProvider);

    return CreateAsobiScreenTemplate(
      title: 'アソビを作る',
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
    showPrimaryDialog(context: context, content: "アソビの名前を入力してね");
  }
  if (!isNameLengthNotOver) {
    showPrimaryDialog(context: context, content: "20文字以内で！");
  }
  return isNotNameEmpty && isNameLengthNotOver && isNameNotOnlySpace;
}
