import 'package:flutter/material.dart';

//display error
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    ),
  );
}

void scrollDown(ScrollController scrollController, Duration delay ) async {
  await Future.delayed(delay);
  scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    duration: delay,
    curve: Curves.easeInOut,
  );
}