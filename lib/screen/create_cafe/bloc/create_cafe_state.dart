part of 'create_cafe_bloc.dart';

enum CreateCafeStatus { initial, loading, success, failure }

class CreateCafeState extends Equatable {
  const CreateCafeState({
    this.status = CreateCafeStatus.initial,
    this.cafeName = const CafeName.pure(),
    this.cafeDescription = const CafeDescription.pure(),
    this.menus = const [],
    this.facilities = listFacilities,
    this.isValidated = false,
    this.coordinate = const LatLng(-6.1769896, 106.8229453),
    this.cafeAddress = const CafeAddress.pure(),
    this.openTime = OpenTime.empty,
    this.images = const [],
    this.currentPage = 0,
  });

  final CreateCafeStatus status;

  final CafeName cafeName;

  final CafeDescription cafeDescription;

  final CafeAddress cafeAddress;

  final List<Menu> menus;

  final List<Facility> facilities;

  final bool isValidated;

  final LatLng coordinate;

  final OpenTime openTime;

  final List<XFile> images;

  final int currentPage;

  CreateCafeState copyWith({
    CreateCafeStatus? status,
    CafeName? cafeName,
    CafeDescription? cafeDescription,
    List<Menu>? menus,
    bool? isValidated,
    LatLng? latlng,
    CafeAddress? cafeAddress,
    OpenTime? openTime,
    List<XFile>? images,
    int? currentPage,
    List<Facility>? facilities,
  }) {
    return CreateCafeState(
      status: status ?? this.status,
      cafeName: cafeName ?? this.cafeName,
      cafeDescription: cafeDescription ?? this.cafeDescription,
      menus: menus ?? this.menus,
      isValidated: isValidated ?? this.isValidated,
      coordinate: latlng ?? coordinate,
      cafeAddress: cafeAddress ?? this.cafeAddress,
      openTime: openTime ?? this.openTime,
      images: images ?? this.images,
      currentPage: currentPage ?? this.currentPage,
      facilities: facilities ?? this.facilities,
    );
  }

  @override
  List<Object> get props => [
        status,
        cafeName,
        cafeDescription,
        menus,
        isValidated,
        coordinate,
        cafeAddress,
        openTime,
        images,
        currentPage,
        facilities,
      ];
}
