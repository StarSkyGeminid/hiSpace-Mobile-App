import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/home/widget/cafe_tab_bar.dart';
import 'package:hispace_mobile_app/screen/home/widget/home_app_bar.dart';

import 'bloc/home_bloc.dart';
import 'model/home_tab_model.dart';
import 'widget/cafe_card.dart';
import 'widget/infinite_list_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        cafeRepository: context.read<CafeRepository>(),
      )..add(const HomeOnInitial()),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  void _goToSearchScreen() {
    // Navigator.pushNamed(context, '/search');
  }

  void _goToFilterScreen() {
    // Navigator.pushNamed(context, '/filter');
  }

  void _goToProfileScreen() {
    // Navigator.pushNamed(context, '/profile');
  }

  void _goToDetailsScreen(Cafe cafe) {
    Navigator.pushNamed(context, '/cafe-details', arguments: cafe);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          context.read<HomeBloc>().add(const HomeOnRefresh());
        });
      },
      child: DefaultTabController(
        length: listHomeTabModel.length,
        child: Scaffold(
          appBar: HomeAppBar(
            onFilterTap: _goToFilterScreen,
            onProfileTap: _goToProfileScreen,
            onSearchTap: _goToSearchScreen,
            toolbarHeight: 90,
            bottom: CafeTabBar(
              toolbarHeight: 60,
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                previous.cafes != current.cafes ||
                previous.status != current.status,
            builder: (context, state) {
              return TabBarView(
                  dragStartBehavior: DragStartBehavior.down,
                  physics: const NeverScrollableScrollPhysics(),
                  children: listHomeTabModel.map(
                    (tabModel) {
                      if (state.status != HomeStatus.success ||
                          state.cafes.isEmpty) {
                        return _LoadingBackground(
                          size: size,
                          status: state.status,
                        );
                      }

                      return InfiniteListBuilder(
                        key: PageStorageKey(
                            'HomeScreen_ListView_${tabModel.name}'),
                        onFetchedMore: () => context.read<HomeBloc>().add(
                              const HomeOnFetchedMore(),
                            ),
                        itemBuilder: (context, index) => CafeCard(
                          cafe: state.cafes[index],
                          onToggleFavorite: () => context.read<HomeBloc>().add(
                              HomeOnToggleFavorite(
                                  locationId: state.cafes[index].locationId)),
                          onTap: () => _goToDetailsScreen(state.cafes[index]),
                        ),
                        itemCount: state.cafes.length,
                      );
                    },
                  ).toList());
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingBackground extends StatelessWidget {
  const _LoadingBackground({
    required this.size,
    required this.status,
  });

  final HomeStatus status;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.coffee_rounded,
            size: size.width * .4,
            color: Theme.of(context).colorScheme.inverseSurface.withOpacity(.1),
          ),
          const SizedBox(height: kDefaultSpacing),
          Text(
            status == HomeStatus.loading
                ? 'Memuat rekomendasi...'
                : 'Gagal memuat rekomendasi!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(.3),
                ),
          ),
        ],
      ),
    );
  }
}
