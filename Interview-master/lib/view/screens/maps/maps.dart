import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart' as loc;
import 'package:road_damage/logic/controller/maps/latLngController.dart';
import 'package:road_damage/logic/controller/maps/mapController.dart';
import 'package:road_damage/logic/controller/maps/markerController.dart';
import 'package:road_damage/logic/controller/maps/placeApiController.dart';
import 'package:road_damage/logic/controller/maps/textFieldController.dart';
import 'package:road_damage/logic/controller/userData_controller.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/search_screen.dart';
import 'package:road_damage/view/widgets/Maps/TextFieldsWidgets.dart';
import 'package:road_damage/view/widgets/Maps/bottomBarContainer.dart';
import 'package:road_damage/view/widgets/Maps/snackBarWidget.dart';
import 'package:road_damage/view/widgets/home/drawer.dart';

import '../../../logic/controller/network_controller.dart';
import 'package:road_damage/logic/controller/Language_controller.dart';
import '../networkFailed.dart';

class Maps extends StatefulWidget {

  const Maps({
    Key? key,
    // required this.position,
  }) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late final loc.LocationData position;
  final pc = Get.put(PlaceApiController());
  final c = Get.put(LatLngController());
  final tc = Get.put(TextFieldController());
  final mc = Get.put(MarkerController());
  final mp = Get.put(MapController());
  final languageController = Get.put(LanguageController());
  final userController = Get.put(User_controller());
  final networkManager = Get.find<GetXNetworkManager>();
  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();
  var storage = GetStorage();
  late String lang;
  String userName = '.....';

  _mapController(GoogleMapController controller) {
    mc.mapController = controller;
    mc.isMapCreated();
    mc.convertMap();
  }

  Future<void> changeLanguage() async {
    lang = await storage.read("lang") ?? "en";
    if (lang == "ar") {
      tc.changeTextEditingControllersToArabic();
      languageController.changeIsLang(false);
    } else {
      tc.changeTextEditingControllersToEnglish();
      languageController.changeIsLang(true);
    }
  }

