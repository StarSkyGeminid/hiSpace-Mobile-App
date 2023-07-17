import 'package:bloc/bloc.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/formz_models/review.dart';
import 'package:user_repository/user_repository.dart';

part 'write_review_state.dart';

class WriteReviewCubit extends Cubit<WriteReviewState> {
  WriteReviewCubit(CafeRepository cafeRepository, User user, String locationId)
      : _cafeRepository = cafeRepository,
        _user = user,
        _locationId = locationId,
        super(const WriteReviewState());

  final CafeRepository _cafeRepository;

  final User _user;
  final String _locationId;

  void ratingChanged(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void reviewChanged(String review) {
    emit(state.copyWith(
      review: CafeReview.dirty(review),
      isValidated: Formz.validate([state.review]),
    ));
  }

  Future<void> submit() async {
    emit(state.copyWith(status: WriteReviewStatus.loading));

    try {
      Review review = Review(
        rating: state.rating.toDouble(),
        review: state.review.value,
        locationId: _locationId,
        user: UserModel.empty.copyWith(userId: _user.id),
      );

      bool status = await _cafeRepository.user.addReview(review);

      String message =
          status ? 'Ulasan berhasil ditambahkan' : 'Kamu sudah memberi ulasan!';

      emit(state.copyWith(
          status:
              status ? WriteReviewStatus.success : WriteReviewStatus.failure,
          message: message));
    } catch (e) {
      emit(state.copyWith(
          status: WriteReviewStatus.failure,
          message: 'Ulasan gagal ditambahkan'));
    }
  }
}
