import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hispace_mobile_app/formz_models/cafe_address.dart';
import 'package:hispace_mobile_app/formz_models/cafe_description.dart';
import 'package:hispace_mobile_app/formz_models/cafe_name.dart';
import 'package:path/path.dart';

import '../model/facility_model.dart';

part 'create_cafe_event.dart';
part 'create_cafe_state.dart';

class CreateCafeBloc extends Bloc<CreateCafeEvent, CreateCafeState> {
  CreateCafeBloc(
    GeoLocationRepository geoLocationRepository,
    CafeRepository cafeRepository,
  )   : _geoLocationRepository = geoLocationRepository,
        _cafeRepository = cafeRepository,
        super(const CreateCafeState()) {
    on<CreateCafeInitial>(_onInitial);
    on<CreateCafeNextPage>(_onNextPage);
    on<CreateCafePreviousPage>(_onPreviousPage);
    on<CreateCafeNameChanged>(_onNameChanged);
    on<CreateCafeGPSTaped>(_onGPSTaped);
    on<CreateCafeAddressFormChanged>(_onAddressFormChanged);
    on<CreateCafeLocationChanged>(_onLocationChanged);
    on<CreateCafeSearchAddress>(_onSearchLocationTapped);
    on<CreateCafeDescriptionChanged>(_onDescriptionChanged);
    on<CreateCafeOpenTimeChanged>(_onOpenTimeChanged);
    on<CreateCafeAddPicture>(_onAddPicture);
    on<CreateCafeAddMenu>(_onAddMenu);
    on<CreateCafeMenuChanged>(_onMenuChanged);
    on<CreateCafeEnableFacility>(_onEnableFacility);
    on<CreateCafeDeletePicture>(_onDeletePicture);
    on<CreateCafeOnDone>(_onDone);

    on<CreateCafeEvent>((event, emit) {});
  }

  final GeoLocationRepository _geoLocationRepository;

  final CafeRepository _cafeRepository;

  final int totalPage = 8;

  String locationId = '';

