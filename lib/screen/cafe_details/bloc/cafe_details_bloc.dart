import 'package:bloc/bloc.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';

part 'cafe_details_event.dart';
part 'cafe_details_state.dart';

class CafeDetailsBloc extends Bloc<CafeDetailsEvent, CafeDetailsState> {
  CafeDetailsBloc(CafeRepository cafeRepository)
      : _cafeRepository = cafeRepository,
        super(const CafeDetailsState()) {
    on<CafeDetailsInitial>(_onInitial);
    on<CafeDetailsRemove>(_onRemove);
    on<CafeDetailsEvent>((event, emit) {});
  }

  final CafeRepository _cafeRepository;

  Future<void> _onInitial(
      CafeDetailsInitial event, Emitter<CafeDetailsState> emit) async {
    emit(state.copyWith(status: CafeDetailsStatus.loading));

    try {
      var cafe = await _cafeRepository.getCafeByLocationId(event.locationId);

      emit(state.copyWith(cafe: cafe, status: CafeDetailsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CafeDetailsStatus.failure));
    }
  }

  Future<void> _onRemove(
      CafeDetailsRemove event, Emitter<CafeDetailsState> emit) async {
    emit(state.copyWith(status: CafeDetailsStatus.loading));

    try {
      await _cafeRepository.remove(state.cafe.locationId);
      emit(state.copyWith(status: CafeDetailsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CafeDetailsStatus.failure));
    }
  }
}
