import 'package:bloc/bloc.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:http_cafe_api/http_cafe_api.dart';

part 'cafe_owned_state.dart';

class CafeOwnedCubit extends Cubit<CafeOwnedState> {
  CafeOwnedCubit(CafeRepository cafeRepository)
      : _cafeRepository = cafeRepository,
        super(const CafeOwnedState());

  final CafeRepository _cafeRepository;

  Future<void> initial(String ownerId) async {
    emit(state.copyWith(
      status: CafeOwnedStatus.loading,
      ownerId: ownerId,
    ));

    try {
      var cafes = await _cafeRepository.getCafeByOwner(ownerId);

      emit(state.copyWith(cafes: cafes, status: CafeOwnedStatus.success));
    } on ResponseFailure {
      emit(state.copyWith(status: CafeOwnedStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CafeOwnedStatus.failure));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: CafeOwnedStatus.loading));

    try {
      var cafes = await _cafeRepository.getCafeByOwner(state.ownerId);

      emit(state.copyWith(cafes: cafes, status: CafeOwnedStatus.success));
    } on ResponseFailure {
      emit(state.copyWith(status: CafeOwnedStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CafeOwnedStatus.failure));
    }
  }
}
