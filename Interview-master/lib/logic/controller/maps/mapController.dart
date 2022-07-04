// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:get/get.dart';
import 'package:road_damage/utilis/excel_sheet.dart';
import 'package:road_damage/view/widgets/Maps/snackBarWidget.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../Language_controller.dart';
import 'latLngController.dart';
import 'markerController.dart';
import 'textFieldController.dart';
import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:device_info/device_info.dart';

import 'package:path_provider/path_provider.dart';

class MapController extends GetxController {
  final c = Get.put(LatLngController());
  final languageController = Get.put(LanguageController());
  final tc = Get.find<TextFieldController>();
  final mc = Get.find<MarkerController>();
  loc.Location location = loc.Location();
  late StreamSubscription locationTracker;
  Excel excel = Excel();
  late Marker track;
  String found = "not found";
  var x_axisValues = [];
  var y_axisValues = [];
  var z_axisValues = [];
  var long = [];
  var lat = [];
  late int meters;
  late bool end;
  bool firstTimePassed = false;
  var speed = [];
  int nmb = 0;
  final accelometerStreem = accelerometerEvents.listen((_) => _);
  bool firstUpload = true;
  bool selected = false;
  void startRecord() {
    selected = true;
    update();
  }

  void stopRecord() async {
    selected = false;
    await saveSensorRecording();
    update();
  }

