class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  /// Serialise to JSON for sending conversation history to the backend.
  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };
}
