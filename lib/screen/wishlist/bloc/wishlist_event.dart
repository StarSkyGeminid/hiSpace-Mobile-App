part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistEvent {}

class WishlistOnTap extends WishlistEvent {
  const WishlistOnTap(this.cafe);

  final Cafe cafe;

  @override
  List<Object> get props => [cafe];
}

class WishlistOnRefresh extends WishlistEvent {}

class WishlistOnLoadMore extends WishlistEvent {}

class WishlistOnToggleFavorite extends WishlistEvent {
  const WishlistOnToggleFavorite(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}
