import 'package:get/route_manager.dart';
import 'package:road_damage/language/ar.dart';
import 'package:road_damage/language/en.dart';
import 'package:road_damage/utilis/my_string.dart';

class LocaliztionApp extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        ene: en,
        ara: ar,
        // frf: fr,
      };
}
