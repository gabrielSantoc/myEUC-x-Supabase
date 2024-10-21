import 'package:flutter/material.dart';

Widget buildMessageInput(TextEditingController controller,
    VoidCallback sendMessage, VoidCallback onTap) {
  return Row(
    children: [
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.fromLTRB(10, 10, 3, 10),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20.0)),
          child: TextField(
            onTap: onTap,
            maxLines: 5,
            minLines: 1,
            controller: controller,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Enter your message',
              hintStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.send_rounded, size: 30),
        color: const Color.fromARGB(255, 179, 0, 0),
        onPressed: sendMessage,
      ),
    ],
  );
}