import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/widget/rating_star.dart';

class CafeInformation extends StatelessWidget {
  const CafeInformation({super.key, required this.cafe});

  final Cafe cafe;

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
                cafe.name,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
              ),
            ),
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
        Divider(color: ColorPallete.light.grey3),
        Row(
          children: [
            Text(
              cafe.owner,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Divider(color: ColorPallete.light.grey3),
        Text('Deskripsi', style: Theme.of(context).textTheme.titleSmall),
        Text(
          cafe.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Divider(color: ColorPallete.light.grey3),
        if (cafe.menus != null)
          ListView.builder(
            shrinkWrap: true,
            itemCount: cafe.menus!.length,
            itemBuilder: (context, index) {
              return Text(cafe.menus![index].name);
            },
          ),
      ],
    );
  }
}
