// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'wishlist_bloc.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState extends Equatable {
  const WishlistState({
    this.status = WishlistStatus.initial,
    this.cafes = const [],
    this.hasReachedMax = false,
  });

  final WishlistStatus status;

  final List<Cafe> cafes;

  final bool hasReachedMax ;

  @override
  List<Object> get props => [status, cafes];

  WishlistState copyWith({
    WishlistStatus? status,
    List<Cafe>? cafes,
    bool? hasReachedMax,
  }) {
    return WishlistState(
      status: status ?? this.status,
      cafes: cafes ?? this.cafes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
