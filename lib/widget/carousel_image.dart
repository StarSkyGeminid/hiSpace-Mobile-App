import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarousselImage extends StatefulWidget {
  final List<Galery> cafePictureModel;

  const CarousselImage({super.key, required this.cafePictureModel});

  @override
  State<CarousselImage> createState() => _CarousselImageState();
}

class _CarousselImageState extends State<CarousselImage> {
  late PageController controller;
  int currentpage = 0;

  @override
  initState() {
    super.initState();
    controller = PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 1,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.cafePictureModel.length,
          onPageChanged: (value) {
            setState(() {
              currentpage = value;
            });
          },
          controller: controller,
          itemBuilder: (context, index) => builder(index),
          padEnds: false,
        ),
        if (widget.cafePictureModel.length > 1)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: kDefaultSpacing / 2),
              child: SmoothPageIndicator(
                controller: controller,
                count: widget.cafePictureModel.length,
                axisDirection: Axis.horizontal,
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                effect: SlideEffect(
                  spacing: 8.0,
                  dotWidth: 10.0,
                  dotHeight: 10.0,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 1.5,
                  dotColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.5),
                  activeDotColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          )
      ],
    );
  }

  builder(int index) {
    return CachedNetworkImage(
      imageUrl: widget.cafePictureModel[index].url,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 100),
    );
  }
}
