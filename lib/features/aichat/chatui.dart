import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatMessage {
  final String text;
  final bool isUserMessage;
  final bool isLoading;

  ChatMessage(
      {required this.text,
      required this.isUserMessage,
      this.isLoading = false});
}

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});
  @override
  _ChatUIState createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = true;
  double _imageSize = 400;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeChat();
    _scrollController.addListener(() {
      setState(() {
        _isAtBottom = _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent;
        _imageSize = (400 - (_scrollController.offset / 1)).clamp(50.0, 400.0);
      });
    });
  }

  Future<void> _initializeChat() async {
    final response = await _sendQuery("Introduce yourself");
    if (response != null) {
      _messages.add(ChatMessage(text: response, isUserMessage: false));
    }
    _scrollDown(const Duration(milliseconds: 500));
  }

  Future<String?> _sendQuery(String query) async {
    try {
      final response = await http.post(
        // Uri.parse('http://192.168.126.64:5000/query'),
        Uri.parse('https://myeuc-server.onrender.com/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['groqResponse']['text'];
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      print('Error sending query: $e');
      showErrorDialog(
        context,
        'Connection Error',
        'Failed to connect to the server. Please check your network connection and try again.',
      );
      return null;
    }
  }

  void _resetConversation() {
    setState(() {
      _messages.clear();
      _messageController.clear();
      _imageSize = 400;
    });
    _initializeChat();
  }

  void _scrollDown(Duration delay) async {
    await Future.delayed(delay);
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

void _sendMessage() async {
  final text = _messageController.text.trim();
  if (text.isNotEmpty) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUserMessage: true));
      _messages.add(ChatMessage(text: '', isUserMessage: false, isLoading: true));
    });
    _messageController.clear();
    _scrollDown(const Duration(milliseconds: 500));

    final response = await _sendQuery(text);
    setState(() {
      _messages.removeLast();
      _messages.add(ChatMessage(
          text: response ?? 'Error occurred', isUserMessage: false));
    });
    _scrollDown(const Duration(milliseconds: 500));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manuel AI',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 155, 10, 0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => showConfirmDialog(
                context,
                'Delete Conversation',
                'Are you sure you want to delete this conversation? You won\'t be able to retrieve it.',
                _resetConversation),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton:
          _isAtBottom ? null : buildScrollToBottomButton(_scrollDown),
      body: FutureBuilder(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                      color: Color.fromARGB(255, 170, 0, 0), size: 60),
                  SizedBox(height: 20),
                  Text('Initializing chat...',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error initializing chat: ${snapshot.error}'),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) =>
                        _buildChatBubble(context, index),
                  ),
                ),
                buildMessageInput(_messageController, _sendMessage,
                    () => _scrollDown(const Duration(milliseconds: 500))),
              ],
            );
          }
        },
      ),
    );
  }

Widget _buildChatBubble(BuildContext context, int index) {
  final message = _messages[index];
  if (index == 0 && !message.isUserMessage) {
    return Column(
      children: [
        buildWelcomeImage(_imageSize, _scrollController),
        ChatBubble(
          isUserMessage: message.isUserMessage,
          message: message.text,
          isLoading: message.isLoading,
        ),
      ],
    );
  }
  return ChatBubble(
    isUserMessage: message.isUserMessage,
    message: message.text,
    isLoading: message.isLoading,
  );
}
}

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
            padding: isLoading?  const EdgeInsets.symmetric(vertical: 8, horizontal: 15) : const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                    color: Color.fromARGB(97, 0, 0, 0),
                    size: 25,
                  )
                : MarkdownBody(
                    data: message,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                      tableBody: TextStyle(fontSize: 10),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

// Helper functions
Widget buildScrollToBottomButton(Function scrollDown) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 60),
    child: FloatingActionButton.small(
      elevation: 0,
      backgroundColor: Colors.grey[300],
      onPressed: () => scrollDown(Duration.zero),
      child: const Icon(Icons.arrow_downward,
          color: Color.fromARGB(255, 114, 0, 0)),
      shape: const CircleBorder(),
    ),
  );
}

Widget buildWelcomeImage(double imageSize, ScrollController scrollController) {
  return Column(
    children: [
      SizedBox(height: 100),
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(top: scrollController.offset > 500 ? 40 : 0),
        child: Image.asset("assets/icon/manuel2.png",
            width: imageSize, height: imageSize),
      ),
      SizedBox(height: 50),
    ],
  );
}

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

void showErrorDialog(BuildContext context, String title, String content,
    {VoidCallback? retryAction}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 155, 10, 0)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          if (retryAction != null)
            TextButton(
              child: Text('Retry'),
              style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 155, 10, 0)),
              onPressed: () {
                Navigator.of(context).pop();
                retryAction();
              },
            ),
        ],
      );
    },
  );
}

void showConfirmDialog(BuildContext context, String title, String content,
    VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 155, 10, 0)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete'),
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 155, 10, 0)),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
