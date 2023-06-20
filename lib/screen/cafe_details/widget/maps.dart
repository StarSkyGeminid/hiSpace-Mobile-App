import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:latlong2/latlong.dart';

class Maps extends StatelessWidget {
  const Maps({super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing / 2),
          child: Text('Lokasi', style: Theme.of(context).textTheme.titleMedium),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: LatLng(latitude, longitude),
                    zoom: 12.0,
                    minZoom: 3.0,
                    maxZoom: 18.0,
                  ),
                  nonRotatedChildren: [
                    TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        backgroundColor: Colors.black54),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(latitude, longitude),
                          width: 80,
                          height: 80,
                          rotate: false,
                          builder: (context) => Icon(Icons.location_on,
                              color: ColorPallete.light.darkRed),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
