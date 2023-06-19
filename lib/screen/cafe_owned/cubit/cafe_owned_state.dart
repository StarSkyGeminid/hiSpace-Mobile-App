part of 'cafe_owned_cubit.dart';

enum CafeOwnedStatus { initial, loading, success, failure }

class CafeOwnedState extends Equatable {
  const CafeOwnedState({
    this.status = CafeOwnedStatus.initial,
    this.ownerId = '',
    this.cafes = const <Cafe>[],
  });

  final CafeOwnedStatus status;

  final String ownerId;

  final List<Cafe> cafes;

  CafeOwnedState copyWith({
    CafeOwnedStatus? status,
    String? ownerId,
    List<Cafe>? cafes,
  }) {
    return CafeOwnedState(
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
      cafes: cafes ?? this.cafes,
    );
  }

  @override
  List<Object> get props => [
        status,
        ownerId,
        cafes,
      ];
}
