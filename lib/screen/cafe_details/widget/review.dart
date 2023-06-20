import 'package:flutter/material.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

import 'dart:math' as math;

class ReviewView extends StatelessWidget {
  const ReviewView({
    super.key,
    required this.reviews,
  });

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing / 2),
          child: Text('Ulasan', style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: math.min(reviews.length, 5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: kDefaultSpacing),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviews[index].userId,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      _RatingStar(review: reviews[index]),
                      const SizedBox(height: kDefaultSpacing / 2),
                      Flexible(
                        child: Text(
                          reviews[index].review,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RatingStar extends StatelessWidget {
  const _RatingStar({
    super.key,
    required this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, ratingIndex) => GestureDetector(
          child: Icon(
            review.rating >= ratingIndex ? Icons.star : Icons.star_border,
            color: ColorPallete.light.yellow,
            size: 25,
          ),
        ),
      ),
    );
  }
}
