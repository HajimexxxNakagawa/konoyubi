import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/theme/height_width.dart';

class H1 extends HookWidget {
  const H1(
    this.text, {
    Key? key,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.overflow = TextOverflow.ellipsis,
    this.color = bodyColor,
  }) : super(key: key);

  final String text;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double width = useWidth();

    return Text(
      text,
      style: TextStyle(
        fontSize: width * 0.05,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      maxLines: 1,
      textAlign: textAlign,
    );
  }
}

class Body1 extends HookWidget {
  const Body1(
    this.text, {
    Key? key,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.isBold = false,
  }) : super(key: key);

  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final double width = useWidth();

    return Text(
      text,
      style: TextStyle(
        fontSize: width * 0.036,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: bodyColor,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

class ActionText extends HookWidget {
  const ActionText(
    this.text, {
    Key? key,
    required this.onPressed,
    this.maxLines = 1,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;
  final int maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final double width = useWidth();

    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: width * 0.035, color: accentColor),
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow,
      ),
    );
  }
}
