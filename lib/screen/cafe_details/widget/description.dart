import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

class Description extends StatelessWidget {
  const Description({
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
              Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium),
        ),
        Text(
          cafe.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
