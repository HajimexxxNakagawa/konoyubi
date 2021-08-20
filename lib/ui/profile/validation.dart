import 'package:flutter/material.dart';
import 'package:konoyubi/ui/home/asobi_detail_screen.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';

bool nameValidation({
  required String? name,
  required BuildContext context,
}) {
  final isNotNameEmpty = name != "";
  final isNameLengthNotOver = name!.length <= 12;
  final isNameContainsSpace = name.contains(" ") || name.contains("　");
  final isNameNotOnlySpace = isNameContainsSpace
      ? isNameContainsSpace && name.trim().isNotEmpty
      : true;
  if (!isNotNameEmpty) {
    showPrimaryDialog(context: context, content: l10n.inputYourName);
  } else if (!isNameLengthNotOver) {
    showPrimaryDialog(context: context, content: l10n.underTwelveLetter);
  } else if (!isNameNotOnlySpace) {
    showPrimaryDialog(context: context, content: l10n.notOnlySpace);
  }

  return isNotNameEmpty && isNameLengthNotOver && isNameNotOnlySpace;
}

// 正しくない入力でも遷移できないだけだから、validetionはかけない。
// twitterValidation() {}
// facebookValidation(){}

bool biographyValidation({
  required String? biography,
  required BuildContext context,
}) {
  final isBiographyTooLong = biography!.length >= 10000;

  if (isBiographyTooLong) {
    showPrimaryDialog(context: context, content: l10n.tooLongIntroduction);
  }

  return !isBiographyTooLong;
}
