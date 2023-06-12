import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';

class CircularProfilePicture extends StatelessWidget {
  const CircularProfilePicture({super.key, this.maxSize = 120});

  final double maxSize;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: math.min(size.width, maxSize),
      height: math.min(size.width, maxSize),
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Builder(builder: (context) {
        String? imageUrl = context.select(
          (AuthenticationBloc bloc) => bloc.state.user.profilePic,
        );

        if (imageUrl == null) {
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

        return CachedNetworkImage(
          imageUrl: imageUrl,
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
        );
      }),
    );
  }
}
