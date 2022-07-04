import 'package:flutter/material.dart';

const Color mainColor = Color.fromARGB(255, 21, 146, 129);
const Color darkGreyClr = Color(0xFF121212);
const Color darkColor = Color.fromARGB(255, 137, 93, 93);
const Color lightColor1 = Color(0xffcbc6bd);
const Color lightColor3 = Color(0xffA5947F);
const Color darkColor33 = Color(0xffe3e3e3);
const Color lightColor4 = Colors.lightBlueAccent;

const Color lightColor = Color.fromARGB(255, 224, 241, 223);
const Color darkColor2 = Color.fromARGB(255, 163, 73, 90);
const Color darkColor22 = Color.fromARGB(255, 137, 93, 93);
const Color darkColor3 = Color.fromARGB(255, 133, 49, 65);


class ThemesApp {
  static final light = ThemeData(
    primaryColor: mainColor,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}
