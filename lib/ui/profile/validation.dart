import 'package:flutter/material.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

bool nameValidation({
  required String? name,
  required BuildContext context,
  required L10n l10n,
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
  required L10n l10n,
}) {
  final isBiographyTooLong = biography!.length >= 10000;

  if (isBiographyTooLong) {
    showPrimaryDialog(context: context, content: l10n.tooLongIntroduction);
  }

  return !isBiographyTooLong;
}
