import 'package:get/instance_manager.dart';
import 'package:road_damage/logic/controller/accelometerData_controller.dart';
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/maps/mapController.dart';
import 'package:road_damage/logic/controller/maps/markerController.dart';
import 'package:road_damage/logic/controller/network_controller.dart';
import 'package:road_damage/logic/controller/Language_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(Accelometer_controller());
    Get.put(MarkerController());
    Get.put(MapController());
    Get.put(LanguageController());
    Get.put(GetXNetworkManager());
  }
}
