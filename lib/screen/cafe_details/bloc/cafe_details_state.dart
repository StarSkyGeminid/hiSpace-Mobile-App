// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cafe_details_bloc.dart';

enum CafeDetailsStatus { initial, loading, success, failure }

class CafeDetailsState extends Equatable {
  const CafeDetailsState({
    this.status = CafeDetailsStatus.initial,
    this.cafe = Cafe.empty,
  });

  final CafeDetailsStatus status;

  final Cafe cafe;

  CafeDetailsState copyWith({
    CafeDetailsStatus? status,
    Cafe? cafe,
  }) {
    return CafeDetailsState(
      status: status ?? this.status,
      cafe: cafe ?? this.cafe,
    );
  }

  @override
  List<Object> get props => [status];
}
