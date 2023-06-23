import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/extension/string_extension.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:intl/intl.dart';

class AllMenu extends StatelessWidget {
  const AllMenu({super.key, required this.menus});

  final List<Menu> menus;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text(
            'Menu',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: ListView.builder(
          itemCount: menus.length,
          padding: const EdgeInsets.fromLTRB(
              kDefaultSpacing, 0, kDefaultSpacing, kDefaultSpacing),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: kDefaultSpacing / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(menus[index].name.toTitleCase()),
                  Padding(
                    padding: const EdgeInsets.only(left: kDefaultSpacing / 2),
                    child: Text(NumberFormat.simpleCurrency(name: 'IDR')
                        .format(menus[index].price)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
