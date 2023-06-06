import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/screen/home/widget/home_app_bar.dart';
import 'package:hispace_mobile_app/screen/home/widget/home_cafe_list_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          context.read<HomeBloc>().add(const HomeOnRefresh());
        });
      },
      child: DefaultTabController(
        length: listHomeTabModel.length,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            HomeAppBar(
              onSearchTap: _goToSearchScreen,
              onFilterTap: _goToFilterScreen,
              onProfileTap: _goToProfileScreen,
            ),
            const HomeCafeListView(),
          ],
          body: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) => previous.cafes != current.cafes,
            builder: (context, state) {
              return Builder(builder: (context) {
                return TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: listHomeTabModel
                        .map(
                          (tabModel) => InfiniteListBuilder(
                            key: PageStorageKey(
                                'HomeScreen_ListView_${tabModel.name}'),
                            onFetchedMore: () => context.read<HomeBloc>().add(
                                  const HomeOnFetchedMore(),
                                ),
                            itemBuilder: (context, index) => CafeCard(
                              cafe: state.cafes[index],
                            ),
                            itemCount: state.cafes.length,
                          ),
                        )
                        .toList());
              });
            },
          ),
        ),
      ),
    );
  }
}
