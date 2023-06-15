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
    this.currentLocation = const LatLng(0, 0),
  });

  final HomeStatus status;

  final String message;

  final List<Cafe> cafes;

  final bool hasReachedMax;

  final LatLng currentLocation;

  @JsonKey(includeFromJson: false)
  final int currentTabIndex;

  HomeState copyWith({
    HomeStatus? status,
    String? message,
    int? currentTabIndex,
    List<Cafe>? cafes,
    bool? hasReachedMax,
    LatLng? currentLocation,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message ?? this.message,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      cafes: cafes ?? this.cafes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  List<Object> get props => [
        status,
        message,
        cafes,
        currentTabIndex,
        hasReachedMax,
        currentLocation,
      ];
}
