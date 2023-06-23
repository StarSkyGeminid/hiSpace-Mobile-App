part of 'cafe_search_bloc.dart';

abstract class CafeSearchEvent extends Equatable {
  const CafeSearchEvent();

  @override
  List<Object> get props => [];
}

class CafeSearchOnFormChanged extends CafeSearchEvent {
  const CafeSearchOnFormChanged(this.value);

  final String value;

  @override
  List<Object> get props => [];
}

class CafeSearchOnPriceStartChanged extends CafeSearchEvent {
  const CafeSearchOnPriceStartChanged(this.value);

  final String value;

  @override
  List<Object> get props => [];
}

class CafeSearchOnPriceEndChanged extends CafeSearchEvent {
  const CafeSearchOnPriceEndChanged(this.value);

  final String value;

  @override
  List<Object> get props => [];
}

class CafeSearchOnLocationChanged extends CafeSearchEvent {
  const CafeSearchOnLocationChanged(this.latlng);

  final LatLng latlng;

  @override
  List<Object> get props => [];
}

class CafeSearchOnGPSTapped extends CafeSearchEvent {
  const CafeSearchOnGPSTapped();
}

class CafeSearchOnSubmitted extends CafeSearchEvent {
  const CafeSearchOnSubmitted();
}
