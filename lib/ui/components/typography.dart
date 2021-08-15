import 'package:flutter/material.dart';
import 'package:konoyubi/ui/theme/constants.dart';

class H1 extends StatelessWidget {
  const H1(
    this.text, {
    Key? key,
    this.maxLines = 1,
    this.textAlign,
    this.overflow,
    this.color = bodyColor,
  }) : super(key: key);

  final String text;
  final int maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Text(
      text,
      style: TextStyle(
        fontSize: width * 0.05,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      maxLines: 1,
      textAlign: textAlign,
    );
  }
}

class Body1 extends StatelessWidget {
  const Body1(this.text,
      {Key? key,
      this.maxLines,
      this.textAlign,
      this.overflow,
      this.isBold = false,
      this.color = bodyColor})
      : super(key: key);

  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool isBold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Text(
      text,
      style: TextStyle(
        fontSize: width * 0.036,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

class ActionText extends StatelessWidget {
  const ActionText(
    this.text, {
    Key? key,
    required this.onPressed,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.overflow,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;
  final int maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
