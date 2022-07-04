// ignore_for_file: unnecessary_const
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/accelometerData_controller.dart';
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/userData_controller.dart';
import 'package:road_damage/utilis/excel_sheet.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/home/drawer.dart';
import 'package:road_damage/view/widgets/text_utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Appdata extends StatefulWidget {
  const Appdata({Key? key}) : super(key: key);

  @override
  State<Appdata> createState() => _AppdataState();
}

class _AppdataState extends State<Appdata> {
  //controller object from AuthController
  final controller = Get.find<AuthController>();
  //accelometerController object from Accelometer_controller
  final accelometerController = Get.find<Accelometer_controller>();
  final userController = Get.put(User_controller());

  //variable contains data od user
  String userName = '.........';
  String len = '00000000';

  @override
  Widget build(BuildContext context) {
    //excel object
    Excel excel = Excel();
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      drawerEnableOpenDragGesture: false,
      //drawer
      drawer: Drawer(child: MainDrawer()),
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            TextUtils(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              text: "N".tr,
              color: Get.isDarkMode ? darkColor2 : mainColor,
              underLine: TextDecoration.none,
            ),
            const SizedBox(
              width: 7,
            ),
            CircleAvatar(
              radius: 17,
              backgroundColor: Get.isDarkMode ? darkColor2 : Colors.teal,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: ImageIcon(
                  const AssetImage("assets/icons/pothole.png"),
                  size: double.infinity,
                  color: Get.isDarkMode ? darkColor2 : mainColor,
                ),
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            TextUtils(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              text: "KRA".tr,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
              underLine: TextDecoration.none,
            ),
          ],
        ),
        // actions: [],
        leading: GetBuilder<User_controller>(builder: (_) {
          return Builder(
              builder: (context) => // Ensure Scaffold is in context
                  ElevatedButton(
                    onPressed: Scaffold.of(context).openDrawer,
                    child: userController.first
                        ? CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(userController.img),
                          )
                        : CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                FileImage(userController.authUserPhoto),
                          ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Get.isDarkMode ? darkGreyClr : Colors.white),
                      elevation: MaterialStateProperty.all(0),
                    ),
                  ));
        }),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(child: GetBuilder<Accelometer_controller>(builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(len),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Get.isDarkMode ? darkColor2 : mainColor)),
                  onPressed: excel.open,
                  label: Text("Open Excel Files".tr),
                  icon: Icon(
                    Icons.folder_open_outlined,
                    color: Get.isDarkMode ? darkColor2 : mainColor,
                  ),
                ),
                // first ? Image.network(img) : Image.file(authUserPhoto),
                accelometerVariable(),
                _locationdata(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: speedMeter(),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Get.isDarkMode ? darkColor2 : mainColor)),
                        child: Icon(
                          accelometerController.selected
                              ? Icons.stop_circle
                              : Icons.not_started,
                        ),
                        onPressed: accelometerController.isSelected))
              ],
            );
          })),
        ),
      ),
    );
  }

// Speed Meter widget
  Widget speedMeter() {
    return SizedBox(
      width: 250, height: 250, //height and width of guage
      child: SfRadialGauge(
          title: const GaugeTitle(text: "Speed Meter"), //title for guage
          enableLoadingAnimation:
              true, //show meter pointer movement while loading
          animationDuration: 4500, //pointer movement speed
          axes: <RadialAxis>[
            //Radial Guage Axis, use other Guage type here
            RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
              //Guage Ranges
              GaugeRange(
                  startValue: 0,
                  endValue: 50, //start and end point of range
                  color: Colors.green,
                  startWidth: 10,
                  endWidth: 10),
              GaugeRange(
                  startValue: 50,
                  endValue: 100,
                  color: Colors.orange,
                  startWidth: 10,
                  endWidth: 10),
              GaugeRange(
                  startValue: 100,
                  endValue: 150,
                  color: Colors.red,
                  startWidth: 10,
                  endWidth: 10)
              //add more Guage Range here
            ], pointers: <GaugePointer>[
              NeedlePointer(
                value: accelometerController.speed_!.toDouble(),
              ) //add needlePointer here
              //set value of pointer to 80, it will point to '80' in guage
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(accelometerController.speed_!.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  angle: 90,
                  positionFactor: 0.5),
              //add more annotations 'texts inside guage' here
            ])
          ]),
    );
  }

// accelometerVariable
  Widget accelometerVariable() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'X',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Y',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Z',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(accelometerController.x!.toStringAsFixed(2))),
            DataCell(Text(accelometerController.y!.toStringAsFixed(2))),
            DataCell(Text(accelometerController.z!.toStringAsFixed(2))),
          ],
        ),
      ],
    );
  }

  Widget _locationdata() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Longitude',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Latitude',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text(accelometerController.lon!.toStringAsFixed(6))),
            DataCell(Text(accelometerController.lat_!.toStringAsFixed(6))),
          ],
        ),
      ],
    );
  }

  // Future<void> getDownloadUrl(String key) async {
  //   final documentsDir = await getApplicationDocumentsDirectory();
  //   final filepath = documentsDir.path + '/photo';
  //   final file = File(filepath);

  //   try {
  //     await Amplify.Storage.downloadFile(
  //       key: key,
  //       local: file,
  //     );
  //     setState(() {
  //       authUserPhoto = file;
  //       first = false;
  //     });
  //   } on StorageException {
  //     // Get.snackbar('err', '$e');
  //   }
  // }
}
