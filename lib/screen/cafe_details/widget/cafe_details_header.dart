import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CafeDetailsHeader extends StatefulWidget {
  final ScrollController controller;

  final VoidCallback onBack;

  const CafeDetailsHeader(
      {super.key, required this.controller, required this.onBack});

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
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      expandedHeight: 60,
    );
  }
}
