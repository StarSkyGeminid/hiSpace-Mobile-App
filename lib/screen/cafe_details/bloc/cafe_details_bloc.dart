import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hispace_mobile_app/screen/create_cafe/model/facility_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'cafe_details_event.dart';
part 'cafe_details_state.dart';

class CafeDetailsBloc extends Bloc<CafeDetailsEvent, CafeDetailsState> {
  CafeDetailsBloc(CafeRepository cafeRepository, String currentUserId)
      : _cafeRepository = cafeRepository,
        _currentUserId = currentUserId,
        super(const CafeDetailsState()) {
    on<CafeDetailsInitial>(_onInitial);
    on<CafeDetailsRemove>(_onRemove);
    on<CafeDetailsOnOpenMaps>(_onOpenMaps);
    on<CafeDetailsEvent>((event, emit) {});
  }

  final String _currentUserId;

  final CafeRepository _cafeRepository;

  Future<void> _onInitial(
      CafeDetailsInitial event, Emitter<CafeDetailsState> emit) async {
    emit(state.copyWith(status: CafeDetailsStatus.loading));

    try {
      var cafe = await _cafeRepository.user.getCafeByLocationId(event.locationId);

      if (cafe.facilities != null) {
        var facilities = cafe.facilities!.map(
          (e) => e.copyWith(
              iconData: listFacilities
                  .firstWhere((element) => element.name == e.name)
                  .iconData),
        );

        cafe = cafe.copyWith(facilities: facilities.toList());
      }

      emit(state.copyWith(
        cafe: cafe,
        status: CafeDetailsStatus.success,
        isOwned: cafe.userUserId == _currentUserId,
        isReviewed: cafe.reviews
            ?.map((element) => element.user.userId)
            .contains(_currentUserId),
      ));
    } catch (e) {
      emit(state.copyWith(status: CafeDetailsStatus.failure));
    }
  }

  Future<void> _onRemove(
      CafeDetailsRemove event, Emitter<CafeDetailsState> emit) async {
    emit(state.copyWith(status: CafeDetailsStatus.loading));

    try {
      await _cafeRepository.owner.remove(state.cafe.locationId);
      emit(state.copyWith(status: CafeDetailsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CafeDetailsStatus.failure));
    }
  }

  Future<void> _onOpenMaps(
      CafeDetailsOnOpenMaps event, Emitter<CafeDetailsState> emit) async {
    emit(state.copyWith(status: CafeDetailsStatus.loading));

    try {
      double lat = state.cafe.latitude;
      double lon = state.cafe.longitude;

      String appleUrl =
          'https://maps.apple.com/?saddr=&daddr=$lat,$lon&directionsmode=driving';
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$lat,$lon';

      if (Platform.isIOS) {
        if (await canLaunchUrlString(appleUrl)) {
          await launchUrlString(appleUrl);
        } else {
          if (await canLaunchUrlString(googleUrl)) {
            await launchUrlString(googleUrl,
                mode: LaunchMode.externalNonBrowserApplication);
          } else {
            throw 'Could not open the map.';
          }
        }
      } else {
        if (await canLaunchUrlString(googleUrl)) {
          await launchUrlString(googleUrl,
              mode: LaunchMode.externalNonBrowserApplication);
        } else {
          throw 'Could not open the map.';
        }
      }
      emit(state.copyWith(status: CafeDetailsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CafeDetailsStatus.failure));
    }
  }
}
