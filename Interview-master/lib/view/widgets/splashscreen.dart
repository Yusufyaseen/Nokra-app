import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final routeName = Get.arguments['routeName'];
  var identifier = {};

  @override
  void initState() {
    // : implement initState
    super.initState();
    startTime();
  }

  String img =
      'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300';

  startTime() async {
    //         }));
    var duration = const Duration(seconds: 1);

    return Timer(duration, route);
  }

  route() {
    Get.off(Routes.appdata,
        arguments: {'identifier': identifier, 'image': img});
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  Widget initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