  Future<void> _onInitial(
      CreateCafeInitial event, Emitter<CreateCafeState> emit) async {
    bool isEdit = event.cafe != null;

    if (!isEdit) {
      emit(state.copyWith(
        status: CreateCafeStatus.success,
        menus: [Menu.empty],
        isEdit: isEdit,
      ));

      return;
    }

    if (event.cafe == null) return;

    try {
      locationId = event.cafe!.locationId;

      Cafe cafe = await _cafeRepository
          .getCafeByLocationId(event.cafe!.locationId, cached: true);

      List<File> images = [];

      for (Galery image in cafe.galeries!) {
        var file = File(image.url);
        images.add(file);
      }

      List<Facility> facilities = List<Facility>.from(state.facilities);

      if (cafe.facilities != null) {
        for (var facility in cafe.facilities!) {
          int index = facilities.indexWhere((e) => e.name == facility.name);

          if (index != -1) {
            facilities[index] = facilities[index].copyWith(isCheck: true);
          }
        }
      }

      emit(state.copyWith(
        cafeName: CafeName.dirty(cafe.name),
        cafeDescription: CafeDescription.dirty(cafe.description),
        cafeAddress: CafeAddress.dirty(cafe.address),
        latlng: LatLng(cafe.latitude, cafe.longitude),
        openTime: cafe.time,
        menus: cafe.menus,
        facilities: facilities,
        isValidated: true,
        images: images,
        isEdit: isEdit,
        status: CreateCafeStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CreateCafeStatus.failure,
      ));
    }
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
    emit(state.copyWith(isValidated: false, status: CreateCafeStatus.loading));

    Position? position = await _geoLocationRepository.getCurrentPosition();

    if (position == null) {
      emit(
          state.copyWith(isValidated: false, status: CreateCafeStatus.failure));

      return;
    }

    Location? location = await _geoLocationRepository
        .getLocationFromCoordinates(position.latitude, position.longitude);

    emit(state.copyWith(
      isValidated: true,
      status: CreateCafeStatus.success,
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
    emit(state.copyWith(isValidated: false, status: CreateCafeStatus.loading));

    Location? location =
        await _geoLocationRepository.getLocationFromCoordinates(
            event.latlng.latitude, event.latlng.longitude);

    if (location == null) {
      emit(
          state.copyWith(isValidated: false, status: CreateCafeStatus.failure));
      return;
    }

    emit(state.copyWith(
        isValidated: true,
        latlng: event.latlng,
        cafeAddress: CafeAddress.dirty(location.address),
        status: CreateCafeStatus.success));
  }

  Future<void> _onSearchLocationTapped(
      CreateCafeSearchAddress event, Emitter<CreateCafeState> emit) async {
    emit(state.copyWith(isValidated: false, status: CreateCafeStatus.loading));

    try {
      if (state.cafeAddress.isNotValid) return;

      Location? location = await _geoLocationRepository
          .getLocationFromQuery(state.cafeAddress.value);

      if (location == null) return;

      emit(state.copyWith(
          isValidated: true,
          latlng: LatLng(location.latitude, location.longitude),
          cafeAddress: CafeAddress.dirty(location.address),
          status: CreateCafeStatus.success));
    } catch (e) {
      emit(state.copyWith(isValidated: false));
    }
  }

  void _onOpenTimeChanged(
      CreateCafeOpenTimeChanged event, Emitter<CreateCafeState> emit) {
    emit(state.copyWith(
      isValidated: event.openTime.isValid(),
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
    bool isValidated = false;

    int newPage = state.currentPage + 1;

    switch (newPage) {
      case 0:
        isValidated = Formz.validate([state.cafeName]);
        break;
      case 1:
        isValidated = Formz.validate([state.cafeDescription]);
        break;
      case 2:
        isValidated = state.coordinate.latitude.isFinite &&
            state.coordinate.longitude.isFinite &&
            Formz.validate([state.cafeAddress]) &&
            state.cafeAddress.value.isNotEmpty;
        break;
      case 3:
        isValidated = state.openTime.isValid();
        break;
      case 4:
        isValidated = state.images.isNotEmpty;
        break;
      case 5:
        isValidated = state.menus.map((e) => e.isNotEmpty).contains(true);
        break;
      case 6:
        isValidated = true;
        break;
      default:
        isValidated = false;
        break;
    }

    if (state.currentPage < totalPage - 1) {
      emit(state.copyWith(isValidated: isValidated, currentPage: newPage));
    }

    add(CreateCafeOnDone());
  }

  void _onPreviousPage(
      CreateCafePreviousPage event, Emitter<CreateCafeState> emit) {
    final newPage = state.currentPage - 1;

    if (newPage < 0) return;
    emit(state.copyWith(isValidated: true, currentPage: newPage));
  }

  void _onAddMenu(CreateCafeAddMenu event, Emitter<CreateCafeState> emit) {
    final newMenus = [...state.menus, Menu.empty];

    emit(state.copyWith(
      status: CreateCafeStatus.success,
      isValidated:
          !newMenus.map((e) => e.isNotEmpty || e.isEmpty).contains(false),
      menus: newMenus,
    ));
  }

  void _onMenuChanged(
      CreateCafeMenuChanged event, Emitter<CreateCafeState> emit) {
    var newMenus = List<Menu>.from(state.menus);

    newMenus[event.index] = event.menu;

    emit(state.copyWith(
      status: CreateCafeStatus.success,
      isValidated:
          !newMenus.map((e) => e.isNotEmpty || e.isEmpty).contains(false),
      menus: newMenus,
    ));
  }

  void _onEnableFacility(
      CreateCafeEnableFacility event, Emitter<CreateCafeState> emit) {
    List<Facility> newFacilities = List.from(state.facilities);

    var currentFacility = newFacilities[event.index];

    newFacilities[event.index] = currentFacility.copyWith(
      isCheck: !currentFacility.isCheck,
    );

    emit(state.copyWith(
      status: CreateCafeStatus.success,
      isValidated: true,
      facilities: newFacilities,
    ));
  }

  Future<void> _onDone(
      CreateCafeOnDone event, Emitter<CreateCafeState> emit) async {
    if (state.currentPage < totalPage - 1) return;

    emit(state.copyWith(
      status: CreateCafeStatus.loading,
      currentPage: state.currentPage + 1,
    ));

    try {
      List<Galery> galeries = state.images
          .map((e) => Galery(id: basename(e.path), url: e.path))
          .toList();

      Cafe cafe = Cafe.empty.copyWith(
        name: state.cafeName.value,
        description: state.cafeDescription.value,
        address: state.cafeAddress.value,
        latitude: state.coordinate.latitude,
        longitude: state.coordinate.longitude,
        rawTime: state.openTime.toJson(),
        galeries: galeries,
        locationId: locationId,
        isFavorite: false,
      );

      var facilities = state.facilities
          .where((element) => element.isCheck)
          .map((e) => e)
          .toList();

      if (state.isEdit) {
        await _cafeRepository.updateLocation(cafe);

        await _cafeRepository.updateMenus(state.menus, cafe.locationId);

        await _cafeRepository.updateFacility(facilities, cafe.locationId);
      } else {
        locationId = await _cafeRepository.addLocation(cafe);
        await _cafeRepository.addMenus(state.menus, locationId);

        await _cafeRepository.addFacility(facilities, locationId);
      }

      emit(state.copyWith(
          isValidated: true,
          currentPage: state.currentPage + 1,
          status: CreateCafeStatus.success));
    } catch (e) {
      emit(state.copyWith(
          isValidated: true,
          currentPage: state.currentPage + 1,
          status: CreateCafeStatus.failure));
    }
  }
}
