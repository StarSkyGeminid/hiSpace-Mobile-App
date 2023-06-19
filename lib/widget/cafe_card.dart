import 'package:cafe_api/cafe_api.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/extension/string_extension.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/rating_star.dart';

import 'carousel_image.dart';

class CafeCard extends StatelessWidget {
  const CafeCard({
    super.key,
    required this.cafe,
    required this.onTap,
    this.onToggleFavorite,
    this.distance,
  });

  final Cafe cafe;

  final VoidCallback onTap;

  final VoidCallback? onToggleFavorite;

  final String? distance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(kDefaultSpacing),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CarousselImageCard(
              cafe: cafe,
              distance: distance,
              onToggleFavorite: onToggleFavorite,
            ),
            Padding(
              padding: const EdgeInsets.only(top: kDefaultSpacing / 2),
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * 0.7,
                    child: Text(
                      cafe.name.toTitleCase(),
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Spacer(),
                  RatingStar(
                    rating: cafe.rating,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.7,
              child: Text(
                cafe.address.toTitleCase(),
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kDefaultSpacing / 4),
              child: Row(
                children: [
                  Text(
                    'Rp12k - Rp35k',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultSpacing / 2),
                    child: Text(
                      '•',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.schedule_rounded),
                  Padding(
                    padding: const EdgeInsets.only(left: kDefaultSpacing / 2),
                    child: Text(
                      cafe.time.isOpenNow ? 'Buka' : 'Tutup',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarousselImageCard extends StatelessWidget {
  const _CarousselImageCard({
    required this.cafe,
    this.distance,
    this.onToggleFavorite,
  });

  final VoidCallback? onToggleFavorite;

  final Cafe cafe;

  final String? distance;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            CarousselImage(
              cafePictureModel: cafe.galeries ?? [],
            ),
            if (distance != null)
              Positioned(
                top: kDefaultSpacing,
                left: kDefaultSpacing,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultSpacing / 2,
                    vertical: kDefaultSpacing / 3,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      Text(
                        distance ?? '0.0 km',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            if (onToggleFavorite != null)
              Positioned(
                top: kDefaultSpacing,
                right: kDefaultSpacing,
                child: InkWell(
                  onTap: onToggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(kDefaultSpacing / 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      cafe.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: cafe.isFavorite ? ColorPallete.light.red : null,
                      size: 25,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
