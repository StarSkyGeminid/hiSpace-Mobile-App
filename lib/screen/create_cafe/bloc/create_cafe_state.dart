part of 'create_cafe_bloc.dart';

enum CreateCafeStatus { initial, loading, success, failure }

class CreateCafeState extends Equatable {
  const CreateCafeState({
    this.status = CreateCafeStatus.initial,
    this.cafeName = const CafeName.pure(),
    this.cafeDescription = const CafeDescription.pure(),
    this.isValidated = false,
    this.coordinate = const LatLng(-6.1769896, 106.8229453),
    this.cafeAddress = const CafeAddress.pure(),
    this.openTime = OpenTime.empty,
    this.images = const [],
  });

  final CreateCafeStatus status;

  final CafeName cafeName;

  final CafeDescription cafeDescription;

  final CafeAddress cafeAddress;

  final bool isValidated;

  final LatLng coordinate;

  final OpenTime openTime;

  final List<XFile> images;

  CreateCafeState copyWith({
    CreateCafeStatus? status,
    CafeName? cafeName,
    CafeDescription? cafeDescription,
    bool? isValidated,
    LatLng? latlng,
    CafeAddress? cafeAddress,
    OpenTime? openTime,
    List<XFile>? images,
  }) {
    return CreateCafeState(
      status: status ?? this.status,
      cafeName: cafeName ?? this.cafeName,
      cafeDescription: cafeDescription ?? this.cafeDescription,
      isValidated: isValidated ?? this.isValidated,
      coordinate: latlng ?? coordinate,
      cafeAddress: cafeAddress ?? this.cafeAddress,
      openTime: openTime ?? this.openTime,
      images: images ?? this.images,
    );
  }

  @override
  List<Object> get props => [
        status,
        cafeName,
        cafeDescription,
        isValidated,
        coordinate,
        cafeAddress,
        openTime,
        images,
      ];

  
}
