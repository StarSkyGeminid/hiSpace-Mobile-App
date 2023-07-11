import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/home/widget/cafe_tab_bar.dart';
import 'package:hispace_mobile_app/screen/home/widget/home_app_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:collection/collection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'
    show SmartRefresher, RefreshController;

import 'bloc/home_bloc.dart';
import 'model/home_tab_model.dart';
import '../../widget/cafe_card.dart';
import 'widget/infinite_list_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreen> {
  void _goToSearchScreen() {
    Navigator.pushNamed(context, '/search');
  }

  void _goToFilterScreen() {
    // Navigator.pushNamed(context, '/filter');
  }

  void _goToProfileScreen() {
    Navigator.pushNamed(context, '/user/settings');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listHomeTabModel.length,
      child: Scaffold(
        appBar: HomeAppBar(
          onFilterTap: _goToFilterScreen,
          onProfileTap: _goToProfileScreen,
          onSearchTap: _goToSearchScreen,
          toolbarHeight: 90,
          bottom: CafeTabBar(
            toolbarHeight: 45,
          ),
        ),
        body: const _TabView(),
      ),
    );
  }
}

class _TabView extends StatefulWidget {
  const _TabView();

  @override
  State<_TabView> createState() => _TabViewState();
}

class _TabViewState extends State<_TabView> {
  final Distance distance = const Distance();

  final List<RefreshController> _refreshController = [
    RefreshController(initialRefresh: false),
    RefreshController(initialRefresh: false),
    RefreshController(initialRefresh: false),
  ];

  void _goToDetailsScreen(Cafe cafe) {
    Navigator.pushNamed(context, '/cafe-details', arguments: cafe.locationId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: listHomeTabModel.mapIndexed(
        (index, tabModel) {
          return BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                previous.cafes != current.cafes ||
                previous.status != current.status,
            builder: (context, state) {
              if (state.cafes.isEmpty || state.status != HomeStatus.initial) {
                return SmartRefresher(
                  controller: _refreshController[index],
                  onRefresh: () =>
                      context.read<HomeBloc>().add(const HomeOnRefresh()),
                  enablePullDown: true,
                  enablePullUp: false,
                  child: _LoadingBackground(
                    size: size,
                    status: state.status,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 1), () {
                    context.read<HomeBloc>().add(const HomeOnRefresh());
                  });
                },
                child: InfiniteListBuilder(
                  key: PageStorageKey('HomeScreen_ListView_${tabModel.name}'),
                  primary: false,
                  onFetchedMore: () => context.read<HomeBloc>().add(
                        const HomeOnFetchedMore(),
                      ),
                  itemBuilder: (context, index) {
                    return BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) =>
                          previous.cafes[index] != current.cafes[index] ||
                          previous.cafes[index].isFavorite !=
                              current.cafes[index].isFavorite ||
                          previous.currentLocation != current.currentLocation,
                      builder: (context, state) {
                        String? distanceString = getDistance(
                            state.currentLocation, state.cafes[index]);

                        return CafeCard(
                          cafe: state.cafes[index],
                          onToggleFavorite: () => context
                              .read<HomeBloc>()
                              .add(HomeOnToggleFavorite(index: index)),
                          onTap: () => _goToDetailsScreen(state.cafes[index]),
                          distance: distanceString,
                        );
                      },
                    );
                  },
                  itemCount: state.cafes.length,
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }

  String? getDistance(LatLng? currentLocation, Cafe cafe) {
    double? km;
    if (currentLocation != null) {
      km = distance.as(LengthUnit.Kilometer, currentLocation,
          LatLng(cafe.latitude, cafe.longitude));
    }

    String? distanceString = km != null ? '${km.toStringAsFixed(1)} km' : null;
    return distanceString;
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
    String text = 'Memuat rekomendasi...';

    if (status == HomeStatus.failure) {
      text = 'Gagal memuat rekomendasi!';
    } else if (status == HomeStatus.success) {
      text = 'Tidak dapat memuat data';
    }

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
            text,
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
