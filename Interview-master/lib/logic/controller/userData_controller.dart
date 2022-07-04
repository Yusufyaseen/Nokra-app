// ignore_for_file: file_names, camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:road_damage/logic/controller/maps/markerController.dart';

class User_controller extends GetxController {
  MarkerController mc = Get.put(MarkerController());
  late File authUserPhoto;
  var first = true;
  var identifier = {};
  var ld = [];
  var ldcontents = '';
  var CognitoUserAttributeKey;
  bool isUserDataLoad = true;
  String img =
      'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300';

  @override
  void onInit() {
    super.onInit();
    CognitoUserAttributeKey = Amplify.Auth.fetchAuthSession();
    // ignore: avoid_function_literals_in_foreach_calls
    Amplify.Auth.fetchUserAttributes().then((value) => value.forEach((element) {
          identifier[element.userAttributeKey] = element.value;
          update();
          getDownloadUrl(identifier['sub']);
          debugPrint(
              'key: ${element.userAttributeKey}; value: ${element.value}');
        }));
  }

  //update user photo
  void uploadImage(String key) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result == null) {
      print('No file selected');
      return;
    }
    // Upload file with its filename as the key
    final platformFile = result.files.single;
    final path = platformFile.path!;
    // final key = platformFile.name;
    final file = File(path);
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: file,
          key: key,
          options: UploadFileOptions(accessLevel: StorageAccessLevel.private),
          onProgress: (progress) {
            print("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      print('Successfully uploaded file: ${result.key}');
      await Amplify.Storage.downloadFile(
        key: key,
        local: file,
        options: DownloadFileOptions(accessLevel: StorageAccessLevel.private)
      );
      authUserPhoto = file;
      first = false;
      update();
    } on StorageException catch (e) {
      Get.snackbar('error', e.message);
      // print('Error uploading file: $e');
    }
  }

// download user photo
  Future<void> getDownloadUrl(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/photo';
    final file = File(filepath);
    try {
      await Amplify.Storage.downloadFile(
          key: key,
          local: file,
          options:
              DownloadFileOptions(accessLevel: StorageAccessLevel.private));
      authUserPhoto = file;
      first = false;
      isUserDataLoad = false;
      update();
    } on StorageException {
      // Get.snackbar('err', '$e');
    }
  }
}
