import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/cafe_details_header.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/description.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/facility.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/menu.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/owner.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/title.dart';

import 'bloc/cafe_details_bloc.dart';
import 'widget/maps.dart';
import 'widget/review.dart';

enum CafeDetailsType { owner, visitor }

class CafeDetails extends StatelessWidget {
  const CafeDetails({super.key, required this.locationId, required this.type});

  final CafeDetailsType type;

  final String locationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CafeDetailsBloc(
          RepositoryProvider.of<CafeRepository>(context),
          BlocProvider.of<AuthenticationBloc>(context).state.user.id)
        ..add(CafeDetailsInitial(locationId)),
      child: _CafeDetailsView(type, locationId),
    );
  }
}

class _CafeDetailsView extends StatefulWidget {
  const _CafeDetailsView(this.type, this.locationId);

  final CafeDetailsType type;
  final String locationId;

  @override
  State<_CafeDetailsView> createState() => _CafeDetailsViewState();
}

class _CafeDetailsViewState extends State<_CafeDetailsView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CafeDetailsBloc, CafeDetailsState>(
        builder: (context, state) {
          return Scaffold(
            body: _View(scrollController: scrollController, type: widget.type),
            bottomNavigationBar:
                widget.type != CafeDetailsType.owner && !state.isOwned
                    ? Container(
                        padding: const EdgeInsets.all(kDefaultSpacing),
                        color: Theme.of(context).colorScheme.background,
                        child: ElevatedButton(
                          onPressed: state.isReviewed
                              ? null
                              : () => Navigator.pushNamed(
                                  context, '/user/write-review',
                                  arguments: widget.locationId),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultSpacing,
                                vertical: kDefaultSpacing * 0.8),
                            child: Text('Tulis Ulasan'),
                          ),
                        ),
                      )
                    : null,
          );
        },
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({
    required this.scrollController,
    required this.type,
  });

  final ScrollController scrollController;

  final CafeDetailsType type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CafeDetailsBloc, CafeDetailsState>(
      buildWhen: (previous, current) =>
          previous.cafe != current.cafe || previous.status != current.status,
      builder: (context, state) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            CafeDetailsHeader(
              controller: scrollController,
              onBack: () => Navigator.of(context).pop(),
              type: type,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: DetailsTitle(
                  cafe: state.cafe,
                  type: type,
                ),
              ),
            ),
            if (state.status != CafeDetailsStatus.loading) ...[
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultSpacing,
                    ),
                    child: Divider(color: ColorPallete.light.grey3)),
              ),
              SliverToBoxAdapter(
                child: Owner(cafe: state.cafe),
              ),
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultSpacing,
                    ),
                    child: Divider(color: ColorPallete.light.grey3)),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kDefaultSpacing,
                    0,
                    kDefaultSpacing,
                    kDefaultSpacing,
                  ),
                  child: Description(cafe: state.cafe),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultSpacing,
                    ),
                    child: Divider(color: ColorPallete.light.grey3)),
              ),
              if (state.cafe.menus != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                    child: Menu(cafe: state.cafe),
                  ),
                ),
              if (state.cafe.menus != null && state.cafe.menus!.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultSpacing),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, '/cafe/all-menu',
                          arguments: state.cafe.menus),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kDefaultSpacing,
                            vertical: kDefaultSpacing * 0.8),
                        child: Text('Lihat Semua Menu'),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultSpacing,
                    ),
                    child: Divider(color: ColorPallete.light.grey3)),
              ),
              if (state.cafe.facilities != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                    child: Facility(
                      cafe: state.cafe,
                    ),
                  ),
                ),
              if (state.cafe.facilities != null &&
                  state.cafe.facilities!.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultSpacing),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, '/cafe/all-facilities',
                          arguments: state.cafe.facilities),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kDefaultSpacing,
                            vertical: kDefaultSpacing * 0.8),
                        child: Text('Lihat Semua Fasilitas'),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultSpacing,
                    ),
                    child: Divider(color: ColorPallete.light.grey3)),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultSpacing),
                  child: Maps(
                    latitude: state.cafe.latitude,
                    longitude: state.cafe.longitude,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kDefaultSpacing,
                    0,
                    kDefaultSpacing,
                    kDefaultSpacing / 2,
                  ),
                  child: Text(state.cafe.address),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                  child: Divider(color: ColorPallete.light.grey3),
                ),
              ),
              SliverToBoxAdapter(
                child: ReviewView(reviews: state.cafe.reviews ?? []),
              ),
              if (state.cafe.reviews != null && state.cafe.reviews!.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultSpacing),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, '/cafe/all-review',
                          arguments: state.cafe.reviews),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kDefaultSpacing,
                            vertical: kDefaultSpacing * 0.8),
                        child: Text('Lihat Semua Ulasan'),
                      ),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(kDefaultSpacing),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
