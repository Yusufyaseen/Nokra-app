import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/text_utils.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const SocialButton({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Get.isDarkMode
              ? const Color.fromARGB(95, 22, 20, 20)
              : const Color.fromARGB(255, 255, 254, 254),
          minimumSize: const Size(360, 50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/icons/google.png",
              ),
              TextUtils(
                color: Get.isDarkMode ? darkColor3 : mainColor,
                text: text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                underLine: TextDecoration.none,
              ),
            ],
          ),
        ));
  }
}
