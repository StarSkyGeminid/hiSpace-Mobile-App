import 'package:flutter/material.dart';

class InfiniteListBuilder extends StatefulWidget {
  final VoidCallback? onFetchedMore;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Widget? loadingPlaceholder;
  final bool blockController;
  final bool? primary;

  const InfiniteListBuilder({
    Key? key,
    this.onFetchedMore,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollController,
    this.loadingPlaceholder,
    this.scrollPhysics,
    this.blockController = false,
    this.primary,
  }) : super(key: key);

  @override
  State<InfiniteListBuilder> createState() => _InfiniteListBuilderState();
}

class _InfiniteListBuilderState extends State<InfiniteListBuilder> {
  late final ScrollController _scrollController;
  final int _scrollThreshold = 200;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (widget.scrollController == null) _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      widget.onFetchedMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
        primary: widget.primary,
        physics: widget.scrollPhysics,
        controller: widget.blockController ? null : _scrollController,
        itemBuilder: widget.itemBuilder,
        itemCount: widget.itemCount,
      ),
    );
  }
}
