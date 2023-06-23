import 'package:bloc/bloc.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

part 'cafe_search_event.dart';
part 'cafe_search_state.dart';

class CafeSearchBloc extends Bloc<CafeSearchEvent, CafeSearchState> {
  CafeSearchBloc(CafeRepository cafeRepository)
      : _cafeRepository = cafeRepository,
        super(const CafeSearchState()) {
    on<CafeSearchOnFormChanged>(_onFormChanged);
    on<CafeSearchOnPriceStartChanged>(_onPriceStartChanged);
    on<CafeSearchOnPriceEndChanged>(_onPriceEndChanged);
    on<CafeSearchOnLocationChanged>(_onLocationChanged);
    on<CafeSearchOnGPSTapped>(_onGpsTapped);
    on<CafeSearchOnSubmitted>(_onSubmitted);
    on<CafeSearchEvent>((event, emit) {});
  }

  final CafeRepository _cafeRepository;

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
        priceFrom: double.parse(event.value),
      ),
    ));
  }

  Future<void> _onPriceEndChanged(
      CafeSearchOnPriceEndChanged event, Emitter<CafeSearchState> emit) async {
    emit(state.copyWith(
      searchModel: state.searchModel.copyWith(
        priceTo: double.parse(event.value),
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
    emit(state.copyWith(
      searchModel: state.searchModel.copyWith(
        latitude: null,
        longitude: null,
      ),
    ));
  }

  Future<void> _onSubmitted(
      CafeSearchOnSubmitted event, Emitter<CafeSearchState> emit) async {
    emit(state.copyWith(
      status: CafeSearchStatus.loading,
    ));
    if (!state.searchModel.isValid()) return;

    try {
      await _cafeRepository.search(state.searchModel);
    } catch (e) {
      emit(state.copyWith(
        status: CafeSearchStatus.failure,
      ));
    }
  }
}
