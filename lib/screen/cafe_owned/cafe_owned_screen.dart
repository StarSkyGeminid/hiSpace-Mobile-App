import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/cafe_details/cafe_details.dart';
import 'package:hispace_mobile_app/screen/cafe_owned/cubit/cafe_owned_cubit.dart';
import 'package:hispace_mobile_app/widget/cafe_card.dart';

class CafeOwned extends StatelessWidget {
  const CafeOwned({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CafeOwnedCubit(
        RepositoryProvider.of<CafeRepository>(context),
      )..initial(BlocProvider.of<AuthenticationBloc>(context).state.user.email),
      child: const CafeOwnedView(),
    );
  }
}

class CafeOwnedView extends StatefulWidget {
  const CafeOwnedView({super.key});

  @override
  State<CafeOwnedView> createState() => _CafeOwnedViewState();
}

class _CafeOwnedViewState extends State<CafeOwnedView> {
  @override
  void initState() {
    BlocProvider.of<CafeOwnedCubit>(context).initial(
      BlocProvider.of<AuthenticationBloc>(context).state.user.email,
    );
    super.initState();
  }

  void _goToCreateCafe(BuildContext context) {
    Navigator.pushNamed(context, '/user/create-cafe');
  }

  void _goToDetailsScreen(Cafe cafe) {
    Navigator.pushNamed(context, '/cafe-details', arguments: {
      'locationId': cafe.locationId,
      'type': CafeDetailsType.owner,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cafe Saya'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<CafeOwnedCubit>(context).refresh();
          },
          child: BlocBuilder<CafeOwnedCubit, CafeOwnedState>(
            builder: (context, state) {
              if (state.cafes.isEmpty) {
                return _CafeEmptyStatus(
                  status: state.status,
                );
              }

              return BlocBuilder<CafeOwnedCubit, CafeOwnedState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return CafeCard(
                        cafe: state.cafes[index],
                        onTap: () => _goToDetailsScreen(state.cafes[index]),
                      );
                    },
                    itemCount: state.cafes.length,
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: _CreateButton(
          onPressed: () => _goToCreateCafe(context),
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultSpacing),
      child: ElevatedButton(
        key: const Key('CafeOwnedScreen_createButton'),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultSpacing * .8),
          child: BlocBuilder<CafeOwnedCubit, CafeOwnedState>(
            builder: (context, state) {
              String text = state.cafes.isEmpty ? 'Buat Cafe' : 'Tambah Cafe';

              return Text(text);
            },
          ),
        ),
      ),
    );
  }
}

class _CafeEmptyStatus extends StatelessWidget {
  const _CafeEmptyStatus({required this.status});

  final CafeOwnedStatus status;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String errorText = '';

    switch (status) {
      case CafeOwnedStatus.loading:
        errorText = 'Memuat cafe kamu...';
        break;
      case CafeOwnedStatus.success:
        errorText = 'Kamu belum memiliki cafe';
        break;
      default:
        errorText = 'Terjadi kesalahan';
        break;
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
            errorText,
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
