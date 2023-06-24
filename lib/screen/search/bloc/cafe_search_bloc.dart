import 'package:bloc/bloc.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocation_repository/geolocation_repository.dart';

part 'cafe_search_event.dart';
part 'cafe_search_state.dart';

class CafeSearchBloc extends Bloc<CafeSearchEvent, CafeSearchState> {
  CafeSearchBloc(GeoLocationRepository geoLocationRepository)
      : _geoLocationRepository = geoLocationRepository,
        super(const CafeSearchState()) {
    on<CafeSearchOnFormChanged>(_onFormChanged);
    on<CafeSearchOnPriceStartChanged>(_onPriceStartChanged);
    on<CafeSearchOnPriceEndChanged>(_onPriceEndChanged);
    on<CafeSearchOnLocationChanged>(_onLocationChanged);
    on<CafeSearchOnGPSTapped>(_onGpsTapped);
    on<CafeSearchEvent>((event, emit) {});
  }

  final GeoLocationRepository _geoLocationRepository;

  int currentPage = 0;
  bool isFetching = false;

  Future<void> _onFormChanged(
      CafeSearchOnFormChanged event, Emitter<CafeSearchState> emit) async {
    emit(state.copyWith(
      searchModel: state.searchModel.copyWith(
        name: event.value,
      ),
    ));
  }

  Future<void> _onPriceStartChanged(CafeSearchOnPriceStartChanged event,
      Emitter<CafeSearchState> emit) async {
    emit(state.copyWith(
      searchModel: state.searchModel.copyWith(
        priceFrom: event.value,
      ),
    ));
  }

  Future<void> _onPriceEndChanged(
      CafeSearchOnPriceEndChanged event, Emitter<CafeSearchState> emit) async {
    emit(state.copyWith(
      searchModel: state.searchModel.copyWith(
        priceTo: event.value,
      ),
    ));
  }

  Future<void> _onLocationChanged(
      CafeSearchOnLocationChanged event, Emitter<CafeSearchState> emit) async {
    emit(state.copyWith(
      searchModel: state.searchModel.copyWith(
        latitude: event.latlng.latitude,
        longitude: event.latlng.longitude,
      ),
    ));
  }

  Future<void> _onGpsTapped(
      CafeSearchOnGPSTapped event, Emitter<CafeSearchState> emit) async {
    final coordinates = await _geoLocationRepository.getCurrentPosition();

    emit(state.copyWith(
      searchModel: state.searchModel.copyWith(
        latitude: coordinates?.latitude,
        longitude: coordinates?.longitude,
      ),
    ));
  }
}
