import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../formz_models/review.dart';

part 'write_review_state.dart';

class WriteReviewCubit extends Cubit<WriteReviewState> {
  WriteReviewCubit() : super(WriteReviewState());

  void ratingChanged(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void reviewChanged(String review) {
    emit(state.copyWith(review: Review.dirty(review)));
  }

  void submit() {
    emit(state.copyWith(status: WriteReviewStatus.loading));

    try {
      
    } catch (e) {
      emit(state.copyWith(status: WriteReviewStatus.failure));
    }
  }
}
