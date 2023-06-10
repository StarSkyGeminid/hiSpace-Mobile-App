// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

import 'home_search_bar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBar({
    Key? key,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.onProfileTap,
    this.toolbarHeight,
    this.bottom,
  })  : preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height),
        super(key: key);

  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final VoidCallback onProfileTap;

  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AppBar(
      automaticallyImplyLeading: false,
      title: HomeSearchBar(
        onTap: onSearchTap,
        onFilterTap: onFilterTap,
      ),
      elevation: 1,
      toolbarHeight: toolbarHeight,
      bottom: bottom,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultSpacing / 2),
          child: InkWell(
            onTap: onProfileTap,
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
                  radius: math.min(size.width / 4, 30),
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
                imageUrl:
                    context.read<AuthenticationBloc>().state.user.profilePic ??
                        '',
                placeholder: (context, url) => CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: math.min(size.width / 4, 30),
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
                  radius: math.min(size.width / 4, 30),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}
