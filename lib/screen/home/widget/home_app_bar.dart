import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

import 'home_search_bar.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      title: HomeSearchBar(
        onTap: onSearchTap,
        onFilterTap: onFilterTap,
      ),
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      toolbarHeight: 90,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultSpacing / 2),
          child: InkWell(
            onTap: onProfileTap,
            child: CachedNetworkImage(
              imageUrl:
                  'https://coconuts.co/wp-content/uploads/2016/11/jokowi_-_afp_0.jpg',
              placeholder: (context, url) => const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 28,
                child: Icon(Icons.person_rounded),
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
