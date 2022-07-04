import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/maps/latLngController.dart';
import 'package:road_damage/logic/controller/maps/textFieldController.dart';
import 'package:road_damage/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LatLngController c = Get.put(LatLngController());
  TextFieldController tc = Get.put(TextFieldController());

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async => Get.offNamed(Routes.maps));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/map.jpg"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
