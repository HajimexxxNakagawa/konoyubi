import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/ui/home/home_screen.dart';
import 'package:konoyubi/ui/map/map_screen.dart';
import 'package:konoyubi/ui/profile/profile_screen.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TabType { home, map, profile }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.home);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'konoyubi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScreenContainer extends HookWidget {
  const ScreenContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabType = useProvider(tabTypeProvider);

    final _appBars = [
      styledAppBar('Home'),
      styledAppBar('アソビを探す'),
      styledAppBar('セッテイ'),
    ];

    const _views = [
      HomeScreen(),
      MapScreen(),
      ProfileScreen(),
    ];

    const _navItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
      BottomNavigationBarItem(icon: Icon(Icons.map), label: 'map'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'person'),
    ];

    final _actionButtons = [
      const AddButton(),
      const SizedBox(),
      const SizedBox(),
    ];

    return Scaffold(
      appBar: _appBars[tabType.state.index],
      body: _views[tabType.state.index],
      floatingActionButton: _actionButtons[tabType.state.index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabType.state.index,
        onTap: (int selectIndex) {
          tabType.state = TabType.values[selectIndex];
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: _navItems,
      ),
    );
  }
}

AppBar styledAppBar(String title) {
  return AppBar(
    title: Text(title, style: const TextStyle(color: Colors.black)),
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
  );
}
