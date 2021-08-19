import 'package:flutter/material.dart';
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
    showPrimaryDialog(context: context, content: "名前を入力してください");
  } else if (!isNameLengthNotOver) {
    showPrimaryDialog(context: context, content: "名前は12文字以下で！");
  } else if (!isNameNotOnlySpace) {
    showPrimaryDialog(context: context, content: "空白だけの名前はダメだよ！");
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
    showPrimaryDialog(context: context, content: "自己紹介文が長すぎる！");
  }

  return !isBiographyTooLong;
}
