import 'package:bloc/bloc.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hispace_mobile_app/formz_models/cafe_address.dart';
import 'package:hispace_mobile_app/formz_models/cafe_description.dart';
import 'package:hispace_mobile_app/formz_models/cafe_name.dart';
import 'package:image_picker/image_picker.dart';

part 'create_cafe_event.dart';
part 'create_cafe_state.dart';

class CreateCafeBloc extends Bloc<CreateCafeEvent, CreateCafeState> {
  CreateCafeBloc(GeoLocationRepository geoLocationRepository,
      CafeRepository cafeRepository)
      : _geoLocationRepository = geoLocationRepository,
        _cafeRepository = cafeRepository,
        super(const CreateCafeState()) {
    on<CreateCafeInitial>(_onInitial);
    on<CreateCafeNextPage>(_onNextPage);
    on<CreateCafeNameChanged>(_onNameChanged);
    on<CreateCafeGPSTaped>(_onGPSTaped);
    on<CreateCafeAddressFormChanged>(_onAddressFormChanged);
    on<CreateCafeLocationChanged>(_onLocationChanged);
    on<CreateCafeSearchAddress>(_onSearchLocationTapped);
    on<CreateCafeDescriptionChanged>(_onDescriptionChanged);
    on<CreateCafeOpenTimeChanged>(_onOpenTimeChanged);
    on<CreateCafeAddPicture>(_onAddPicture);
    on<CreateCafeDeletePicture>(_onDeletePicture);

    on<CreateCafeEvent>((event, emit) {});
  }

  final GeoLocationRepository _geoLocationRepository;

  final CafeRepository _cafeRepository;

  int currentPage = 0;

  void _onInitial(CreateCafeInitial event, Emitter<CreateCafeState> emit) {
    emit(state.copyWith());
  }

  void _onNameChanged(
      CreateCafeNameChanged event, Emitter<CreateCafeState> emit) {
    final cafeName = CafeName.dirty(event.cafeName);
    emit(state.copyWith(
      cafeName: cafeName,
      isValidated: Formz.validate([cafeName]),
    ));
  }

  void _onDescriptionChanged(
      CreateCafeDescriptionChanged event, Emitter<CreateCafeState> emit) {
    final cafeDescription = CafeDescription.dirty(event.description);
    emit(state.copyWith(
      cafeDescription: cafeDescription,
      isValidated: Formz.validate([cafeDescription, state.cafeName]),
    ));
  }

  Future<void> _onGPSTaped(
      CreateCafeGPSTaped event, Emitter<CreateCafeState> emit) async {
    emit(state.copyWith(isValidated: false));

    Position? position = await _geoLocationRepository.getCurrentPosition();

    if (position == null) {
      emit(state.copyWith(isValidated: false));
      return;
    }

    Location? location = await _geoLocationRepository
        .getLocationFromCoordinates(position.latitude, position.longitude);

    emit(state.copyWith(
      isValidated: true,
      latlng: LatLng(position.latitude, position.longitude),
      cafeAddress:
          location != null ? CafeAddress.dirty(location.address) : null,
    ));
  }

  void _onAddressFormChanged(
      CreateCafeAddressFormChanged event, Emitter<CreateCafeState> emit) {
    emit(state.copyWith(isValidated: false));

    final cafeAddress = CafeAddress.dirty(event.address);

    emit(state.copyWith(
      cafeAddress: cafeAddress,
    ));
  }

  Future<void> _onLocationChanged(
      CreateCafeLocationChanged event, Emitter<CreateCafeState> emit) async {
    emit(state.copyWith(isValidated: true, latlng: event.latlng));

    Location? location =
        await _geoLocationRepository.getLocationFromCoordinates(
            event.latlng.latitude, event.latlng.longitude);

    if (location == null) return;

    emit(state.copyWith(
      isValidated: true,
      latlng: LatLng(location.latitude, location.longitude),
      cafeAddress: CafeAddress.dirty(location.address),
    ));
  }

  Future<void> _onSearchLocationTapped(
      CreateCafeSearchAddress event, Emitter<CreateCafeState> emit) async {
    emit(state.copyWith(isValidated: false));

    try {
      if (state.cafeAddress.isNotValid) return;

      Location? location = await _geoLocationRepository
          .getLocationFromQuery(state.cafeAddress.value);

      if (location == null) return;

      emit(state.copyWith(
        isValidated: true,
        latlng: LatLng(location.latitude, location.longitude),
        cafeAddress: CafeAddress.dirty(location.address),
      ));
    } catch (e) {
      emit(state.copyWith(isValidated: false));
    }
  }

  void _onOpenTimeChanged(
      CreateCafeOpenTimeChanged event, Emitter<CreateCafeState> emit) {
    emit(state.copyWith(
      isValidated: true,
      openTime: event.openTime,
    ));
  }

  void _onAddPicture(
      CreateCafeAddPicture event, Emitter<CreateCafeState> emit) {
    emit(state.copyWith(status: CreateCafeStatus.loading));

    final newImages = [...state.images, ...event.images];

    emit(state.copyWith(
      status: CreateCafeStatus.success,
      isValidated: newImages.isNotEmpty,
      images: newImages,
    ));
  }

  void _onDeletePicture(
      CreateCafeDeletePicture event, Emitter<CreateCafeState> emit) {
    emit(state.copyWith(status: CreateCafeStatus.loading));

    final newImages = state.images..removeAt(event.index);

    emit(state.copyWith(
      status: CreateCafeStatus.success,
      isValidated: newImages.isNotEmpty,
      images: newImages,
    ));
  }

  Future<void> _onNextPage(
      CreateCafeNextPage event, Emitter<CreateCafeState> emit) async {
    emit(state.copyWith(isValidated: false));

    currentPage++;

    if (currentPage < 5) return;

    emit(state.copyWith(status: CreateCafeStatus.loading));
    try {
      List<Galery> galeries =
          state.images.map((e) => Galery(id: e.name, url: e.path)).toList();

      Cafe cafe = Cafe(
        name: state.cafeName.value,
        description: state.cafeDescription.value,
        address: state.cafeAddress.value,
        latitude: state.coordinate.latitude,
        longitude: state.coordinate.longitude,
        rawTime: state.openTime.toJson(),
        galeries: galeries,
        galeryId: '',
        locationId: '',
        isFavorite: false,
        owner: '',
        rating: 0.0,
        user: '',
        userUserId: '',
      );

      await _cafeRepository.addLocation(cafe);
      emit(state.copyWith(status: CreateCafeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CreateCafeStatus.failure));
    }
  }
}