  void getCurrentLocation(BuildContext context) async {
    // Uint8List image = await getImage(context);
    location.changeSettings(
        accuracy: loc.LocationAccuracy.high, interval: 1000);
    location.enableBackgroundMode(enable: true);
    locationTracker = location.onLocationChanged.listen(
      (loc.LocationData currentLocation) async {
        c.latitude.value = currentLocation.latitude!;
        c.longitude.value = currentLocation.longitude!;

        if (mc.getCount() == 1) {
          mc.currentLat = c.latitude.value;
          mc.currentLong = c.longitude.value;
        }

        if (!firstTimePassed) {
          if (currentLocation.speed! * 3.6 >= 7) {
            mc.currentLat = c.latitude.value;
            mc.currentLong = c.longitude.value;
            mc.potholeDetection(c.latitude.value, c.longitude.value, 75);

            firstTimePassed = true;
          }
        }

        //  0  11 11 11  0
        if (currentLocation.speed! * 3.6 >= 7) {
          // meters = 75;
          if ((mc.latLngDifference(c.latitude.value, c.longitude.value,
                      mc.currentLat, mc.currentLong)) *
                  1000 >
              10) {
            mc.currentLat = c.latitude.value;
            mc.currentLong = c.longitude.value;
            mc.potholeDetection(c.latitude.value, c.longitude.value, 70);

            update();
          }
        }

        end = mc.theEnd(c.latitude.value, c.longitude.value);

        if (mc.getCount() % 1000 == 0 && mc.getCount() > 1000) {
          mc.assignCurrentPotholes();
        }

        c.currentStreet.value = await c.getCurrentStartLocation(false);
        if (!end && currentLocation.speed! * 3.6 > 5 && selected) {
          firstUpload = false;
          accelometerStreem.onData((AccelerometerEvent event) async {
            x_axisValues.add(event.x);
            y_axisValues.add(event.y);
            z_axisValues.add(event.z);
            long.add(currentLocation.longitude);
            lat.add(currentLocation.latitude);
            speed.add(currentLocation.speed! * 3.6);
          });
        } else if (end && !firstUpload) {
          firstUpload = true;
          stopRecord();
          mc.clearSets();
          c.hideForDialog.value = false;
        }

        mc.plusCount();

        if (tc.chosenRoad.length >= 10) {
          for (int i = 1; i <= 10; i++) {
            if (mc.latLngDifference(
                        (tc.chosenRoad[((tc.chosenRoad.length * i) ~/ 10) - 1]
                                as PointLatLng)
                            .latitude,
                        (tc.chosenRoad[((tc.chosenRoad.length * i) ~/ 10) - 1]
                                as PointLatLng)
                            .longitude,
                        c.latitude.value,
                        c.longitude.value) *
                    1000 <=
                15) {
              double dis =
                  tc.distanceVar.value - (i / 10) * tc.distanceVar.value;
              tc.distance.value = languageController.isLang
                  ? "${dis.toStringAsFixed(1)} كم"
                  : "${dis.toStringAsFixed(1)} km";

              double dur =
                  tc.durationVar.value - (i / 10) * tc.durationVar.value;
              if ((dur / 60) >= 1) {
                tc.duration.value = languageController.isLang
                    ? "${(dur.toInt() / 60).toStringAsFixed(1)} ساعة و ${(dur.toInt() % 60).toStringAsFixed(1)} دقيقة"
                    : "${(dur.toInt() / 60).toStringAsFixed(1)} hours and ${(dur.toInt() % 60).toStringAsFixed(1)} mins";
              } else {
                tc.duration.value = languageController.isLang
                    ? "${(dur.toInt() % 60).toStringAsFixed(1)} دقيقة"
                    : "${(dur.toInt() % 60).toStringAsFixed(1)} mins";
              }
              if (i == 10) {
                tc.chosenRoad.clear();
              }
            }
          }
        } else if (tc.chosenRoad.length > 1 && tc.chosenRoad.length < 10) {
          for (int i = 1; i <= 3; i++) {
            if (mc.latLngDifference(
                        (tc.chosenRoad[((tc.chosenRoad.length * i) ~/ 3) - 1]
                                as PointLatLng)
                            .latitude,
                        (tc.chosenRoad[((tc.chosenRoad.length * i) ~/ 3) - 1]
                                as PointLatLng)
                            .longitude,
                        c.latitude.value,
                        c.longitude.value) *
                    1000 <=
                15) {
              double dis =
                  tc.distanceVar.value - (i / 3) * tc.distanceVar.value;
              tc.distance.value = languageController.isLang
                  ? "${dis.toStringAsFixed(1)} كم"
                  : "${dis.toStringAsFixed(1)} km";

              double dur =
                  tc.durationVar.value - (i / 3) * tc.durationVar.value;
              if ((dur / 60) >= 1) {
                tc.duration.value = languageController.isLang
                    ? "${(dur.toInt() / 60).toStringAsFixed(1)} ساعة و ${(dur.toInt() % 60).toStringAsFixed(1)} دقيقة"
                    : "${(dur.toInt() / 60).toStringAsFixed(1)} hours and ${(dur.toInt() % 60).toStringAsFixed(1)} mins";
              } else {
                tc.duration.value = languageController.isLang
                    ? "${(dur.toInt() % 60).toStringAsFixed(1)} دقيقة"
                    : "${(dur.toInt() % 60).toStringAsFixed(1)} mins";
              }
              if (i == 3) {
                tc.chosenRoad.clear();
              }
            }
          }
        }

        if (mc.mapCreated) {
          mc.mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  // Will be fetching in the next step
                  c.latitude.value.toDouble(),
                  c.longitude.value.toDouble(),
                ),
                zoom: 18.0,
              ),
            ),
          );
        }
        update();
      },
    );
  }

  //save accelerometer Data to excel
  Future<void> saveSensorRecording() async {
    final path = (await getApplicationSupportDirectory()).path;
    final filename = "$path/data.xlsx";
    await excel.addToExcel(
        x_axisValues, y_axisValues, z_axisValues, long, lat, speed);
    _uploadFile(filename);
    x_axisValues.clear();
    y_axisValues.clear();
    z_axisValues.clear();
    long.clear();
    lat.clear();
    speed.clear();
  }

  Future<void> _uploadFile(String filePath) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    try {
      File local = File(filePath);
      final key = DateTime.now().toString() + ' ' + androidInfo.model;
      Map<String, String> metadata = <String, String>{};
      metadata['name'] = 'filename';
      metadata['desc'] = 'A test file';

      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest,
          metadata: metadata,
          contentType: 'text/csv');
      await Amplify.Storage.uploadFile(
          key: key,
          local: local,
          options: options,
          onProgress: (progress) {
            // print("PROGRESS: " + progress.getFractionCompleted().toString());
          });
    } catch (e) {
      // print(e.toString());
      // Get.snackbar("UploadFile Err:", e.toString());
    }
  }

  void playing() {
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("assets/audios/pothole.mp3"), autoStart: true);
  }

  void thereIsAPothole() {
    playing();
    SnackBars.potholeSnackBar2();
  }

  void playing2() {
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("assets/audios/1234.wav"), autoStart: true);
  }

  void repeatedPothole() {
    playing2();
    SnackBars.repeatedSnackBar();
  }
}
