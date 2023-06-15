import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'bloc/create_cafe_bloc.dart';
import 'page/description.dart';
import 'page/image.dart';
import 'page/location.dart';
import 'page/name.dart';
import 'page/open_hour.dart';

class CreateCafe extends StatelessWidget {
  const CreateCafe({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCafeBloc(
        RepositoryProvider.of<GeoLocationRepository>(context),
        RepositoryProvider.of<CafeRepository>(context),
      ),
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
  final List<Widget> _pages = [
    const NameForm(),
    const DescriptionForm(),
    const LocationForm(),
    const OpenHourForm(),
    const ImageForm(),
    const ImageForm(),
  ];

  int currentPage = 0;

  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buat cafe'),
          automaticallyImplyLeading: false,
        ),
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          itemBuilder: (context, index) => _pages[index],
        ),
        bottomNavigationBar: _BottomMenu(
          onNext: () {
            _controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {
              currentPage++;
            });

            BlocProvider.of<CreateCafeBloc>(context).add(
              CreateCafeNextPage(),
            );
          },
          progress: (currentPage + 1) / _pages.length,
        ),
      ),
    );
  }
}

class _BottomMenu extends StatelessWidget {
  const _BottomMenu({required this.onNext, required this.progress});

  final VoidCallback onNext;

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
          Align(
            alignment: Alignment.centerRight,
            child: BlocBuilder<CreateCafeBloc, CreateCafeState>(
              buildWhen: (previous, current) =>
                  previous.isValidated != current.isValidated,
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                  onPressed: state.isValidated ? onNext : null,
                  child: const Padding(
                    padding: EdgeInsets.all(kDefaultSpacing * 0.7),
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
