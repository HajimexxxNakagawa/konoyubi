import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

double useHeight() {
  final context = useContext();
  final height = MediaQuery.of(context).size.height;
  final padding = MediaQuery.of(context).padding;
  final safeAreaHeight = height - padding.top - padding.bottom;

  return safeAreaHeight;
}

double useWidth() {
  final context = useContext();
  final width = MediaQuery.of(context).size.width;

  return width;
}
