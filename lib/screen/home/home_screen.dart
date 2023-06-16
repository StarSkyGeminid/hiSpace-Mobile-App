import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/home/widget/cafe_tab_bar.dart';
import 'package:hispace_mobile_app/screen/home/widget/home_app_bar.dart';
import 'package:latlong2/latlong.dart';

import 'bloc/home_bloc.dart';
import 'model/home_tab_model.dart';
import '../../widget/cafe_card.dart';
import 'widget/infinite_list_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        cafeRepository: context.read<CafeRepository>(),
        geoLocationRepository: context.read<GeoLocationRepository>(),
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
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              context.read<HomeBloc>().add(const HomeOnRefresh());
            });
          },
          child: const _TabView(),
        ),
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

  void _goToDetailsScreen(Cafe cafe) {
    Navigator.pushNamed(context, '/cafe-details', arguments: cafe.locationId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TabBarView(
      // dragStartBehavior: DragStartBehavior.down,
      physics: const NeverScrollableScrollPhysics(),
      children: listHomeTabModel.map(
        (tabModel) {
          return BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                previous.cafes != current.cafes ||
                previous.status != current.status,
            builder: (context, state) {
              if ((state.status != HomeStatus.success || state.cafes.isEmpty) &&
                  state.status != HomeStatus.initial) {
                return _LoadingBackground(
                  size: size,
                  status: state.status,
                );
              }

              return InfiniteListBuilder(
                key: PageStorageKey('HomeScreen_ListView_${tabModel.name}'),
                primary: false,
                onFetchedMore: () => context.read<HomeBloc>().add(
                      const HomeOnFetchedMore(),
                    ),
                itemBuilder: (context, index) {
                  final double km = distance.as(
                      LengthUnit.Kilometer,
                      state.currentLocation,
                      LatLng(state.cafes[index].latitude,
                          state.cafes[index].longitude));

                  String? distanceString =
                      state.currentLocation.longitude != 0.0 &&
                              state.currentLocation.latitude != 0.0
                          ? '${km.toStringAsFixed(1)} km'
                          : null;

                  return BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current) =>
                        previous.cafes[index] != current.cafes[index] ||
                        previous.cafes[index].isFavorite !=
                            current.cafes[index].isFavorite,
                    builder: (context, state) {
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
              );
            },
          );
        },
      ).toList(),
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
