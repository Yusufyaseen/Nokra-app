// ignore_for_file: file_names

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:road_damage/utilis/constants.dart';

class PlaceApiController extends GetxController {
  RxList places = [].obs;
  recommendedPlaces(String place) async {
    if (place.length > 1) {
      String autoComplete =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$place&key=${Constants.API_KEY}&sessiontoken=${Random().nextInt(9000000)}&components=country:eg";
      var res = await http.get(Uri.parse(autoComplete));
      if (res.statusCode == 200) {
        String data = res.body;
        var decodedData = jsonDecode(data);

        places.value = decodedData["predictions"];
      }
      debugPrint(res.statusCode.toString());
    }
  }
}
