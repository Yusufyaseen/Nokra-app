import 'package:geocoding/geocoding.dart';

class HelperMethods {
  static Future<String> getCurrentLocation(
      double lat, double lng, bool state) async {
    List<Placemark> place = await placemarkFromCoordinates(lat, lng);
    String location =
        "${place[0].name}, ${place[0].street}, ${place[0].subAdministrativeArea}, ${place[0].administrativeArea},${place[0].country}";
    return state ? location : place[0].street.toString();
  }
}
