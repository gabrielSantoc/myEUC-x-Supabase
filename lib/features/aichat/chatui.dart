import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myeuc_x_supabase/features/aichat/model/chat_model.dart';
import 'package:myeuc_x_supabase/features/aichat/widgets/chat_bubble.dart';
import 'package:myeuc_x_supabase/features/aichat/widgets/message_input.dart';
import 'package:myeuc_x_supabase/features/aichat/widgets/welcome_image.dart';
import 'package:myeuc_x_supabase/shared/action_button.dart';
import 'package:myeuc_x_supabase/shared/app_dialog.dart';
import 'package:myeuc_x_supabase/helper/helper_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



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
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeChat();
     _currentUserId = Supabase.instance.client.auth.currentUser!.id;
    _scrollController.addListener(() {
      setState(() {
        _isAtBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50;
        _imageSize = (400 - (_scrollController.offset / 1)).clamp(50.0, 400.0);
      });
    });
  }

  Future<void> _initializeChat() async {
    final response = await _sendQuery("Introduce yourself");
    if (response != null) {
      _messages.add(ChatMessage(text: response, isUserMessage: false));
    }
    scrollDown(_scrollController, const Duration(milliseconds: 500));
  }

  Future<String?> _sendQuery(String query) async {
    try {
      final response = await http.post(
        // Uri.parse('http://192.168.126.64:5000/query'),
        Uri.parse('https://myeuc-ai-server.onrender.com/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        incrementChatsPerDay(_currentUserId);
        return jsonResponse['groqResponse']['text'];
        
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      print('Error sending query: $e');
      AppDialog.showErrorDialog(
        context: context,
        title: 'Connection Error',
        message:
            'Failed to connect to the server. Please check your network connection.',
        onRetry: () => print('Retrying...'), // Optional
      );
      return null;
    }
  }

  void _resetConversation() {
    setState(() {
      _messages.clear();
      _messageController.clear();
      _imageSize = 400;
      _initializationFuture = _initializeChat();
    });

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
        _messages
            .add(ChatMessage(text: '', isUserMessage: false, isLoading: true));
      });
      _messageController.clear();
      scrollDown(_scrollController, const Duration(milliseconds: 500));

      final response = await _sendQuery(text);
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
            text: response ?? 'Error occurred', isUserMessage: false));
      });
      scrollDown(_scrollController, const Duration(milliseconds: 500));
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
            onPressed: () => AppDialog.showConfirmDialog(
              context: context,
              title: 'Delete Conversation',
              message:
                  'Are you sure you want to delete this conversation? You won\'t be able to retrieve it.',
              onConfirm: _resetConversation,
            ),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton:
          _isAtBottom ? null : buildScrollToBottomButton(_scrollController),
      body: FutureBuilder(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                      color: const Color.fromARGB(255, 170, 0, 0), size: 60),
                  const SizedBox(height: 20),
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
                    () => scrollDown(_scrollController, const Duration(milliseconds: 500))),
              ],
            );
          }
        },
      ),
    );
  }

//show image in first message
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



// Helper functions





