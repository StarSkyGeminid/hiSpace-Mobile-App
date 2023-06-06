import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/home/bloc/home_bloc.dart';
import 'package:hispace_mobile_app/screen/home/model/home_tab_model.dart';

import 'persistent_header.dart';

class HomeCafeListView extends StatelessWidget {
  const HomeCafeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: PersistentHeader(
        minExtentHeight: 70,
        maxExtentHeight: 70,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
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
                unselectedLabelStyle:
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                tabs: listHomeTabModel
                    .map((room) => Tab(
                          text: room.name,
                          icon: Icon(room.icon, size: 25),
                          iconMargin: const EdgeInsets.only(bottom: 5),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
