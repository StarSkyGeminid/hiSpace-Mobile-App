import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/extension/string_extension.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

import 'dart:math' as math;

class Facility extends StatelessWidget {
  const Facility({
    super.key,
    required this.cafe,
  });

  final Cafe cafe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing / 2),
          child:
              Text('Fasilitas', style: Theme.of(context).textTheme.titleMedium),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: math.min(cafe.facilities!.length, 5),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: kDefaultSpacing / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(cafe.facilities![index].iconData),
                  Padding(
                    padding: const EdgeInsets.only(left: kDefaultSpacing / 2),
                    child: Text(cafe.facilities![index].name.toTitleCase()),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
