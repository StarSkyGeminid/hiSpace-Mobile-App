import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    var navigator = Navigator.of(context);
    var isConfirmed = await _deleteConfirmation();

    if (isConfirmed != null && isConfirmed) {
      bloc.add(const CafeDetailsRemove());
      navigator.pop();
    }
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
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: isAppbarCollapsing
          ? Theme.of(context).colorScheme.background
          : Colors.transparent,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: widget.onBack,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      actions: widget.type == CafeDetailsType.owner
          ? [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.pushNamed(context, '/edit-cafe');
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
                      // onTap: () {},
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Hapus',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      // onTap: () => _deleteCafe(),
                    ),
                  ];
                },
              ),
            ]
          : null,
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      expandedHeight: 60,
    );
  }
}
