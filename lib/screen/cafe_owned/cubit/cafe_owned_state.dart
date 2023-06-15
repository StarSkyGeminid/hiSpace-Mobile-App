part of 'cafe_owned_cubit.dart';

enum CafeOwnedStatus { initial, loading, success, failure }

class CafeOwnedState extends Equatable {
  const CafeOwnedState({
    this.status = CafeOwnedStatus.initial,
    this.cafes = const <Cafe>[],
  });

  final CafeOwnedStatus status;

  final List<Cafe> cafes;

  CafeOwnedState copyWith({
    CafeOwnedStatus? status,
    List<Cafe>? cafes,
  }) {
    return CafeOwnedState(
      status: status ?? this.status,
      cafes: cafes ?? this.cafes,
    );
  }

  @override
  List<Object> get props => [
        status,
        cafes,
  ];
}
