import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/carousel_image.dart';

import '../bloc/cafe_details_bloc.dart';
import '../cafe_details.dart';

class CafeDetailsHeader extends StatefulWidget {
  final ScrollController controller;

  final VoidCallback onBack;

  final CafeDetailsType type;

  const CafeDetailsHeader(
      {super.key,
      required this.controller,
      required this.onBack,
      required this.type});

  @override
  State<CafeDetailsHeader> createState() => _CafeDetailsHeaderState();
}

class _CafeDetailsHeaderState extends State<CafeDetailsHeader> {
  bool isAppbarCollapsing = false;

  @override
  void initState() {
    super.initState();

    _initializeController();
  }

  Future<bool?> _deleteConfirmation() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:
                Text('Hapus', style: Theme.of(context).textTheme.titleMedium),
            content: Text('Apakah anda yakin untuk menghapus cafe ini?',
                style: Theme.of(context).textTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Batal',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Hapus',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteCafe() async {
    var bloc = context.read<CafeDetailsBloc>();
    var scaffoldMessenger = ScaffoldMessenger.of(context);

    var navigator = Navigator.of(context);
    var isConfirmed = await _deleteConfirmation();

    if (isConfirmed == null || !isConfirmed) return;

    bloc.add(const CafeDetailsRemove());

    await bloc.stream.firstWhere(
      (state) => state.status != CafeDetailsStatus.loading,
    );
    if (bloc.state.status != CafeDetailsStatus.success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus cafe'),
        ),
      );
      return;
    }

    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Berhasil menghapus cafe'),
      ),
    );

    navigator.pop();
  }

  void _initializeController() {
    final double physicalWidth = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width;
    final double devicePixelRatio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final double width = physicalWidth / devicePixelRatio;

    widget.controller.addListener(() {
      if (widget.controller.offset >= width &&
          !widget.controller.position.outOfRange) {
        if (!mounted) return;
        setState(() => isAppbarCollapsing = true);
      } else if (!widget.controller.position.outOfRange) {
        if (!mounted) return;
        setState(() => isAppbarCollapsing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: isAppbarCollapsing
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      leadingWidth: 80,
      leading: Center(
        child: InkWell(
          onTap: widget.onBack,
          child: Container(
            padding: const EdgeInsets.all(kDefaultSpacing / 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      actions: widget.type == CafeDetailsType.owner
          ? [
              Container(
                  margin: const EdgeInsets.all(kDefaultSpacing / 2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ]),
                  child: _popUpMenu(context)),
            ]
          : null,
      flexibleSpace: FlexibleSpaceBar(
        background: BlocBuilder<CafeDetailsBloc, CafeDetailsState>(
          buildWhen: (previous, current) => previous.cafe != current.cafe,
          builder: (context, state) {
            return CarousselImage(
              cafePictureModel: state.cafe.galeries ?? [],
              onTap: () =>
                  state.cafe.galeries != null && state.cafe.galeries!.isNotEmpty
                      ? Navigator.of(context).pushNamed('/cafe/image-grid',
                          arguments: state.cafe.galeries ?? [])
                      : () {},
            );
          },
        ),
      ),
      pinned: true,
      floating: true,
      snap: true,
      elevation: isAppbarCollapsing ? 0 : 4,
      toolbarHeight: 70,
      expandedHeight: size.width,
    );
  }

  PopupMenuButton<String> _popUpMenu(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.pushNamed(context, '/user/edit-cafe',
              arguments: BlocProvider.of<CafeDetailsBloc>(context).state.cafe);
        } else if (value == 'delete') {
          _deleteCafe();
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'edit',
            child: Text(
              'Edit',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text(
              'Hapus',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ];
      },
    );
  }
}
