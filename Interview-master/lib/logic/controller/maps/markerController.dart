// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable

import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_damage/model/MarkerModel.dart';
import 'package:vector_math/vector_math.dart';
import 'package:location/location.dart' as loc;
import '../../../utilis/constants.dart';
import '../../../view/widgets/Maps/snackBarWidget.dart';
import 'textFieldController.dart';

import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:csv/csv.dart';

import 'package:path_provider/path_provider.dart';

class MarkerController extends GetxController {
  late double startLatitude = 0.0;
  late double startLongitude = 0.0;
  int count = 1;
  double currentLat = 0.0;
  double currentLong = 0.0;
  late GoogleMapController mapController;
  TextFieldController tc = Get.put(TextFieldController());
  late Marker trackMarker;
  late Marker startMarker;
  late Marker destinationMarker;
  late List<dynamic> ld;
  late List<dynamic> cp = [];
  bool search = true;
  bool firstTime = true;
  bool firstTrack = true;
  bool mapCreated = false;
  Set<Marker> markers = {};
  Set<Polyline> polyLineSet = {};
  late final loc.LocationData position;
  int road1_potholes = 0;
  int road2_potholes = 0;
  late BitmapDescriptor startFlag;
  late BitmapDescriptor destinationFlag;
  late BitmapDescriptor customMarker;
  late BitmapDescriptor roughMarker;
  bool isLoaded = false;

  // RxInt road2_potholes = 0.obs;
  void isMapCreated() {
    mapCreated = true;
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    position = await determinePosition();
    startLatitude = position.latitude!;
    startLongitude = position.longitude!;
    // await initAll();
  }

  Future<void> initAll() async {
    count = 0;
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/ball4.png");
    roughMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/rough.png");
    startFlag = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/start.png");
    destinationFlag = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/destination.png");
    // customMarker = await BitmapDescriptor.defaultMarker;
    await downloadFile();
    update();
  }

