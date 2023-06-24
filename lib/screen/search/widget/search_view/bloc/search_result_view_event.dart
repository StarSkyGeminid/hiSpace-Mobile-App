part of 'search_result_view_bloc.dart';

abstract class SearchResultViewEvent extends Equatable {
  const SearchResultViewEvent();

  @override
  List<Object> get props => [];
}

class SearchResultOnFetchMore extends SearchResultViewEvent {
  const SearchResultOnFetchMore();
}
class SearchResultOnInitial extends SearchResultViewEvent {
  const SearchResultOnInitial();
}

