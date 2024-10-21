import 'package:flutter/material.dart';

Widget buildWelcomeImage(double imageSize, ScrollController scrollController) {
  return Column(
    children: [
      const SizedBox(height: 100),
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(top: scrollController.offset > 500 ? 40 : 0),
        child: Image.asset("assets/icon/manuel2.png",
            width: imageSize, height: imageSize),
      ),
      const SizedBox(height: 50),
    ],
  );
}