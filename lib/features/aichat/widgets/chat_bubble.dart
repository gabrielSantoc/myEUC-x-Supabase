import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatBubble extends StatelessWidget {
  final bool isUserMessage;
  final String message;
  final bool isLoading;

  const ChatBubble({
    required this.isUserMessage,
    required this.message,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUserMessage)
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Image.asset(
              "assets/icon/iconmanuel.png",
              width: 30,
              height: 30,
            ),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isUserMessage
                ? MediaQuery.of(context).size.width * 3 / 4
                : MediaQuery.of(context).size.width - 60,
          ),
          child: Container(
            padding: isLoading
                ? const EdgeInsets.symmetric(vertical: 8, horizontal: 15)
                : const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUserMessage
                  ? const Color.fromARGB(255, 170, 11, 0)
                  : Colors.grey[300],
              borderRadius: isUserMessage
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))
                  : const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
            ),
            child: isLoading
                ? LoadingAnimationWidget.waveDots(
                    color: const Color.fromARGB(97, 0, 0, 0),
                    size: 25,
                  )
                : MarkdownBody(
                    data: message,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                      tableBody: const TextStyle(fontSize: 10),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}