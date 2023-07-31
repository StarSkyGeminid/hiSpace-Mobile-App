import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularProfilePicture extends StatelessWidget {
  const CircularProfilePicture(
      {super.key, this.maxSize = 120, this.url, this.isCached = true});

  final double maxSize;

  final bool isCached;

  final String? url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: math.min(size.width, maxSize),
      height: math.min(size.width, maxSize),
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Builder(
        builder: (context) {
          if (url == null || url!.isEmpty) {
            return CircleAvatar(
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(.2),
              radius: math.min(size.width, maxSize),
              child: Icon(
                Icons.person_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(.8),
              ),
            );
          }

          return isCached
              ? CachedNetworkImage(
                  imageUrl: url!,
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: math.min(size.width, maxSize),
                    child: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(.8),
                    ),
                  ),
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    radius: math.min(size.width, maxSize),
                  ),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(url!),
                  radius: math.min(size.width, maxSize),
                );
        },
      ),
    );
  }
}
