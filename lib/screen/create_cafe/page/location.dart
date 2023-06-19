import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';
import 'package:latlong2/latlong.dart';

import '../bloc/create_cafe_bloc.dart';

class LocationForm extends StatelessWidget {
  const LocationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LocationFormView();
  }
}

class _LocationFormView extends StatefulWidget {
  const _LocationFormView();

  @override
  State<_LocationFormView> createState() => _LocationFormViewState();
}

class _LocationFormViewState extends State<_LocationFormView> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(kDefaultSpacing),
      children: [
        const SizedBox(height: kDefaultSpacing),
        SvgPicture.asset(
          'assets/svg/undraw_my_current_location_re_whmt.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Tambahkan lokasi cafemu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Berikan lokasi cafe kamu seakurat mungkin agar pengguna dapat menemukan cafe kamu dengan mudah.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
        const _AddressForm(),
        const SizedBox(height: kDefaultSpacing),
        const _SearchButton(),
        const SizedBox(height: kDefaultSpacing * 2),
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                BlocConsumer<CreateCafeBloc, CreateCafeState>(
                  listenWhen: (previous, current) =>
                      previous.coordinate != current.coordinate,
                  listener: (context, state) {
                    _mapController.move(state.coordinate,
                        _mapController.zoom > 15 ? _mapController.zoom : 15);
                  },
                  builder: (context, state) {
                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: const LatLng(-6.1769896, 106.8229453),
                        zoom: 5.0,
                        minZoom: 3.0,
                        maxZoom: 18.0,
                        onTap: (TapPosition position, LatLng latlng) {
                          BlocProvider.of<CreateCafeBloc>(context)
                              .add(CreateCafeLocationChanged(latlng));
                          FocusScope.of(context).unfocus();
                        },
                        onPointerUp: (event, point) =>
                            FocusScope.of(context).unfocus(),
                        onPointerDown: (event, point) =>
                            FocusScope.of(context).unfocus(),
                      ),
                      nonRotatedChildren: [
                        TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            backgroundColor: Colors.black54),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: state.coordinate,
                              width: 80,
                              height: 80,
                              rotate: false,
                              builder: (context) => Icon(Icons.location_on,
                                  color: ColorPallete.light.darkRed),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  right: 0,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const CircleBorder()),
                    onPressed: () {
                      BlocProvider.of<CreateCafeBloc>(context)
                          .add(CreateCafeGPSTaped());
                      FocusScope.of(context).unfocus();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(kDefaultSpacing / 2),
                      child: Icon(Icons.gps_fixed),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: kDefaultSpacing / 2),
      ],
    );
  }
}

class _AddressForm extends StatefulWidget {
  const _AddressForm();

  @override
  State<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<_AddressForm> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.text =
        BlocProvider.of<CreateCafeBloc>(context).state.cafeAddress.value;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCafeBloc, CreateCafeState>(
      listenWhen: (previous, current) =>
          previous.cafeAddress != current.cafeAddress &&
          previous.coordinate != current.coordinate,
      listener: (context, state) {
        if (state.cafeAddress.isValid) {
          _textEditingController.text = state.cafeAddress.value;
        }
      },
      builder: (context, state) {
        return CustomTextFormField(
          controller: _textEditingController,
          hintText: 'Alamat',
          maxLines: 3,
          radius: 10,
          onChanged: (String value) => BlocProvider.of<CreateCafeBloc>(context)
              .add(CreateCafeAddressFormChanged(value)),
        );
      },
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCafeBloc, CreateCafeState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status != CreateCafeStatus.loading
              ? () {
                  BlocProvider.of<CreateCafeBloc>(context)
                      .add(CreateCafeSearchAddress());
                  FocusScope.of(context).unfocus();
                }
              : null,
          child: state.status != CreateCafeStatus.loading
              ? const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultSpacing,
                    vertical: kDefaultSpacing / 2,
                  ),
                  child: Text('Cari alamat'),
                )
              : const SizedBox(
                  height: kDefaultSpacing,
                  width: kDefaultSpacing,
                  child: CircularProgressIndicator.adaptive(),
                ),
        );
      },
    );
  }
}
