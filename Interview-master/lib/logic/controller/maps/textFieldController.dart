// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:road_damage/utilis/constants.dart';
import 'package:road_damage/view/widgets/Maps/dialogWidget.dart';
import 'latLngController.dart';

class TextFieldController extends GetxController {
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final c = Get.put(LatLngController());

  RxString startWord = ''.obs;
  RxString searchText = ''.obs;
  RxString startLocation = "".obs;
  RxString destinationLocation = "".obs;
  RxString distance1 = "".obs;
  RxString duration1 = "".obs;
  RxString distance2 = "".obs;
  RxString duration2 = "".obs;
  RxString distance = "".obs;
  RxString duration = "".obs;
  RxDouble distanceVar = 0.0.obs;
  RxDouble durationVar = 0.0.obs;
  RxList chosenRoad = [].obs;
  RxDouble startLatitude = 0.0.obs;
  RxDouble startLongitude = 0.0.obs;
  RxDouble destinationLatitude = 0.0.obs;
  RxDouble destinationLongitude = 0.0.obs;
  RxInt road1_potholes = 0.obs;
  RxString road1_bumps = "0".obs;
  RxInt road3_potholes = 0.obs;
  RxString road3_bumps = "0".obs;
  RxInt road_potholes = 0.obs;
  RxBool darkMode = false.obs;
  RxBool search = true.obs;
  RxInt road = 1.obs;
  RxBool isChoosingCurrent = true.obs;

  void changeTextEditingControllersToArabic() {
    startAddressController.text = "موقعك الحالي";
    destinationAddressController.text = "موقع وجهتك";
    startLocation.value = '';
    destinationLocation.value = '';
    update();
  }

  void changeTextEditingControllersToEnglish() {
    startAddressController.text = "Your Current Location";
    destinationAddressController.text = "Your Destination Location";
    startLocation.value = '';
    destinationLocation.value = '';
    update();
  }

  updateStartField(String start) {
    startLocation.value = start;
  }

  updateSearch() {
    search.value = !search.value;
  }

  updateDestinationField(String destination) {
    destinationLocation.value = destination;
  }

  Future<List> getRoutesBetweenLocations() async {
    distance2.value = "";
    duration2.value = "";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startLatitude.value},${startLongitude.value}&destination=${destinationLatitude.value},${destinationLongitude.value}&mode=driving&alternatives=true&key=${Constants.API_KEY}";

    var response = await http.get(
      Uri.parse(url),
    );
    var allResults = [];
    var json = convert.jsonDecode(response.body);
    if ((json['routes'] as List).length > 1) {
      var result1 = {
        'len': (json['routes'] as List).length,
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'distance': json['routes'][0]['legs'][0]['distance']['text'],
        'duration': json['routes'][0]['legs'][0]['duration']['text'],
        'polyline': json['routes'][0]['overview_polyline']['points'],
        'polyline_decoded': PolylinePoints()
            .decodePolyline(json['routes'][0]['overview_polyline']['points']),
      };

      distance1.value = json['routes'][0]['legs'][0]['distance']['text'];
      duration1.value = json['routes'][0]['legs'][0]['duration']['text'];

      int i = 1;
      var result2 = {
        'len': (json['routes'] as List).length,
        'start_location': json['routes'][i]['legs'][0]['start_location'],
        'end_location': json['routes'][i]['legs'][0]['end_location'],
        'distance': json['routes'][i]['legs'][0]['distance']['text'],
        'duration': json['routes'][i]['legs'][0]['duration']['text'],
        'polyline': json['routes'][i]['overview_polyline']['points'],
        'polyline_decoded': PolylinePoints()
            .decodePolyline(json['routes'][i]['overview_polyline']['points']),
      };

      distance2.value = json['routes'][i]['legs'][0]['distance']['text'];
      duration2.value = json['routes'][i]['legs'][0]['duration']['text'];

      allResults = [result1, result2];
    } else if ((json['routes'] as List).length == 1) {
      var result1 = {
        'len': (json['routes'] as List).length,
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'distance': json['routes'][0]['legs'][0]['distance']['text'],
        'duration': json['routes'][0]['legs'][0]['duration']['text'],
        'polyline': json['routes'][0]['overview_polyline']['points'],
        'polyline_decoded': PolylinePoints()
            .decodePolyline(json['routes'][0]['overview_polyline']['points']),
      };

      distance1.value = json['routes'][0]['legs'][0]['distance']['text'];
      duration1.value = json['routes'][0]['legs'][0]['duration']['text'];
      allResults = [result1];
    }
    return allResults;
  }

  Future<int> dataOfPotholes(BuildContext context) async {
    road.value = 0;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget();
      },
    );
    if (road.value == 0) {
      c.hideForDialog.value = false;
    }
    return road.value;
  }
}
