// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:road_damage/utilis/helper_methods.dart';
import 'package:location/location.dart' as loc;

class LatLngController extends GetxController {
  late final loc.LocationData position;
  RxBool hideAll = false.obs;
  RxDouble latitude = 0.1.obs;
  RxDouble longitude = 0.1.obs;
  RxBool startCounting = false.obs;
  RxBool hideForDialog = false.obs;
  RxString currentStreet = 'Loading...'.obs;

  Future<String> getCurrentStartLocation(bool state) async {
    String location = await HelperMethods.getCurrentLocation(
        latitude.value, longitude.value, state);
    return location;
  }
}
