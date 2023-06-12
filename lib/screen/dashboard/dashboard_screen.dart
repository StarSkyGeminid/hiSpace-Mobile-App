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
          body: _pages[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54.withOpacity(0.05),
                    blurRadius: 15.0,
                    offset: const Offset(0.0, 0.1))
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              useLegacyColorScheme: false,
              currentIndex: _currentIndex,
              onTap: _changePage,
              backgroundColor: Theme.of(context).colorScheme.background,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedIconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.tertiary),
              unselectedLabelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.background),
              showUnselectedLabels: false,
              iconSize: 18,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/dashboard_icon.svg',
                    colorFilter: _currentIndex != 0
                        ? null
                        : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    height: 22,
                    width: 22,
                  ),
                  label: '•',
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/favorite_icon.svg',
                    colorFilter: _currentIndex != 1
                        ? null
                        : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    height: 22,
                    width: 22,
                  ),
                  label: '•',
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/message_icon.svg',
                    colorFilter: _currentIndex != 2
                        ? null
                        : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    height: 22,
                    width: 22,
                  ),
                  label: '•',
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/profile_icon.svg',
                    colorFilter: _currentIndex != 3
                        ? null
                        : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    height: 22,
                    width: 22,
                  ),
                  label: '•',
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
              ],
            ),
          )),
    );
  }
}
