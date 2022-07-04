// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:device_info/device_info.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:road_damage/utilis/excel_sheet.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class Accelometer_controller extends GetxController {
  Excel excel = Excel();

  var identifier = {};
  String userName = '.......';
  String len = '00000000';
  final box = GetStorage();
  double? x = 0.0, y = 0.0, z = 0.0;
  double? lon = 0.0, lat_ = 0.0, speed_ = 0.0;
  var x_axisValues = [];
  var y_axisValues = [];
  var z_axisValues = [];
  var long = [];
  var lat = [];
  var speed = [];
  var timestamp = [];
  bool selected = false;
  final accelometerStreem = accelerometerEvents.listen((_) => _);
  // Location location = new Location();
  final locationStreem = Location().onLocationChanged.listen((_) => _);

  void isSelected() {
    selected = !selected;
    if (selected) {
      accelometerStreem.resume();
      locationStreem.resume();
      startRecord();
    } else {
      accelometerStreem.pause();
      locationStreem.pause();
      saveSensorRecording();
    }
    box.write('sel', selected);
    update();
  }

  Future<void> startRecord() async {
    Location().changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 5);
    Location().enableBackgroundMode(enable: true);

    locationStreem.onData((LocationData e) async {
      accelometerStreem.onData((AccelerometerEvent event) async {
        x_axisValues.add(event.x);
        y_axisValues.add(event.y);
        z_axisValues.add(event.z);
        long.add(e.longitude);
        lat.add(e.latitude);
        speed.add(e.speed! * 3.6);
        timestamp.add(DateTime.now());
        x = event.x;
        y = event.y;
        z = event.z;
        lon = e.longitude;
        lat_ = e.latitude;
        speed_ = e.speed! * 3.6;
        update();
      });
    });
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
    timestamp.clear();
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
      Get.snackbar("UploadFile Err:", e.toString());
    }
  }
}
