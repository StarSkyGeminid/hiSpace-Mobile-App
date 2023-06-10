import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/home/bloc/home_bloc.dart';
import 'package:hispace_mobile_app/screen/home/model/home_tab_model.dart';

class CafeTabBar extends StatelessWidget implements PreferredSizeWidget {
  CafeTabBar({
    Key? key,
    this.toolbarHeight,
    this.bottom,
  })  : preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height),
        super(key: key);

  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (value) => BlocProvider.of<HomeBloc>(context)
          .add(HomeOnTabChanged(index: value)),
      labelPadding: const EdgeInsets.symmetric(
        horizontal: kDefaultSpacing,
      ),
      indicatorPadding: const EdgeInsets.symmetric(
        horizontal: kDefaultSpacing,
      ),
      indicatorWeight: 3,
      isScrollable: true,
      indicatorColor: Theme.of(context).colorScheme.onSurface,
      labelColor: Theme.of(context).colorScheme.onSurface,
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      unselectedLabelColor: Theme.of(context).colorScheme.outline,
      unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
      tabs: listHomeTabModel
          .map((room) => Tab(
                text: room.name,
                icon: Icon(room.icon, size: 25),
                iconMargin: const EdgeInsets.only(bottom: 5),
                height: toolbarHeight,
              ))
          .toList(),
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
