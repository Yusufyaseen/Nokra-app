import 'package:flutter/material.dart';
import 'package:road_damage/logic/controller/maps/placeApiController.dart';
import 'package:road_damage/logic/controller/maps/textFieldController.dart';
import 'widgets/Maps/TextFieldsWidgets.dart';
import 'package:get/get.dart';
import '../../../utilis/theme.dart';

class SearchScreen extends StatefulWidget {
  final int num;

  const SearchScreen({Key? key, required this.num}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  final node = FocusNode();
  TextFieldController tc = Get.put(TextFieldController());
  PlaceApiController pc = Get.put(PlaceApiController());

  @override
  void initState() {
    super.initState();
    pc.places.clear();
    node.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black54 : Colors.white,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Get.isDarkMode ? darkColor : mainColor,
                      width: 0.4),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textField2(
                      start: false,
                      hint: widget.num == 1
                          ? 'Choose Start Location'.tr
                          : 'Choose Destination Location'.tr,
                      controller: controller,
                      focusNode: node,
                      width: width,
                      locationCallback: (String value) {
                        pc.recommendedPlaces(value);
                        tc.searchText.value = value;
                      },
                    ),
                    Obx(
                      () => tc.searchText.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                size: height * 0.025,
                                color: Get.isDarkMode ? lightColor3 : mainColor,
                              ),
                              onPressed: () {
                                controller.clear();
                                pc.places.clear();
                                tc.searchText.value = '';
                                widget.num == 1
                                    ? tc.startLocation.value = ""
                                    : tc.destinationLocation.value = "";
                              },
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(() {
                if (pc.places.isNotEmpty) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: width * 0.9,
                        height: height * 0.7,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pc.places.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.text =
                                    pc.places[index]["description"].toString();
                                // node.unfocus();
                                // pc.places.clear();
                                // Get.back(result: controller.text);
                                Navigator.pop(context, controller.text);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: ListTile(
                                  leading: Icon(Icons.location_on_rounded,
                                      size: height * 0.04,
                                      color: Get.isDarkMode
                                          ? lightColor3
                                          : mainColor),
                                  title: Text(
                                    pc.places[index]["description"].toString(),
                                    style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[700]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
