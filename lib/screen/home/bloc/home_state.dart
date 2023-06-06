part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

@JsonSerializable()
class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.message = '',
    this.currentTabIndex = 0,
    this.cafes = const [],
    this.hasReachedMax = false,
  });

  final HomeStatus status;

  final String message;

  final List<Cafe> cafes;

  final bool hasReachedMax;

  @JsonKey(includeFromJson: false)
  final int currentTabIndex;

  HomeState copyWith({
    HomeStatus? status,
    String? message,
    int? currentTabIndex,
    List<Cafe>? cafes,
    bool? hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message ?? this.message,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      cafes: cafes ?? this.cafes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  List<Object> get props => [
        status,
        message,
        currentTabIndex,
        cafes,
        hasReachedMax,
      ];
}
