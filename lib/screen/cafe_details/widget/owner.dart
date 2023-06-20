import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

class Owner extends StatelessWidget {
  const Owner({
    super.key,
    required this.cafe,
  });

  final Cafe cafe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing),
        child: Text(
          'Oleh ${cafe.owner}',
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
