import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// デバイス（SafeArea）の高さを取得する
double useHeight() {
  final context = useContext();
  final height = MediaQuery.of(context).size.height;
  final padding = MediaQuery.of(context).padding;
  final safeAreaHeight = height - padding.top - padding.bottom;

  return safeAreaHeight;
}

/// デバイス（SafeArea）の横幅を取得する
double useWidth() {
  final context = useContext();
  final width = MediaQuery.of(context).size.width;

  return width;
}
