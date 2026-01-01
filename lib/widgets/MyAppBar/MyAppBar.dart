import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final Size size;
  const MyAppBar({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Image.asset(
          "lib/assets/images/logo_black.png",
          height: size.width * 0.12,
          fit: .contain,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            "lib/assets/images/app_name_light.png",
            width: size.width * 0.35,
          ),
        ),
      ],
    );
  }
}
