import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/home/widget/infinite_list_builder.dart';
import 'package:hispace_mobile_app/screen/wishlist/bloc/wishlist_bloc.dart';

import '../../widget/cafe_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WishlistBloc(
        RepositoryProvider.of<CafeRepository>(context),
      )..add(WishlistInitial()),
      child: const WishlistScreenView(),
    );
  }
}

class WishlistScreenView extends StatefulWidget {
  const WishlistScreenView({super.key});

  @override
  State<WishlistScreenView> createState() => _WishlistScreenViewState();
}

class _WishlistScreenViewState extends State<WishlistScreenView> {
  void _goToDetailsScreen(Cafe cafe) {
    Navigator.pushNamed(context, '/cafe-details', arguments: cafe.locationId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Wishlist', style: Theme.of(context).textTheme.titleMedium),
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          context.read<WishlistBloc>().add(WishlistOnRefresh());
          return Future.delayed(const Duration(seconds: 1));
        },
        child: BlocBuilder<WishlistBloc, WishlistState>(
          buildWhen: (previous, current) =>
              previous.cafes.length != current.cafes.length ||
              previous.status != current.status,
          builder: (context, state) {
            if (state.status == WishlistStatus.loading ||
                state.status == WishlistStatus.success && state.cafes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.coffee_rounded,
                      size: size.width * .4,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(.1),
                    ),
                    const SizedBox(height: kDefaultSpacing),
                    Text(
                      state.status == WishlistStatus.loading
                          ? 'Memuat wishlist kamu...'
                          : 'Wishlist kamu masih kosong',
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

            return InfiniteListBuilder(
              key: const PageStorageKey('WishlistScreen_InfiniteListBuilder'),
              onFetchedMore: () => context.read<WishlistBloc>().add(
                    WishlistOnLoadMore(),
                  ),
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  BlocBuilder<WishlistBloc, WishlistState>(
                buildWhen: (previous, current) =>
                    previous.cafes[index] != current.cafes[index] ||
                    previous.cafes[index].isFavorite !=
                        current.cafes[index].isFavorite,
                builder: (context, state) {
                  return CafeCard(
                    cafe: state.cafes[index],
                    onToggleFavorite: () => context
                        .read<WishlistBloc>()
                        .add(WishlistOnToggleFavorite(index)),
                    onTap: () => _goToDetailsScreen(state.cafes[index]),
                  );
                },
              ),
              itemCount: state.cafes.length,
            );
          },
        ),
      ),
    );
  }
}
