import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home/home_screen.dart';
import '../message/message_screen.dart';
import '../profile/profile_screen.dart';
import '../wishlist/wishlist_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const WishlistScreen(),
    const MessageScreen(),
    const ProfileScreen(),
  ];

  int _currentIndex = 0;

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            useLegacyColorScheme: false,
            currentIndex: _currentIndex,
            onTap: _changePage,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedIconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.tertiary),
            unselectedLabelStyle:
                TextStyle(color: Theme.of(context).colorScheme.background),
            showUnselectedLabels: true,
            iconSize: 25,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/dashboard_icon.svg',
                  colorFilter: _currentIndex != 0
                      ? null
                      : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                label: '•',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/favorite_icon.svg',
                  colorFilter: _currentIndex != 1
                      ? null
                      : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                label: '•',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/message_icon.svg',
                  colorFilter: _currentIndex != 2
                      ? null
                      : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                label: '•',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/profile_icon.svg',
                  colorFilter: _currentIndex != 3
                      ? null
                      : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                label: '•',
              ),
            ],
          )),
    );
  }
}
