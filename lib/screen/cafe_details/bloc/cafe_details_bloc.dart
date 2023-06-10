import 'package:bloc/bloc.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';

part 'cafe_details_event.dart';
part 'cafe_details_state.dart';

class CafeDetailsBloc extends Bloc<CafeDetailsEvent, CafeDetailsState> {
  CafeDetailsBloc() : super(const CafeDetailsState()) {
    on<CafeDetailsInitial>(_onInitial);
    on<CafeDetailsEvent>((event, emit) {});
  }

  void _onInitial(CafeDetailsInitial event, Emitter<CafeDetailsState> emit) {
    emit(state.copyWith(status: CafeDetailsStatus.loading));

    try {

      
      emit(state.copyWith(status: CafeDetailsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CafeDetailsStatus.failure));
    }
  }
}
