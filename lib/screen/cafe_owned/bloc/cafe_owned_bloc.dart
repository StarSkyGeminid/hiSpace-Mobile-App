import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cafe_owned_event.dart';
part 'cafe_owned_state.dart';

class CafeOwnedBloc extends Bloc<CafeOwnedEvent, CafeOwnedState> {
  CafeOwnedBloc() : super(CafeOwnedInitial()) {
    on<CafeOwnedEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
