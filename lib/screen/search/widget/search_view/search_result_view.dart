import 'package:cafe_api/cafe_api.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/home/widget/home_search_bar.dart';
import 'package:hispace_mobile_app/screen/home/widget/infinite_list_builder.dart';
import 'package:hispace_mobile_app/widget/cafe_card.dart';

import 'bloc/search_result_view_bloc.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({super.key, required this.searchModel});

  final SearchModel searchModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchResultViewBloc(
        RepositoryProvider.of<CafeRepository>(context),
        searchModel,
      )..add(const SearchResultOnInitial()),
      child: const _SearchResultView(),
    );
  }
}

class _SearchResultView extends StatefulWidget {
  const _SearchResultView();

  @override
  State<_SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<_SearchResultView> {
  void _goToSearchScreen() {
    Navigator.pop(context);
  }

  void _goToFilterScreen() {
    // Navigator.pushNamed(context, '/filter');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: HomeSearchBar(
            onTap: _goToSearchScreen,
            onFilterTap: _goToFilterScreen,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<SearchResultViewBloc, SearchResultViewState>(
          builder: (context, state) {
            if (state.status != SearchResultViewStatus.success) {
              return _LoadingBackground(size: size, status: state.status);
            }

            return InfiniteListBuilder(
              onFetchedMore: () => context
                  .read<SearchResultViewBloc>()
                  .add(const SearchResultOnFetchMore()),
              itemCount: state.cafes.length,
              itemBuilder: (context, index) {
                return CafeCard(
                    cafe: state.cafes[index],
                    onTap: () => Navigator.pushNamed(context, '/cafe-details',
                        arguments: state.cafes[index].locationId));
              },
            );
          },
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

  final SearchResultViewStatus status;

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
            status == SearchResultViewStatus.loading ||
                    status == SearchResultViewStatus.initial
                ? 'Mencari cafe...'
                : 'Gagal memuat pencarian!',
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
