// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/circular_profile_picture.dart';

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
            radius: 30,
            onTap: onProfileTap,
            child: const CircularProfilePicture(maxSize: 50),
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
