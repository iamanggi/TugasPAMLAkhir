import 'package:flutter/material.dart';
import 'package:tilik_desa/core/navigations/user_botom_navigation.dart';

class MainUserLayout extends StatefulWidget {
  const MainUserLayout({Key? key}) : super(key: key);

  @override
  State<MainUserLayout> createState() => _MainUserLayoutState();
}

class _MainUserLayoutState extends State<MainUserLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    // HomeUserPage(),
    // LaporPage(),
    // LaporanSayaPage(),
    // MapUserPage(),
    // ProfilUserPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: UserBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
