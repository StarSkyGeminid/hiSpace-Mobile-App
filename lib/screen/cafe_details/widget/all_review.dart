import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/circular_profile_picture.dart';
import 'package:intl/intl.dart';

class AllReviews extends StatelessWidget {
  const AllReviews({super.key, required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text(
            'Ulasan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: ListView.builder(
          itemCount: reviews.length,
          padding: const EdgeInsets.only(
            left: kDefaultSpacing,
            top: kDefaultSpacing / 2,
            right: kDefaultSpacing,
            bottom: kDefaultSpacing,
          ),
          itemBuilder: (context, index) {
            return Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: kDefaultSpacing / 2),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircularProfilePicture(
                          maxSize: 50,
                          isCached: false,
                          url: reviews[index].user.profilePic,
                        ),
                        const SizedBox(width: kDefaultSpacing / 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reviews[index].user.fullname,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            _RatingStar(review: reviews[index]),
                            if (reviews[index].createdAt != null)
                              Text(
                                DateFormat('dd-MM-yyyy').format(
                                  reviews[index].createdAt!,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.5),
                                    ),
                              ),
                          ],
                        ),
                      ],
                    ),
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
    );
  }
}

class _RatingStar extends StatelessWidget {
  const _RatingStar({
    required this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, ratingIndex) => GestureDetector(
          child: Icon(
            review.rating >= ratingIndex ? Icons.star : Icons.star_border,
            color: ColorPallete.light.yellow,
            size: 20,
          ),
        ),
      ),
    );
  }
}
