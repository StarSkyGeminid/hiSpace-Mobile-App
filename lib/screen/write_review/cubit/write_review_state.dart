part of 'write_review_cubit.dart';

enum WriteReviewStatus { initial, loading, success, failure }

class WriteReviewState extends Equatable {
  const WriteReviewState({
    this.rating = 5,
    this.isValidated = false,
    this.review = const CafeReview.pure(),
    this.status = WriteReviewStatus.initial,
    this.message = '',
  });

  final WriteReviewStatus status;

  final bool isValidated;

  final int rating;

  final CafeReview review;

  final String message;

  WriteReviewState copyWith({
    WriteReviewStatus? status,
    bool? isValidated,
    int? rating,
    CafeReview? review,
    String? message,
  }) {
    return WriteReviewState(
      status: status ?? this.status,
      isValidated: isValidated ?? this.isValidated,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [rating, isValidated, status, review, message];
}
