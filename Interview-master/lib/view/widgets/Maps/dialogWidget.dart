import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../logic/controller/maps/textFieldController.dart';

import '../../../logic/controller/maps/latLngController.dart';
import 'package:road_damage/logic/controller/Language_controller.dart';
import '../../../utilis/theme.dart';

// ignore: must_be_immutable
class DialogWidget extends StatelessWidget {
  DialogWidget({Key? key}) : super(key: key);

  TextFieldController tc = Get.put(TextFieldController());
  LatLngController c = Get.put(LatLngController());
  final languageController = Get.put(LanguageController());
  Color mainColor = const Color.fromRGBO(3, 146, 120, 0.7);

  @override
  Widget build(BuildContext context) {
    final double width = context.width;
    final double height = context.height;
    List ds1 = tc.distance1.value.split(" ");
    List ds11 = [...ds1];
    ds11.removeLast();
    String dss1 = ds11.join(" ").toString();
    var distance1 = "${ds1[0]} ${ds1[1] == "m" ? "متر" : "كم"}";
    String duration1 = '';
    String duration2 = '';
    double duration1Digit = 0.0;
    double duration2Digit = 0.0;
    List dr1 = tc.duration1.value.split(" ");
    if (dr1.length > 2) {
      dr1.removeAt(1);
      dr1.removeAt(2);
      duration1 = "${dr1[0]} ساعة و ${dr1[1]} دقيقة";
      duration1Digit = (double.parse(dr1[0]) * 60) + double.parse(dr1[1]);
    } else {
      dr1.removeLast();
      String drr1 = dr1.join(" ").toString();
      duration1 = "$drr1 دقيقة";
      duration1Digit = double.parse(drr1);
    }

    List ds2;
    String distance2 = '';
    String dss2 = '';
    if (tc.distance2.value.isNotEmpty && tc.duration2.value.isNotEmpty) {
      ds2 = tc.distance2.value.split(" ");
      List ds22 = [...ds2];
      ds22.removeLast();
      dss2 = ds22.join(" ").toString();
      distance2 = "${ds2[0]} ${ds2[1] == "m" ? "متر" : "كم"}";

      List dr2 = tc.duration2.value.split(" ");
      if (dr2.length > 2) {
        dr2.removeAt(1);
        dr2.removeAt(2);
        duration2 = "${dr2[0]} ساعة و ${dr2[1]} دقيقة";
        duration2Digit = (double.parse(dr2[0]) * 60) + double.parse(dr2[1]);
      } else {
        dr2.removeLast();
        String drr2 = dr2.join(" ").toString();
        duration2 = "$drr2 دقيقة";
        duration2Digit = double.parse(drr2);
      }
    }

    return AlertDialog(
      backgroundColor: Get.isDarkMode ? Colors.black87 : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Icon(
        Icons.taxi_alert_outlined,
        size: context.height * 0.1,
        color: Get.isDarkMode ? darkColor : mainColor,
      ),
      elevation: 50,
      content: SizedBox(
        height: context.height * 0.48,
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Choose Your Suit Road.".tr,
                  style: TextStyle(
                      fontSize: context.width * 0.05,
                      color:
                          Get.isDarkMode ? Colors.grey[500] : Colors.grey[900],
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: height * 0.04,
              ),
              //road 1
              ElevatedButton(
                  onPressed: () {
                    tc.duration.value = !languageController.isLang
                        ? tc.duration1.value
                        : duration1;
                    tc.distance.value = !languageController.isLang
                        ? tc.distance1.value
                        : distance1;
                    tc.durationVar.value = duration1Digit;
                    tc.distanceVar.value = double.parse(dss1);
                    tc.road_potholes.value = tc.road1_potholes.value;
                    tc.road.value = 1;
                    c.hideForDialog.value = true;

                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Get.isDarkMode ? Colors.black26 : Colors.white),
                    elevation: MaterialStateProperty.all(1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: width * 0.12,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(47, 205, 214, 199),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ImageIcon(
                                      const AssetImage(
                                          'assets/images/distance.png'),
                                      size: 12,
                                      color:
                                          Get.isDarkMode ? darkColor : mainColor),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text(
                                  !languageController.isLang
                                      ? tc.distance1.value
                                      : distance1,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: height * 0.016,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.8),
                                )
                              ],
                            ),
                            // SizedBox(
                            //   width: width * 0.04,
                            // ),
                            Column(
                              children: [
                                Container(
                                  width: width * 0.12,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(47, 205, 214, 199),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Icon(
                                    Icons.access_time_filled_sharp,
                                    color: Get.isDarkMode ? darkColor : mainColor,
                                    size: 22,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text(
                                  !languageController.isLang
                                      ? tc.duration1.value
                                      : duration1,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: height * 0.013,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.4),
                                )
                              ],
                            ),

                            Column(
                              children: [
                                Container(
                                  width: width * 0.12,
                                  height: width * 0.12,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(47, 205, 214, 199),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ImageIcon(
                                    const AssetImage("assets/icons/pothole.png"),
                                    size: 12,
                                    color: Get.isDarkMode ? darkColor : mainColor,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text(
                                  "${tc.road1_potholes.value} ${tc.road1_potholes.value > 1 && tc.road1_potholes.value <= 10 ? !languageController.isLang ? "anomalies" : "نقر" : !languageController.isLang ? "anomaly" : "نقرة"}",
                                  style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white60
                                          : Colors.grey,
                                      fontSize: height * 0.015,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.8),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(tc.road1_bumps.toString(), style: TextStyle(color:  Get.isDarkMode ? darkColor:mainColor),)
                      ],
                    ),
                  )),
              SizedBox(
                height: height * 0.04,
              ),
              (tc.distance2.value.isNotEmpty || tc.duration2.value.isNotEmpty)
                  ?
                  //road 2
                  ElevatedButton(
                      onPressed: () {
                        tc.duration.value = !languageController.isLang
                            ? tc.duration2.value
                            : duration2;
                        tc.distance.value = !languageController.isLang
                            ? tc.distance2.value
                            : distance2;
                        tc.durationVar.value = duration2Digit;
                        tc.distanceVar.value = double.parse(dss2);
                        tc.road_potholes.value = tc.road3_potholes.value;
                        tc.road.value = 2;

                        c.hideForDialog.value = true;
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Get.isDarkMode ? Colors.black26 : Colors.white),
                        elevation: MaterialStateProperty.all(1),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        width: width * 0.12,
                                        height: width * 0.12,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                47, 205, 214, 199),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ImageIcon(
                                            const AssetImage(
                                                'assets/images/distance.png'),
                                            size: 12,
                                            color: Get.isDarkMode
                                                ? darkColor
                                                : mainColor)),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text(
                                      !languageController.isLang
                                          ? tc.distance2.value
                                          : distance2,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: height * 0.015,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.8),
                                    )
                                  ],
                                ),
                                // SizedBox(
                                //   width: width * 0.04,
                                // ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * 0.12,
                                      height: width * 0.12,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              47, 205, 214, 199),
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Icon(
                                        Icons.access_time_filled_sharp,
                                        color:
                                            Get.isDarkMode ? darkColor : mainColor,
                                        size: 22,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text(
                                      !languageController.isLang
                                          ? tc.duration2.value
                                          : duration2,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: height * 0.013,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.5),
                                    )
                                  ],
                                ),
                                // SizedBox(
                                //   width: width * 0.04,
                                // ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * 0.12,
                                      height: width * 0.12,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              47, 205, 214, 199),
                                          borderRadius: BorderRadius.circular(15)),
                                      child: ImageIcon(
                                        const AssetImage(
                                            "assets/icons/pothole.png"),
                                        size: 12,
                                        color:
                                            Get.isDarkMode ? darkColor : mainColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text(
                                      "${tc.road3_potholes.value} ${tc.road3_potholes.value > 1 && tc.road3_potholes.value <= 10 ? !languageController.isLang ? "anomalies" : "نقر" : !languageController.isLang ? "anomaly" : "نقرة"}",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: height * 0.015,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.8),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text(tc.road3_bumps.toString(), style: TextStyle(color: Get.isDarkMode ? darkColor22:mainColor),)
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ]),
      ),
    );
  }
}
