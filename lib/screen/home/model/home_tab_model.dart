import 'package:flutter/material.dart';

class HomeTabModel {
  final String name;
  final IconData icon;

  const HomeTabModel({
    required this.name,
    required this.icon,
  });
}

List<HomeTabModel> listHomeTabModel = [
  const HomeTabModel(name: 'Recomendasi', icon: Icons.recommend),
  const HomeTabModel(name: 'Terfavorit', icon: Icons.favorite_border_rounded),
  const HomeTabModel(name: 'Rating', icon: Icons.star_border_rounded),
];
