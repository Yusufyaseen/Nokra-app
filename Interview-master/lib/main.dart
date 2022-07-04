// ignore_for_file: unnecessary_null_comparison

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:road_damage/amplifyconfiguration.dart';
import 'package:road_damage/language/localiztion.dart';
import 'package:road_damage/logic/bindings/auth_biniding.dart';
import 'package:road_damage/logic/controller/theme_controller.dart';
import 'package:road_damage/routes/routes.dart';
import 'package:road_damage/utilis/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  await configureAmplify();
  runApp(const MyApp());
}

Future<void> configureAmplify() async {
  final AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
  AmplifyStorageS3 storage = AmplifyStorageS3();
  await Amplify.addPlugins([authPlugin, storage]);
  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    // print( "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.0
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialBinding: ControllersBindings(),
      title: 'Nokra',
      theme: ThemesApp.light,
      debugShowCheckedModeBanner: false,
      locale: Locale(GetStorage().read<String>('lang') ??
          Get.deviceLocale.toString().substring(0, 2)),
      translations: LocaliztionApp(),
      // fallbackLocale: Get.deviceLocale,
      darkTheme: ThemesApp.dark,
      themeMode: ThemeController().themeDataGet,
      initialBinding: AuthBinding(),
      initialRoute: GetStorage().read<bool>('signIN') == true &&
              GetStorage().read<bool>('page') == true
          ? AppRoutes.maps
          : GetStorage().read("signIN") == false &&
                  GetStorage().read<bool>('page') == true
              ? Routes.loginScreen
              : AppRoutes.pageView,
      getPages: AppRoutes.routes,
    );
  }
}
