import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/cafe_details_header.dart';
import 'package:hispace_mobile_app/screen/cafe_details/widget/cafe_information.dart';
import 'package:hispace_mobile_app/widget/carousel_image.dart';

import 'bloc/cafe_details_bloc.dart';

class CafeDetails extends StatelessWidget {
  const CafeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CafeDetailsBloc()..add(CafeDetailsInitial()),
      child: const _CafeDetailsView(),
    );
  }
}

class _CafeDetailsView extends StatefulWidget {
  const _CafeDetailsView();

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
      child: Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            CafeDetailsHeader(
              controller: scrollController,
              onBack: () => Navigator.of(context).pop(),
            ),
            SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1,
                child: BlocBuilder<CafeDetailsBloc, CafeDetailsState>(
                  builder: (context, state) {
                    return CarousselImage(
                      cafePictureModel: state.cafe.galeries ??
                          [
                            const Galery(
                                id: '1', url: 'https://picsum.photos/200'),
                          ],
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(kDefaultSpacing),
                child: CafeInformation(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
