import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utilis/theme.dart';

class textField extends StatelessWidget {
  final bool start;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final double width;
  final Icon prefixIcon;

  // final Widget? suffixIcon;
  final Function(String) locationCallback;

  const textField(
      {Key? key,
      this.start = false,
      required this.controller,
      required this.focusNode,
      required this.label,
      required this.hint,
      required this.width,
      required this.prefixIcon,
      // required this.suffixIcon,
      required this.locationCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.7,
      child: TextField(
        readOnly: start ? true : false,
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        cursorHeight: 20,
        style: TextStyle(
            color: Get.isDarkMode ? Colors.grey[200] : Colors.black87),
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Get.isDarkMode ? Colors.black : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: Get.isDarkMode ? Colors.black87 : Colors.white12,
                width: 0,
              ),
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.brown, width: 1),
            // ),

            contentPadding: const EdgeInsets.all(10),
            hintText: hint,
            labelStyle: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8),
            hintStyle: TextStyle(
                color: Colors.grey[900],
                fontSize: 24,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2)),
      ),
    );
  }
}

class textField2 extends StatelessWidget {
  final bool start;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final double width;

  // final Widget? suffixIcon;
  final Function(String) locationCallback;

  const textField2(
      {Key? key,
      this.start = false,
      required this.controller,
      required this.focusNode,
      required this.hint,
      required this.width,
      // required this.suffixIcon,
      required this.locationCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.7,
      child: TextField(
        readOnly: start ? true : false,
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        cursorColor: Get.isDarkMode ? darkColor : mainColor,
        cursorHeight: 25,
        style:
            TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black54),
        decoration: InputDecoration(
          // suffixIcon: suffixIcon,

          // labelText: label,
          filled: true,
          fillColor: Get.isDarkMode ? Colors.black : Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(
              color: Get.isDarkMode ? Colors.black : Colors.white,
              width: 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(
                color: Get.isDarkMode ? Colors.black : Colors.white,
                width: 0.1),
          ),
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          hintText: hint,
          // labelStyle: TextStyle(
          //   color: tc.darkMode.value ? Colors.white : Colors.black,
          // ),
          hintStyle: TextStyle(
            color: Get.isDarkMode
                ? Colors.white.withOpacity(0.4)
                : Colors.black.withOpacity(0.4),
            fontWeight: FontWeight.w300,
            fontSize: 11,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
