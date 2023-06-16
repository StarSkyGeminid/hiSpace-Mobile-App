part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeOnInitial extends HomeEvent {
  const HomeOnInitial();
}

class HomeOnRefresh extends HomeEvent {
  const HomeOnRefresh();
}

class HomeOnFetchedMore extends HomeEvent {
  const HomeOnFetchedMore();
}

class HomeOnTabChanged extends HomeEvent {
  const HomeOnTabChanged({required this.index});

  final int index;

  @override
  List<Object> get props => [index];
}

class HomeOnToggleFavorite extends HomeEvent {
  const HomeOnToggleFavorite({required this.index});

  final int index;

  @override
  List<Object> get props => [index];
}
