import 'package:flutter/material.dart';

class ProfileMenuModel {
  final String title;
  final IconData icon;
  final String route;

  ProfileMenuModel(
      {required this.title, required this.icon, required this.route});
}

List<ProfileMenuModel> listProfileMenu = [
  ProfileMenuModel(
    title: 'Akun',
    icon: Icons.person_outline_outlined,
    route: '/user/settings',
  ),
  ProfileMenuModel(
    title: 'Kafe Saya',
    icon: Icons.storefront_outlined,
    route: '/user/cafe-owned',
  ),
  ProfileMenuModel(
    title: 'Persyaratan dan Ketentuan',
    icon: Icons.policy_outlined,
    route: '/profile_settings',
  ),
  ProfileMenuModel(
    title: 'Lisensi Open Source',
    icon: Icons.policy,
    route: '/licenses',
  ),
  ProfileMenuModel(
    title: 'Keluar',
    icon: Icons.logout_rounded,
    route: '/profile_settings',
  ),
];
