// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/maps/textFieldController.dart';
import '../../../logic/controller/maps/mapController.dart';
import '../../../utilis/theme.dart';

class BottomBarContainer extends StatelessWidget {
  final double height;
  final double width;

  BottomBarContainer({Key? key, required this.height, required this.width})
      : super(key: key);
  TextFieldController tc = Get.put(TextFieldController());
  final mp = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: height * 0.11,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: width * 0.13,
                    height: width * 0.13,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(47, 205, 214, 199),
                        borderRadius: BorderRadius.circular(17)),
                    child: ImageIcon(
                        const AssetImage('assets/images/distance.png'),
                        size: 12,
                        color: Get.isDarkMode ? darkColor : mainColor)
                    // Icon(
                    //   Icons.time_to_leave_rounded,
                    //   color: mainColor,
                    //   size: 25,
                    // ),
                    ),
                SizedBox(
                  width: width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        tc.distance.value,
                        style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.grey[900],
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      "distance".tr,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: height * 0.018,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.8),
                    ),
                  ],
                ),
              ],
            ),
            // VerticalDivider(width: width*0.05,thickness: 0.7,color: Colors.black54,indent: 5,endIndent: 10,),
            Row(
              children: [
                Container(
                  width: width * 0.13,
                  height: width * 0.13,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(47, 205, 214, 199),
                      borderRadius: BorderRadius.circular(17)),
                  child: Icon(
                    Icons.access_time_filled_sharp,
                    color: Get.isDarkMode ? darkColor : mainColor,
                    size: 22,
                  ),
                ),
                SizedBox(
                  width: width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        tc.duration.value,
                        style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.grey[900],
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Estimated Time".tr,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: height * 0.018,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.8),
                    )
                  ],
                )
              ],
            ),
          ],
        ), // .toStringAsPrecision(5)
      ),
    );
  }
}
