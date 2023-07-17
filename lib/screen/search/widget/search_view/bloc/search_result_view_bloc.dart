import 'package:bloc/bloc.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';

part 'search_result_view_event.dart';
part 'search_result_view_state.dart';

class SearchResultViewBloc
    extends Bloc<SearchResultViewEvent, SearchResultViewState> {
  SearchResultViewBloc(CafeRepository cafeRepository, SearchModel searchModel)
      : _cafeRepository = cafeRepository,
        super(SearchResultViewState(searchModel: searchModel)) {
    on<SearchResultOnFetchMore>(_onFetchedMore);
    on<SearchResultOnInitial>(_onInitial);
    on<SearchResultViewEvent>((event, emit) {});
  }

  int currentPage = 0;

  bool isFetching = false;

  final CafeRepository _cafeRepository;

  Future<void> _onInitial(
      SearchResultOnInitial event, Emitter<SearchResultViewState> emit) async {
    emit(state.copyWith(
      status: SearchResultViewStatus.loading,
    ));

    if (!state.searchModel.isValid()) return;

    try {
      isFetching = true;
      await _cafeRepository.user.search(state.searchModel, page: currentPage++);
      isFetching = false;

      await emit.forEach<List<Cafe>>(
        _cafeRepository.user.getCafes(),
        onData: (cafes) => state.copyWith(
          status: cafes.isNotEmpty
              ? SearchResultViewStatus.success
              : SearchResultViewStatus.failure,
          cafes: cafes,
        ),
        onError: (_, __) => state.copyWith(
          status: SearchResultViewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SearchResultViewStatus.failure,
      ));
    }
  }

  Future<void> _onFetchedMore(SearchResultOnFetchMore event,
      Emitter<SearchResultViewState> emit) async {
    if (!state.searchModel.isValid()) return;

    if (isFetching) return;

    try {
      isFetching = true;
      await _cafeRepository.user.search(state.searchModel, page: currentPage++);
      isFetching = false;
    } catch (e) {
      emit(state.copyWith(
        status: SearchResultViewStatus.failure,
      ));
    }
  }
}
