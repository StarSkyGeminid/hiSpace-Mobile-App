import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/create_cafe/page/done.dart';
import 'package:hispace_mobile_app/screen/create_cafe/page/menu.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'bloc/create_cafe_bloc.dart';
import 'page/description.dart';
import 'page/facility.dart';
import 'page/image.dart';
import 'page/location.dart';
import 'page/name.dart';
import 'page/open_hour.dart';
import 'page/upload.dart';

class CreateCafe extends StatelessWidget {
  const CreateCafe({super.key, this.cafe});

  final Cafe? cafe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCafeBloc(
        RepositoryProvider.of<GeoLocationRepository>(context),
        RepositoryProvider.of<CafeRepository>(context),
      )..add(CreateCafeInitial(cafe)),
      child: const CreateCafeView(),
    );
  }
}

class CreateCafeView extends StatefulWidget {
  const CreateCafeView({super.key});

  @override
  State<CreateCafeView> createState() => _CreateCafeViewState();
}

class _CreateCafeViewState extends State<CreateCafeView> {
  late final List<Widget> _pages;

  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _pages = [
      const NameForm(),
      const DescriptionForm(),
      const LocationForm(),
      const OpenHourForm(),
      const ImageForm(),
      const MenuForm(),
      const FacilityForm(),
      const UploadData(),
    ];
    
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<CreateCafeBloc, CreateCafeState>(
        listenWhen: (previous, current) =>
            previous.currentPage != current.currentPage,
        listener: (context, state) {
          if (state.currentPage < _pages.length) {
            _controller.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DoneFilling(
                  isSuccess: state.status != CreateCafeStatus.failure,
                ),
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.currentPage != current.currentPage,
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Buat cafe'),
            automaticallyImplyLeading: false,
          ),
          body: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            itemBuilder: (context, index) => _pages[index],
          ),
          bottomNavigationBar: state.currentPage == _pages.length - 1
              ? null
              : state.currentPage < _pages.length - 1
                  ? _BottomMenu(
                      showPrevious: state.currentPage != 0,
                      onPrevious: () {
                        BlocProvider.of<CreateCafeBloc>(context).add(
                          CreateCafePreviousPage(),
                        );
                      },
                      onNext: () {
                        BlocProvider.of<CreateCafeBloc>(context).add(
                          CreateCafeNextPage(),
                        );
                      },
                      progress: (state.currentPage + 1) / _pages.length,
                    )
                  : const _DoneButton(),
        ),
      ),
    );
  }
}

class _BottomMenu extends StatelessWidget {
  const _BottomMenu({
    required this.onNext,
    required this.progress,
    this.onPrevious,
    this.showPrevious = true,
  });

  final VoidCallback onNext;

  final VoidCallback? onPrevious;

  final bool showPrevious;

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0.0, 0.2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LinearPercentIndicator(
            lineHeight: 7.0,
            percent: progress,
            progressColor: Theme.of(context).colorScheme.primary,
            backgroundColor: const Color(0xFFD9D9D9),
            padding: const EdgeInsets.symmetric(horizontal: 0),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: showPrevious
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (showPrevious)
                BlocBuilder<CreateCafeBloc, CreateCafeState>(
                  buildWhen: (previous, current) =>
                      previous.isValidated != current.isValidated,
                  builder: (context, state) {
                    return ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(shape: const CircleBorder()),
                      onPressed: onPrevious,
                      child: const Padding(
                        padding: EdgeInsets.all(kDefaultSpacing * 0.7),
                        child: Icon(Icons.arrow_back_ios_rounded),
                      ),
                    );
                  },
                ),
              BlocBuilder<CreateCafeBloc, CreateCafeState>(
                buildWhen: (previous, current) =>
                    previous.isValidated != current.isValidated,
                builder: (context, state) {
                  return ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const CircleBorder()),
                    onPressed: state.isValidated ? onNext : null,
                    child: const Padding(
                      padding: EdgeInsets.all(kDefaultSpacing * 0.7),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing / 2),
        child: BlocBuilder<CreateCafeBloc, CreateCafeState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: state.status != CreateCafeStatus.success
                  ? const Padding(
                      padding: EdgeInsets.all(kDefaultSpacing * 0.8),
                      child: Text('Selesai'),
                    )
                  : const SizedBox(
                      height: kDefaultSpacing,
                      width: kDefaultSpacing,
                      child: CircularProgressIndicator.adaptive(),
                    ),
            );
          },
        ),
      ),
    );
  }
}