  @override
  void initState() {
    super.initState();
    mc.initAll();
    mp.getCurrentLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: context.theme.backgroundColor,
      drawerEnableOpenDragGesture: false,
      //drawer
      drawer: Drawer(child: MainDrawer()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Map View
            GetBuilder<MarkerController>(
                init: MarkerController(),
                builder: (controller) =>
                    ((mc.startLatitude != 0.0 && mc.startLongitude != 0.0) &&
                            mc.isLoaded)
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                // Will be fetching in the next step
                                mc.position.latitude!,
                                mc.position.longitude!,
                              ),
                              zoom: 18,
                            ),
                            trafficEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: true,
                            polylines: controller.polyLineSet,
                            onMapCreated: _mapController,
                            markers: controller.markers,
                            // circles: Set.of(circle != null ? [circle!] : []),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )),

            GetBuilder<GetXNetworkManager>(builder: (_) {
              return networkManager.connectionType == 0
                  ? const NetworkFailedScreen()
                  : Obx(
                      () => ((!c.hideForDialog.value && !c.hideAll.value))
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    //  color: Get.isDarkMode ? darkGreyClr : Colors.white,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? darkGreyClr
                                          : Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          alignment: Alignment.topRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  GetBuilder<User_controller>(
                                                      builder: (_) {
                                                    return Builder(
                                                        builder:
                                                            (context) => // Ensure Scaffold is in context
                                                                ElevatedButton(
                                                                  onPressed: Scaffold.of(
                                                                          context)
                                                                      .openDrawer,
                                                                  child: userController
                                                                          .first
                                                                      ? const CircleAvatar(
                                                                          radius:
                                                                              15,
                                                                          backgroundImage:
                                                                              AssetImage('assets/images/profile.png'),
                                                                        )
                                                                      : CircleAvatar(
                                                                          radius:
                                                                              15,
                                                                          backgroundImage:
                                                                              FileImage(userController.authUserPhoto),
                                                                        ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                        Color>(Get
                                                                            .isDarkMode
                                                                        ? darkGreyClr
                                                                        : Colors
                                                                            .white),
                                                                    elevation:
                                                                        MaterialStateProperty
                                                                            .all(0),
                                                                  ),
                                                                ));
                                                  }),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GetBuilder<
                                                              User_controller>(
                                                          builder: (_) {
                                                        return Text(
                                                          "Hello ".tr +
                                                              "${userController.identifier['name'] ?? userName} 😍",
                                                          style: TextStyle(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? darkColor
                                                                  : mainColor,
                                                              fontSize: height *
                                                                  0.018,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.8),
                                                        );
                                                      }),
                                                      SizedBox(
                                                        height: height * 0.005,
                                                      ),
                                                      Text(
                                                        "Where are you going today?"
                                                            .tr,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[500],
                                                            fontSize:
                                                                height * 0.022,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  tc.search.value =
                                                      !tc.search.value;
                                                },
                                                child: Container(
                                                  width: width * 0.13,
                                                  height: width * 0.13,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              47,
                                                              205,
                                                              214,
                                                              199),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17)),
                                                  child: Icon(
                                                    Icons.search_outlined,
                                                    color: Get.isDarkMode
                                                        ? darkColor
                                                        : mainColor,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(() {
                                          if (tc.search.value) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.02,
                                                  left: 5,
                                                  right: 5),
                                              width: width,
                                              padding: EdgeInsets.only(
                                                top: height * 0.01,
                                                left: height * 0.006,
                                                right: 0.006,
                                                bottom: height * 0.012,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Get.isDarkMode
                                                    ? Colors.black87
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          String loc =
                                                              await Get.to(
                                                            () =>
                                                                const SearchScreen(
                                                              num: 1,
                                                            ),
                                                          );
                                                          if (loc == "null") {
                                                            SnackBars
                                                                .nothingSnackBar();
                                                          } else {
                                                            tc.startAddressController
                                                                .text = loc;
                                                            tc.startLocation
                                                                .value = loc;
                                                            tc.isChoosingCurrent
                                                                .value = false;
                                                          }
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          child: IgnorePointer(
                                                            ignoring: true,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                                  child: Text(
                                                                    "Start Location"
                                                                        .tr,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey[400]),
                                                                  ),
                                                                ),
                                                                textField(
                                                                  start: true,
                                                                  label: '',
                                                                  hint:
                                                                      'Choose Starting Point',
                                                                  prefixIcon:
                                                                      const Icon(
                                                                          Icons
                                                                              .looks_one),
                                                                  controller: tc
                                                                      .startAddressController,
                                                                  focusNode:
                                                                      startAddressFocusNode,
                                                                  width: width,
                                                                  locationCallback:
                                                                      (String
                                                                          value) {
                                                                    tc.startLocation
                                                                            .value =
                                                                        value;
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Obx(
                                                        () => tc.startLocation
                                                                .value.isEmpty
                                                            ? IconButton(
                                                                icon: Icon(
                                                                    Icons
                                                                        .my_location,
                                                                    color: Colors
                                                                            .grey[
                                                                        400]),
                                                                onPressed:
                                                                    () async {
                                                                  tc.startLocation
                                                                          .value =
                                                                      await c.getCurrentStartLocation(
                                                                          true);
                                                                  tc.startAddressController
                                                                          .text =
                                                                      tc.startLocation
                                                                          .value;
                                                                  tc.isChoosingCurrent
                                                                          .value =
                                                                      true;
                                                                },
                                                              )
                                                            : IconButton(
                                                                icon: Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                            .grey[
                                                                        400]),
                                                                onPressed: () {
                                                                  debugPrint(
                                                                      '-----------------------------');
                                                                  debugPrint(
                                                                      languageController
                                                                          .isLang
                                                                          .toString());
                                                                  tc.startLocation
                                                                      .value = "";
                                                                  tc.startAddressController
                                                                      .text = !languageController
                                                                          .isLang
                                                                      ? "Your Current Location"
                                                                      : "موقعك الحالي";
                                                                },
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                  Divider(
                                                    height: 1,
                                                    indent: 3,
                                                    endIndent: 5,
                                                    color: Get.isDarkMode
                                                        ? Colors.grey[600]
                                                        : Colors.grey[400],
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          String loc =
                                                              await Get.to(
                                                            () =>
                                                                const SearchScreen(
                                                              num: 2,
                                                            ),
                                                          );
                                                          if (loc == "null") {
                                                            SnackBars
                                                                .nothingSnackBar();
                                                          } else {
                                                            tc.destinationAddressController
                                                                .text = loc;
                                                            tc.destinationLocation
                                                                .value = loc;
                                                          }
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Text(
                                                                "Destination Location"
                                                                    .tr,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        400]),
                                                              ),
                                                            ),
                                                            Container(
                                                              color: Colors
                                                                  .transparent,
                                                              child:
                                                                  IgnorePointer(
                                                                ignoring: true,
                                                                child:
                                                                    textField(
                                                                  start: true,
                                                                  label: '',
                                                                  hint:
                                                                      'Choose Starting Point',
                                                                  prefixIcon:
                                                                      const Icon(
                                                                          Icons
                                                                              .looks_two),
                                                                  controller: tc
                                                                      .destinationAddressController,
                                                                  focusNode:
                                                                      destinationAddressFocusNode,
                                                                  width: width,
                                                                  locationCallback:
                                                                      (String
                                                                          value) {
                                                                    pc.recommendedPlaces(
                                                                        value);

                                                                    tc.destinationLocation
                                                                            .value =
                                                                        value;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.edit,
                                                            color: Colors
                                                                .grey[400]),
                                                        onPressed: () {
                                                          tc.destinationLocation
                                                              .value = "";
                                                          tc.destinationAddressController
                                                                  .text =
                                                              !languageController
                                                                      .isLang
                                                                  ? "Your Destination Location"
                                                                  : "موقع وجهتك";
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Obx(
                                                    () => (tc
                                                                .startLocation
                                                                .value
                                                                .isNotEmpty &&
                                                            tc.destinationLocation
                                                                .value.isNotEmpty)
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              tc.chosenRoad
                                                                  .clear();
                                                              tc.road1_potholes
                                                                  .value = 0;
                                                              tc.road3_potholes
                                                                  .value = 0;
                                                              tc.search.value =
                                                                  !tc.search
                                                                      .value;
                                                              try {
                                                                List<Location>
                                                                    destinationPlaceMark =
                                                                    await locationFromAddress(tc
                                                                        .destinationLocation
                                                                        .value);
                                                                if (tc
                                                                    .isChoosingCurrent
                                                                    .value) {
                                                                  tc.startLatitude
                                                                          .value =
                                                                      c.latitude
                                                                          .value;
                                                                  tc.startLongitude
                                                                          .value =
                                                                      c.longitude
                                                                          .value;
                                                                } else {
                                                                  List<Location>
                                                                      startPlaceMark =
                                                                      await locationFromAddress(tc
                                                                          .startLocation
                                                                          .value);
                                                                  tc.startLatitude
                                                                          .value =
                                                                      startPlaceMark[
                                                                              0]
                                                                          .latitude;
                                                                  tc.startLongitude
                                                                          .value =
                                                                      startPlaceMark[
                                                                              0]
                                                                          .longitude;
                                                                }
                                                                tc.destinationLatitude
                                                                        .value =
                                                                    destinationPlaceMark[
                                                                            0]
                                                                        .latitude;
                                                                tc.destinationLongitude
                                                                        .value =
                                                                    destinationPlaceMark[
                                                                            0]
                                                                        .longitude;
                                                                if (mc.firstTime !=
                                                                    true) {
                                                                  mc.deletePreviousMarkers();
                                                                } else {
                                                                  mc.updateFirstTime();
                                                                }
                                                                double miny = (tc
                                                                            .startLatitude
                                                                            .value <=
                                                                        tc.destinationLatitude
                                                                            .value)
                                                                    ? tc.startLatitude
                                                                        .value
                                                                    : tc.destinationLatitude
                                                                        .value;
                                                                double minx = (tc
                                                                            .startLongitude
                                                                            .value <=
                                                                        tc.destinationLongitude
                                                                            .value)
                                                                    ? tc.startLongitude
                                                                        .value
                                                                    : tc.destinationLongitude
                                                                        .value;
                                                                double maxy = (tc
                                                                            .startLatitude
                                                                            .value <=
                                                                        tc.destinationLatitude
                                                                            .value)
                                                                    ? tc.destinationLatitude
                                                                        .value
                                                                    : tc.startLatitude
                                                                        .value;
                                                                double maxx = (tc
                                                                            .startLongitude
                                                                            .value <=
                                                                        tc.destinationLongitude
                                                                            .value)
                                                                    ? tc.destinationLongitude
                                                                        .value
                                                                    : tc.startLongitude
                                                                        .value;

                                                                double
                                                                    southWestLatitude =
                                                                    miny;
                                                                double
                                                                    southWestLongitude =
                                                                    minx;

                                                                double
                                                                    northEastLatitude =
                                                                    maxy;
                                                                double
                                                                    northEastLongitude =
                                                                    maxx;

                                                                mc.mapController
                                                                    .animateCamera(
                                                                  CameraUpdate
                                                                      .newLatLngBounds(
                                                                    LatLngBounds(
                                                                      northeast: LatLng(
                                                                          northEastLatitude,
                                                                          northEastLongitude),
                                                                      southwest: LatLng(
                                                                          southWestLatitude,
                                                                          southWestLongitude),
                                                                    ),
                                                                    100.0,
                                                                  ),
                                                                );
                                                                var result =
                                                                    await tc
                                                                        .getRoutesBetweenLocations();

                                                                var res =
                                                                    mc.numberOfPothole(
                                                                  (result[0][
                                                                          'polyline_decoded']
                                                                      as List<
                                                                          PointLatLng>),1
                                                                );
                                                                tc.road1_potholes
                                                                    .value = res[0];
                                                                debugPrint("-------------------");
                                                                if(languageController.isLang){
                                                                  tc.road1_bumps.value =  "يوجد طرق وعرة بنسبة %${res[1]}";
                                                                }else{
                                                                  tc.road1_bumps
                                                                      .value = "There is a ${res[1]}% rough road";
                                                                }


                                                                if (result
                                                                        .length >
                                                                    1) {
                                                                  var res2 =
                                                                      mc.numberOfPothole(
                                                                    (result[1][
                                                                            'polyline_decoded']
                                                                        as List<
                                                                            PointLatLng>),2
                                                                  );
                                                                  tc.road3_potholes
                                                                      .value = res2[0];

                                                                  if(languageController.isLang){
                                                                    tc.road3_bumps.value =  "يوجد طرق وعرة بنسبة %${res2[1]}";
                                                                  }else{
                                                                    tc.road3_bumps
                                                                        .value = "There is a ${res2[1]}% rough road";
                                                                  }

                                                                }
                                                                c.hideAll
                                                                        .value =
                                                                    true;
                                                                int r = await tc
                                                                    .dataOfPotholes(
                                                                        context);
                                                                c.hideAll
                                                                        .value =
                                                                    false;
                                                                if ((tc.road.value ==
                                                                        1) ||
                                                                    (tc.road.value ==
                                                                        2)) {
                                                                  mc.addMarkers();
                                                                  if (r == 1) {
                                                                    tc.chosenRoad
                                                                        .value = [
                                                                      ...(result[0]
                                                                              [
                                                                              'polyline_decoded']
                                                                          as List<
                                                                              PointLatLng>)
                                                                    ];
                                                                    PolylineId
                                                                        id1 =
                                                                        const PolylineId(
                                                                            "poly1");
                                                                    Polyline
                                                                        polyline1 =
                                                                        Polyline(
                                                                      polylineId:
                                                                          id1,
                                                                      color: Get
                                                                              .isDarkMode
                                                                          ? darkColor
                                                                          : mainColor,
                                                                      points: (result[0]['polyline_decoded'] as List<
                                                                              PointLatLng>)
                                                                          .map((point) => LatLng(
                                                                              point.latitude,
                                                                              point.longitude))
                                                                          .toList(),
                                                                      width: 6,
                                                                    );
                                                                    mc.updatePolyline(
                                                                        polyline1);
                                                                  } else {
                                                                    tc.chosenRoad
                                                                        .value = [
                                                                      ...(result[1]
                                                                              [
                                                                              'polyline_decoded']
                                                                          as List<
                                                                              PointLatLng>)
                                                                    ];
                                                                    PolylineId
                                                                        id3 =
                                                                        const PolylineId(
                                                                            "poly3");
                                                                    Polyline
                                                                        polyline3 =
                                                                        Polyline(
                                                                      polylineId:
                                                                          id3,
                                                                      color: Get
                                                                              .isDarkMode
                                                                          ? darkColor
                                                                          : mainColor,
                                                                      points: (result[1]['polyline_decoded'] as List<
                                                                              PointLatLng>)
                                                                          .map((point) => LatLng(
                                                                              point.latitude,
                                                                              point.longitude))
                                                                          .toList(),
                                                                      width: 6,
                                                                    );
                                                                    mc.updatePolyline(
                                                                        polyline3);
                                                                  }
                                                                  c.startCounting
                                                                          .value =
                                                                      true;
                                                                  mp.startRecord();
                                                                }
                                                              } catch (e) {
                                                                c.startCounting
                                                                        .value =
                                                                    false;
                                                                SnackBars
                                                                    .networkSnackBar();
                                                              }
                                                            },
                                                            child: Container(
                                                              // margin: EdgeInsets.all(5),
                                                              width:
                                                                  width * 0.88,
                                                              height:
                                                                  height * 0.08,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? darkColor
                                                                    : mainColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                "Get The Route"
                                                                    .tr,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        height *
                                                                            0.017,
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0.9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              )),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return Container();
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : (c.hideForDialog.value && !c.hideAll.value)
                              ? Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    height: height * 0.078,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? darkGreyClr
                                          : Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.arrow_back_ios,
                                                color: Colors.grey[400]),
                                            onPressed: () async {
                                              mp.stopRecord();
                                              // await mp.saveSensorRecording();
                                              mc.clearSets();
                                              c.hideForDialog.value = false;
                                            }),
                                        SizedBox(
                                          width: width * 0.27,
                                        ),
                                        Text(
                                          "Route".tr,
                                          style: TextStyle(
                                              color: Get.isDarkMode
                                                  ? Colors.grey[200]
                                                  : Colors.grey[700],
                                              fontSize: height * 0.025,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                    );
            }),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(
                          () => c.hideForDialog.value
                              ? Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    margin: EdgeInsets.only(
                                        left: width * 0.04,
                                        right: width * 0.04),
                                    height: height * 0.08,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? darkColor
                                          : mainColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Text(
                                      c.currentStreet.value,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ),
                                )
                              : Container(),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.only(right: 5, left: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black54,
                                  width: 0.4),
                              borderRadius: BorderRadius.circular(70),
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                            ),
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.my_location,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          onTap: () {
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
                          },
                        ),
                      ],
                    ),
                  ),
                  Obx(() => (c.hideForDialog.value &&
                          tc.distance.value.isNotEmpty &&
                          tc.distance.value.isNotEmpty)
                      ? BottomBarContainer(height: height, width: width)
                      : Container(
                          height: 0,
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*


    Obx(() => (tc.startLocation.value.isNotEmpty &&
                    tc.destinationLocation.value.isNotEmpty &&
                    c.startCounting.value &&
                    tc.distance.isNotEmpty &&
                    tc.duration.isNotEmpty)
                ? BottomBarContainer(height: height, width: width)
                : Container(
                    height: 0,
                  )),
 */
