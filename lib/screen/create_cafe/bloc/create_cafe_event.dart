part of 'create_cafe_bloc.dart';

abstract class CreateCafeEvent extends Equatable {
  const CreateCafeEvent();

  @override
  List<Object> get props => [];
}

class CreateCafeInitial extends CreateCafeEvent {
  const CreateCafeInitial(this.cafe);

  final Cafe? cafe;

  @override
  List<Object> get props => [];
}

class CreateCafeNextPage extends CreateCafeEvent {}

class CreateCafePreviousPage extends CreateCafeEvent {}

class CreateCafeAddMenu extends CreateCafeEvent {}

class CreateCafeMenuChanged extends CreateCafeEvent {
  const CreateCafeMenuChanged(this.menu, this.index);

  final Menu menu;
  final int index;

  @override
  List<Object> get props => [menu, index];
}

class CreateCafeEnableFacility extends CreateCafeEvent {
  const CreateCafeEnableFacility(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class CreateCafeGPSTaped extends CreateCafeEvent {}

class CreateCafeSearchAddress extends CreateCafeEvent {}

class CreateCafeOnDone extends CreateCafeEvent {}

class CreateCafeNameChanged extends CreateCafeEvent {
  const CreateCafeNameChanged(this.cafeName);

  final String cafeName;

  @override
  List<Object> get props => [cafeName];
}

class CreateCafeDescriptionChanged extends CreateCafeEvent {
  const CreateCafeDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class CreateCafeAddressFormChanged extends CreateCafeEvent {
  const CreateCafeAddressFormChanged(this.address);

  final String address;

  @override
  List<Object> get props => [address];
}

class CreateCafeLocationChanged extends CreateCafeEvent {
  const CreateCafeLocationChanged(this.latlng);

  final LatLng latlng;

  @override
  List<Object> get props => [latlng];
}

class CreateCafeOpenTimeChanged extends CreateCafeEvent {
  const CreateCafeOpenTimeChanged(this.openTime);

  final OpenTime openTime;

  @override
  List<Object> get props => [openTime];
}

class CreateCafeAddPicture extends CreateCafeEvent {
  const CreateCafeAddPicture(this.images);

  final List<File> images;

  @override
  List<Object> get props => [images];
}

class CreateCafeDeletePicture extends CreateCafeEvent {
  const CreateCafeDeletePicture(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}
