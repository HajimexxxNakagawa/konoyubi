import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/app.dart';

class BottomNav extends HookWidget {
  const BottomNav({Key? key, required this.index}) : super(key: key);

  final int index;

  static const _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
    BottomNavigationBarItem(icon: Icon(Icons.map), label: 'map'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'person'),
  ];

  @override
  Widget build(BuildContext context) {
    final tabType = useProvider(tabTypeProvider);
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int selectIndex) {
        tabType.state = TabType.values[selectIndex];
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: _navItems,
    );
  }
}
