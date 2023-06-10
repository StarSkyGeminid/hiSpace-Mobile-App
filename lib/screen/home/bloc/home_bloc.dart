import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_bloc.g.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  HomeBloc({required CafeRepository cafeRepository})
      : _cafeRepository = cafeRepository,
        super(const HomeState()) {
    on<HomeOnInitial>(_onInitial);
    on<HomeOnRefresh>(_onRefresh);
    on<HomeOnFetchedMore>(_onFetchedMore);
    on<HomeOnTabChanged>(_onTabChanged);
    on<HomeOnToggleFavorite>(_onToggleFavorite);
    on<HomeEvent>((event, emit) {});
  }

  final CafeRepository _cafeRepository;

  int currentPageIndex = 0;

  bool isFetching = false;

  Future<void> _onInitial(HomeOnInitial event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    await _cafeRepository.fetchCafes(page: currentPageIndex++);

    await emit.forEach<List<Cafe>>(
      _cafeRepository.getCafes(),
      onData: (cafes) => state.copyWith(
        hasReachedMax: state.cafes.length == cafes.length,
        status: HomeStatus.success,
        cafes: cafes,
      ),
      onError: (_, __) => state.copyWith(
        status: HomeStatus.failure,
      ),
    );
  }

  Future<void> _onRefresh(HomeOnRefresh event, Emitter<HomeState> emit) async {
    currentPageIndex = 0;
    _cafeRepository.fetchCafes(page: currentPageIndex);
  }

  Future<void> _onFetchedMore(
      HomeOnFetchedMore event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax) return;

    if (isFetching) return;

    isFetching = true;
    await _cafeRepository.fetchCafes(page: currentPageIndex++);
    isFetching = false;
  }

  Future<void> _onTabChanged(
      HomeOnTabChanged event, Emitter<HomeState> emit) async {
    currentPageIndex = 0;
    _cafeRepository.fetchCafes(page: currentPageIndex);
  }

  Future<void> _onToggleFavorite(
      HomeOnToggleFavorite event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    _cafeRepository.toggleFavorite(event.locationId);
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) => HomeState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(HomeState state) => state.toJson();
}
