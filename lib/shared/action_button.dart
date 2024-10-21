import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/helper/helper_functions.dart';

Widget buildScrollToBottomButton(ScrollController scrollController) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 60),
    child: FloatingActionButton.small(
      elevation: 0,
      backgroundColor: Colors.grey[300],
      onPressed: () => scrollDown(scrollController, const Duration(milliseconds: 500)),
      shape: const CircleBorder(),
      child: const Icon(Icons.arrow_downward,
          color: Color.fromARGB(255, 114, 0, 0)),
    ),
  );
}