import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/extension/string_extension.dart';
import 'package:hispace_mobile_app/screen/cafe_details/cafe_details.dart';
import 'package:hispace_mobile_app/widget/rating_star.dart';

class DetailsTitle extends StatelessWidget {
  const DetailsTitle({
    super.key,
    required this.cafe,
    required this.type,
  });

  final Cafe cafe;

  final CafeDetailsType type;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width * 0.8,
              child: Text(
                cafe.name.toTitleCase(),
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
              ),
            ),
            if (type != CafeDetailsType.owner)
              Icon(
                cafe.isFavorite
                    ? Icons.favorite_border_rounded
                    : Icons.favorite_border_rounded,
              ),
          ],
        ),
        Row(
          children: [
            RatingStar(rating: cafe.rating),
            Text(
              ' (${(cafe.reviews?.length ?? 0.0).toStringAsFixed(1)})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Text(
          cafe.address,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
