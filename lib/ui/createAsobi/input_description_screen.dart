import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'select_position_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);
final asobiDescriptionControllerProvider =
    StateProvider<TextEditingController?>((ref) => TextEditingController());

class InputAsobiDescriptionScreen extends HookWidget {
  const InputAsobiDescriptionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);
    final asobiDescriptionController =
        useProvider(asobiDescriptionControllerProvider);
    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        title: 'セツメイを書く',
        body: Body(
          controller: asobiDescriptionController.state!,
        ),
        index: 1,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          if (asobiDescriptionValidation(
              description: asobiDescriptionController.state!.text,
              context: context)) {
            pageTransition(
              context: context,
              to: const SelectAsobiPositionScreen(),
            );
          }
        },
      ),
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

bool asobiDescriptionValidation({
  required String? description,
  required BuildContext context,
}) {
  final isNotDescriptionEmpty = description != "";
  final isDescriptionLengthNotOver = description!.length <= 12;
  final isDescriptionContainsSpace =
      description.contains(" ") || description.contains("　");
  final isDescriptionNotOnlySpace = isDescriptionContainsSpace
      ? isDescriptionContainsSpace && description.trim().isNotEmpty
      : true;
  if (!isNotDescriptionEmpty) {
    showPrimaryDialog(context: context, content: "セツメイを入力してください");
  }
  if (!isDescriptionLengthNotOver) {
    showPrimaryDialog(context: context, content: "20文字以内で！");
  }
  return isNotDescriptionEmpty &&
      isDescriptionLengthNotOver &&
      isDescriptionNotOnlySpace;
}
