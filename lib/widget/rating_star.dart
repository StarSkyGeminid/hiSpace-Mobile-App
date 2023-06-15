import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';

class RatingStar extends StatelessWidget {
  const RatingStar({
    super.key,
    required this.rating,
    this.textStyle,
  });

  final double rating;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    IconData starIcon = Icons.star_outline_rounded;

    if (rating >= 3) {
      starIcon = Icons.star_rounded;
    } else if (rating > 1) {
      Icons.star_half_rounded;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          starIcon,
          color: ColorPallete.light.yellow,
        ),
        Text(
          rating.toString().substring(0, 3),
          style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
