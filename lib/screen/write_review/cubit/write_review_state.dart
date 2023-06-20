part of 'write_review_cubit.dart';

enum WriteReviewStatus { initial, loading, success, failure }

class WriteReviewState extends Equatable {
  const WriteReviewState({
    this.rating = 5,
    this.review = const Review.pure(),
    this.status = WriteReviewStatus.initial,
  });

  final WriteReviewStatus status;

  final int rating;

  final Review review;

  WriteReviewState copyWith({
    WriteReviewStatus? status,
    int? rating,
    Review? review,
  }) {
    return WriteReviewState(
      status: status ?? this.status,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  @override
  List<Object> get props => [rating, review];
}
