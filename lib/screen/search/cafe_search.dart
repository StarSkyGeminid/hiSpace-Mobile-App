import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocation_repository/geolocation_repository.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import 'bloc/cafe_search_bloc.dart';

class CafeSearch extends StatelessWidget {
  const CafeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CafeSearchBloc(
        RepositoryProvider.of<GeoLocationRepository>(context),
      ),
      child: const _CafeSearchView(),
    );
  }
}

class _CafeSearchView extends StatelessWidget {
  const _CafeSearchView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Text('Cari', style: Theme.of(context).textTheme.titleMedium),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
              kDefaultSpacing, kDefaultSpacing, kDefaultSpacing, 0),
          children: [
            BlocBuilder<CafeSearchBloc, CafeSearchState>(
              builder: (context, state) {
                return CustomTextFormField(
                  hintText: 'Cari Cafe',
                  onChanged: (value) => context
                      .read<CafeSearchBloc>()
                      .add(CafeSearchOnFormChanged(value)),
                );
              },
            ),
            const SizedBox(height: kDefaultSpacing),
            const _PriceFilter(),
            const SizedBox(height: kDefaultSpacing),
            const _Location(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: BlocBuilder<CafeSearchBloc, CafeSearchState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.searchModel.isValid() != current.searchModel.isValid(),
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.searchModel.isValid()
                    ? () {
                        Navigator.pushNamed(context, '/cafe/search_result',
                            arguments: BlocProvider.of<CafeSearchBloc>(context)
                                .state
                                .searchModel);
                      }
                    : null,
                child: const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * 0.8),
                  child: Text('Cari'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PriceFilter extends StatefulWidget {
  const _PriceFilter();

  @override
  State<_PriceFilter> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<_PriceFilter> {
  final CurrencyTextInputFormatter _formatterPriceStart =
      CurrencyTextInputFormatter(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  final CurrencyTextInputFormatter _formatterPriceEnd =
      CurrencyTextInputFormatter(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rentang Harga',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Row(
          children: [
            BlocBuilder<CafeSearchBloc, CafeSearchState>(
              builder: (context, state) {
                return Flexible(
                  child: CustomTextFormField(
                    key: const Key('CafeSearch_TextFormField_PriceStart'),
                    inputFormatters: [_formatterPriceStart],
                    initialValue: state.searchModel.priceFrom != null
                        ? _formatterPriceStart
                            .format(state.searchModel.priceFrom!.toString())
                        : null,
                    textInputType: TextInputType.number,
                    hintText: 'Harga Minimum',
                    onChanged: (value) => context.read<CafeSearchBloc>().add(
                        CafeSearchOnPriceStartChanged(
                            (_formatterPriceStart.getUnformattedValue() as int)
                                .toDouble())),
                    errorText: state.searchModel.priceFrom != null &&
                            state.searchModel.priceTo != null &&
                            state.searchModel.priceFrom! >
                                state.searchModel.priceTo!
                        ? 'Harga minimum harus lebih kecil dari harga maksimum'
                        : null,
                  ),
                );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultSpacing / 2),
              child: Icon(Icons.arrow_forward_rounded,
                  color: ColorPallete.light.grey),
            ),
            BlocBuilder<CafeSearchBloc, CafeSearchState>(
              builder: (context, state) {
                return Flexible(
                  child: CustomTextFormField(
                    key: const Key("CafeSearch_TextFormField_PriceEnd"),
                    inputFormatters: [_formatterPriceEnd],
                    initialValue: state.searchModel.priceTo != null
                        ? _formatterPriceEnd
                            .format(state.searchModel.priceTo!.toString())
                        : null,
                    textInputType: TextInputType.number,
                    hintText: 'Harga Maksimum',
                    onChanged: (value) => context.read<CafeSearchBloc>().add(
                        CafeSearchOnPriceEndChanged(
                            (_formatterPriceEnd.getUnformattedValue() as int)
                                .toDouble())),
                    errorText: state.searchModel.priceTo != null &&
                            state.searchModel.priceFrom != null &&
                            state.searchModel.priceTo! <
                                state.searchModel.priceFrom!
                        ? 'Harga maksimum harus lebih besar dari harga minimum'
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _Location extends StatefulWidget {
  const _Location();

  @override
  State<_Location> createState() => __LocationState();
}

class __LocationState extends State<_Location> {
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
    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          'Cafe terdekat dari titik lokasi',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                BlocConsumer<CafeSearchBloc, CafeSearchState>(
                  listenWhen: (previous, current) =>
                      previous.searchModel != current.searchModel,
                  listener: (context, state) {
                    if (state.searchModel.isLocationValid()) {
                      var coordinate = LatLng(state.searchModel.latitude!,
                          state.searchModel.longitude!);
                      _mapController.move(coordinate,
                          _mapController.zoom > 15 ? _mapController.zoom : 15);
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.searchModel != current.searchModel,
                  builder: (context, state) {
                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: const LatLng(-6.1769896, 106.8229453),
                        zoom: 5.0,
                        minZoom: 3.0,
                        maxZoom: 18.0,
                        onTap: (TapPosition position, LatLng latlng) {
                          BlocProvider.of<CafeSearchBloc>(context)
                              .add(CafeSearchOnLocationChanged(latlng));
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
                            if (state.searchModel.isLocationValid())
                              Marker(
                                point: state.searchModel.isLocationValid()
                                    ? LatLng(state.searchModel.latitude!,
                                        state.searchModel.longitude!)
                                    : const LatLng(-6.1769896, 106.8229453),
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
                      BlocProvider.of<CafeSearchBloc>(context)
                          .add(const CafeSearchOnGPSTapped());
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
      ],
    );
  }
}
