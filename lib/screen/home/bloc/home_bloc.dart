import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_bloc.g.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  HomeBloc(
      {required CafeRepository cafeRepository,
      required GeoLocationRepository geoLocationRepository})
      : _cafeRepository = cafeRepository,
        _geoLocationRepository = geoLocationRepository,
        super(const HomeState()) {
    on<HomeOnInitial>(_onInitial);
    on<HomeOnRefresh>(_onRefresh);
    on<HomeOnFetchedMore>(_onFetchedMore);
    on<HomeOnTabChanged>(_onTabChanged);
    on<HomeOnToggleFavorite>(_onToggleFavorite);
    on<HomeEvent>((event, emit) {});
  }

  final CafeRepository _cafeRepository;

  final GeoLocationRepository _geoLocationRepository;

  int currentPageIndex = 0;

  bool isFetching = false;

  Future<void> _onInitial(HomeOnInitial event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    await _cafeRepository.fetchCafes(page: currentPageIndex++);

    final coordinates = await _geoLocationRepository.getCurrentPosition();

    await emit.forEach<List<Cafe>>(
      _cafeRepository.getCafes(),
      onData: (cafes) => state.copyWith(
        hasReachedMax: state.cafes.length == cafes.length,
        status: cafes.isNotEmpty ? HomeStatus.success : HomeStatus.failure,
        currentLocation: coordinates != null
            ? LatLng(
                coordinates.latitude,
                coordinates.longitude,
              )
            : null,
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

    emit(state.copyWith(status: HomeStatus.loading));

    try {
      isFetching = true;
      await _cafeRepository.fetchCafes(page: currentPageIndex++);
      isFetching = false;
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
      isFetching = false;
    }
  }

  Future<void> _onTabChanged(
      HomeOnTabChanged event, Emitter<HomeState> emit) async {
    currentPageIndex = 0;
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      _cafeRepository.fetchCafes(page: currentPageIndex);
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onToggleFavorite(
      HomeOnToggleFavorite event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      _cafeRepository.toggleFavorite(event.locationId);
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) => HomeState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(HomeState state) => state.toJson();
}
