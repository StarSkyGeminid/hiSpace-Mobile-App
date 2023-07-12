import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/circular_profile_picture.dart';

class Owner extends StatelessWidget {
  const Owner({
    super.key,
    required this.cafe,
  });

  final Cafe cafe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: Text(
            cafe.owner,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing, vertical: kDefaultSpacing / 2),
          child: CircularProfilePicture(
            maxSize: 70,
            isCached: false,
            url: cafe.user.profilePic,
          ),
        ),
      ],
    );
  }
}
