// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_result_view_bloc.dart';

enum SearchResultViewStatus { initial, loading, success, failure }

class SearchResultViewState extends Equatable {
  const SearchResultViewState({
    this.status = SearchResultViewStatus.initial,
    this.cafes = const <Cafe>[],
    this.searchModel = const SearchModel(),
  });

  final SearchResultViewStatus status;

  final List<Cafe> cafes;

  final SearchModel searchModel;

  @override
  List<Object> get props => [status, cafes, searchModel];

  SearchResultViewState copyWith({
    SearchResultViewStatus? status,
    List<Cafe>? cafes,
    SearchModel? searchModel,
  }) {
    return SearchResultViewState(
      status: status ?? this.status,
      cafes: cafes ?? this.cafes,
      searchModel: searchModel ?? this.searchModel,
    );
  }
}
