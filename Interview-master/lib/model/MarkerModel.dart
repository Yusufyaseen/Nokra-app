// ignore_for_file: file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
class Markers {
  List<Marker> myMarkers = [];
  static Map<MarkerId, Marker> markers = {};
  static List ld = [];

  static getMarkers(BitmapDescriptor customMarker, BitmapDescriptor roughMarker) {
    debugPrint(ld.length.toString());

    int j = 0;
    for (int i = 1; i < ld.length; i++) {
      debugPrint(ld[i][3].toString());
      j+=1;
      debugPrint(j.toString());
        markers[MarkerId(i.toString())] = Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(ld[i][0], ld[i][1]),
          infoWindow: InfoWindow(
            title: "Latitude(${ld[i][0]}) & Longitude(${ld[i][1]})",
          ),
          icon: ld[i][3] == 1 ? roughMarker : customMarker,
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        );
    }
  }
}
