part of 'cafe_search_bloc.dart';

enum CafeSearchStatus { initial, loading, success, failure }

class CafeSearchState extends Equatable {
  const CafeSearchState({
    this.status = CafeSearchStatus.initial,
    this.cafes = const <Cafe>[],
    this.searchModel = const SearchModel(),
  });

  final CafeSearchStatus status;

  final List<Cafe> cafes;

  final SearchModel searchModel;

  CafeSearchState copyWith({
    CafeSearchStatus? status,
    List<Cafe>? cafes,
    SearchModel? searchModel,
  }) {
    return CafeSearchState(
      status: status ?? this.status,
      cafes: cafes ?? this.cafes,
      searchModel: searchModel ?? this.searchModel,
    );
  }

  @override
  List<Object> get props => [
        status,
        cafes,
        searchModel,
      ];
}
