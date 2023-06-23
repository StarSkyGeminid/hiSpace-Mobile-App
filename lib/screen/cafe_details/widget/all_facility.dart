import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/extension/string_extension.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

class AllFacility extends StatelessWidget {
  const AllFacility({super.key, required this.facilities});

  final List<Facility> facilities;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text(
            'Fasilitas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: ListView.builder(
          itemCount: facilities.length,
          padding: const EdgeInsets.fromLTRB(
              kDefaultSpacing, 0, kDefaultSpacing, kDefaultSpacing),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: kDefaultSpacing / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(facilities[index].iconData, size: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: kDefaultSpacing / 2),
                    child: Text(facilities[index].name.toTitleCase()),
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