  Future<loc.LocationData> determinePosition() async {
    loc.Location location = loc.Location();
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = true;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error("error");
      }
    }
    _permissionGranted = loc.PermissionStatus.granted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return Future.error("error");
      }
    }

    location.changeSettings(
        accuracy: loc.LocationAccuracy.high, interval: 1000, distanceFilter: 5);
    location.enableBackgroundMode(enable: true);
    return await location.getLocation();
  }

  convertMapTheme() {
    if (Get.isDarkMode) {
      mapController.setMapStyle(Constants.Light_Style);
    } else {
      mapController.setMapStyle(Constants.DARK_STYLE);
    }
    update();
  }

  convertMap() {
    if (Get.isDarkMode) {
      mapController.setMapStyle(Constants.DARK_STYLE);
    } else {
      mapController.setMapStyle(Constants.Light_Style);
    }
    update();
  }

  Future<void> downloadFile() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/AnomalyData.csv';
    final file = File(filepath);

    try {
      await Amplify.Storage.downloadFile(
        key: 'AnomalyData.csv',
        local: file,
      );

      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      Markers.ld = fields;
      updateMarkerData();
      // ignore: empty_catches
    } on StorageException {}
  }

  void clearSets() {
    polyLineSet.clear();
    deletePreviousMarkers();
  }

  void updateMarkerData() {
    Markers.getMarkers(customMarker, roughMarker);
    ld = Markers.ld;
    cp = [...ld];
    markers = Set.of(Markers.markers.values);
    isLoaded = true;
    update();
  }

  void assignCurrentPotholes() {
    cp = [...ld];
  }

  void changeSearch() {
    search = !search;
    update();
  }

  void plusCount() {
    count++;
  }

  int getCount() {
    return count;
  }

  void updateFirstTrack() {
    firstTrack = false;
    update();
  }

  void updateFirstTime() {
    firstTime = false;
    update();
  }

  void updatePolyline(Polyline poly) {
    polyLineSet.add(poly);
    update();
  }

  void addStartAndDestinationMarkers() {
    markers.add(startMarker);
    markers.add(destinationMarker);
    update();
  }

  void updateTrackMarker(Marker track) {
    trackMarker = track;
  }

  void addTrackMarker(Marker track) {
    updateTrackMarker(track);
    markers.add(trackMarker);
    update();
  }

  void removeTrackMarker() {
    markers.remove(trackMarker);
    update();
  }

  double latLngDifference(double latitude1, double longitude1, double latitude2,
      double longitude2) {
    var R = 6373.0;
    var lat1 = radians(latitude1);
    var lon1 = radians(longitude1);
    var lat2 = radians(latitude2);
    var lon2 = radians(longitude2);

    var dlon = lon2 - lon1;
    var dlat = lat2 - lat1;

    var a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = R * c;

    return distance;
  }

  bool theEnd(double latitude1, double longitude1) {
    if (latLngDifference(latitude1, longitude1, tc.destinationLatitude.value,
                tc.destinationLongitude.value) *
            1000 <
        50) {
      return true;
    }
    return false;
  }

  void playing() {
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("assets/audios/pothole.mp3"), autoStart: true);
  }

  void playing2() {
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("assets/audios/1234.wav"), autoStart: true);
  }

  void thereIsAPothole() {
    playing();
    SnackBars.potholeSnackBar2();
  }

  void repeatedPothole() {
    playing2();
    SnackBars.repeatedSnackBar();
  }

  // int potholeDetection(double lat, double lng, int meters) {
  //   int k = 0;
  //   // int repeated = meters;
  //   bool alert = false;
  //   var distance = 0.0;
  //   int n = 0;
  //   for (int i = 1; i < cp.length; i++) {
  //     distance = latLngDifference(lat, lng, cp[i][0], cp[i][1]);
  //     if ((distance * 1000) >= 0 && (distance * 1000) <= meters) {
  //       k++;
  //       cp.removeAt(i);
  //       i -= 1;
  //       if (!alert) {
  //         thereIsAPothole();
  //         alert = true;
  //       }
  //     }
  //   }
  //   return k;
  // }

  void potholeDetection(double lat, double lng, int meters)  {
    int k = 0;
    var distance = 0.0;
    bool alert = false; 
    int n = 0;
    for (int i = 1; i < cp.length; i++) {
      distance = latLngDifference(lat, lng, cp[i][0], cp[i][1]);
      if ((distance * 1000) <= meters) {
        if (cp[i][3] == 1) {
          n++;
          if(!alert){
          	repeatedPothole();
          	alert = true;
          }
          
        } else {
          k++;
        }
        cp.removeAt(i);
        i -= 1;
      }
    }
    // for (int i = 1; i < cp.length; i++) {
    //   distance = latLngDifference(lat, lng, cp[i][0], cp[i][1]);
    //   if ((distance * 1000) >= 0 && (distance * 1000) <= meters) { //
    //     k++;
    //     cp.removeAt(i);
    //     i -= 1;
    //   } else if ((distance * 1000) >= 0 &&
    //       (distance * 1000) <= meters + 45) {
    //     if(!alert){
    //       repeatedPothole();
    //       alert = true;
    //     }
    //     n++;
    //     cp.removeAt(i);
    //     i -= 1;
    //   }
    // }
    if (k > 0 && n == 0) {
      thereIsAPothole();
    }
  }

  // void repeatedPotholeDetection(double lat, double lng, int meters) {
  //   bool loop = true;
  //   bool repeatedAlert = false;
  //   var distance = 0.0;
  //   int n = 0;
  //   while (loop) {
  //     n = 0;
  //     for (int i = 1; i < cp.length; i++) {
  //       distance = latLngDifference(lat, lng, cp[i][0], cp[i][1]);
  //       if ((distance * 1000) > meters && (distance * 1000) <= meters + 20) {
  //         cp.removeAt(i);
  //         i -= 1;
  //         n++;
  //         if (!repeatedAlert) {
  //           repeatedPothole();
  //           repeatedAlert = true;
  //         }
  //       }
  //     }
  //     meters += 15;
  //     if (n == 0) loop = false;
  //   }
  // }

  List<dynamic> numberOfPothole(List<PointLatLng> points, int num) {
    List<dynamic> pots = [...ld];
    var distance = 0.0;
    int cnt = 0;
    double bumps = 0.0;
    for (int i = 1; i < pots.length; i++) {
      if (pots.isEmpty) break;
      for (int j = 0; j < points.length; j++) {
        distance = latLngDifference(
            pots[i][0], pots[i][1], points[j].latitude, points[j].longitude);

        if ((distance * 1000) <= 20) {
          cnt++;
          if(pots[i][3] == 1){
            debugPrint("-");
            debugPrint(pots[i][2].runtimeType.toString());
            bumps += pots[i][2] ;
           }
          pots.removeAt(i);
          if (i <= 1) {
            i = 1;
          } else {
            i -= 1;
          }
        }
      }
    }
    var all = (num == 1) ? (((bumps / (double.parse(tc.distance1.value.split(" ")[0])*1000)) *100).toInt()).toString(): (((bumps / (double.parse(tc.distance2.value.split(" ")[0])*1000)) *100).toInt()).toString();
    List<dynamic> res = [cnt, all];
    return res;
  }

  void addMarkers() {
    String startCoordinatesString =
        '(${tc.startLatitude.value}, ${tc.startLongitude.value})';
    String destinationCoordinatesString =
        '(${tc.destinationLatitude.value},${tc.destinationLongitude.value})';

    startMarker = Marker(
      markerId: MarkerId(startCoordinatesString),
      position: LatLng(tc.startLatitude.value, tc.startLongitude.value),
      infoWindow: InfoWindow(
        title: 'Start $startCoordinatesString',
        snippet: tc.startLocation.value,
      ),
      icon: startFlag,
    );

    destinationMarker = Marker(
      markerId: MarkerId(destinationCoordinatesString),
      position:
          LatLng(tc.destinationLatitude.value, tc.destinationLongitude.value),
      infoWindow: InfoWindow(
        title: 'Destination $destinationCoordinatesString',
        snippet: tc.destinationLocation.value,
      ),
      icon: destinationFlag,
    );
    // mc.updateMarkers(startMarker, destinationMarker);
    addStartAndDestinationMarkers();
  }

  deletePreviousMarkers() {
    markers.remove(startMarker);
    markers.remove(destinationMarker);
    update();
  }
}
