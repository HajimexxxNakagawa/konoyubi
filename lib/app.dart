import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/home/home_screen.dart';
import 'package:konoyubi/ui/map/map_screen.dart';
import 'package:konoyubi/ui/profile/user_screen.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'auth/user.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class App extends HookWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;

    return MaterialApp(
      title: 'konoyubi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isSignedIn ? const ScreenContainer() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
    );
  }
}

enum TabType { home, map, profile }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.home);

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
      UserSceen(),
    ];

    const _drawers = [ 
      SizedBox(),
      SizedBox(),
      SettingDrawer(),
    ];

    const _navItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
      BottomNavigationBarItem(icon: Icon(Icons.map), label: 'map'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'person'),
    ];

    const _actionButtons = [
      AddButton(),
      SizedBox(),
      SizedBox(),
    ];

    return Scaffold(
      appBar: _appBars[tabType.state.index],
      endDrawer: _drawers[tabType.state.index],
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

class SettingDrawer extends HookWidget {
  const SettingDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;
    return Drawer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.mode_edit,
                color: bodyColor,
              ),
              label: const Text(
                "Edit Profile",
                style: TextStyle(color: accentColor),
              ),
            ),
            isSignedIn
                ? TextButton.icon(
                    onPressed: () {
                      signOut(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: bodyColor,
                    ),
                    label: const Text(
                      "Sign Out",
                      style: TextStyle(color: accentColor),
                    ),
                  )
                : TextButton.icon(
                    onPressed: () {
                      promptSignIn(context);
                    },
                    icon: const Icon(
                      Icons.login,
                      color: bodyColor,
                    ),
                    label: const Text(
                      "Sign In",
                      style: TextStyle(color: accentColor),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

AppBar styledAppBar(String title) {
  return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.black)),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: bodyColor,
      ));
}
