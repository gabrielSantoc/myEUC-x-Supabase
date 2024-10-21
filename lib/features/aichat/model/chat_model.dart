class ChatMessage {
  final String text;
  final bool isUserMessage;
  final bool isLoading;

  ChatMessage(
      {required this.text,
      required this.isUserMessage,
      this.isLoading = false});
}