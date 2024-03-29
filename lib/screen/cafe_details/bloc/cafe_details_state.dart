// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cafe_details_bloc.dart';

enum CafeDetailsStatus { initial, loading, success, failure }

class CafeDetailsState extends Equatable {
  const CafeDetailsState({
    this.status = CafeDetailsStatus.initial,
    this.cafe = Cafe.empty,
    this.isOwned = false,
    this.isReviewed = false,
  });

  final CafeDetailsStatus status;

  final Cafe cafe;

  final bool isOwned;

  final bool isReviewed;

  CafeDetailsState copyWith({
    CafeDetailsStatus? status,
    Cafe? cafe,
    bool? isOwned,
    bool? isReviewed,
  }) {
    return CafeDetailsState(
      status: status ?? this.status,
      cafe: cafe ?? this.cafe,
      isOwned: isOwned ?? this.isOwned,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  @override
  List<Object> get props => [status, cafe, isOwned, isReviewed];
}
