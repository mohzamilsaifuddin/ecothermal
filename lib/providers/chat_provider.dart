import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import '../utils/app_links.dart';
import '../utils/translations.dart';
import 'language_provider.dart';

// ─── STATE ────────────────────────────────────────────────────────────────────

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // null = clear existing error
    );
  }
}

// ─── NOTIFIER ─────────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref _ref;

  ChatNotifier(this._ref) : super(const ChatState()) {
    _initialGreeting();
  }

  void _initialGreeting() {
    final lang = _ref.read(languageProvider);
    final t = Translations.of(lang.code);
    _addBotMessage(t['greeting']!);
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final lang = _ref.read(languageProvider);
    final t = Translations.of(lang.code);

    // Add user message
    _addUserMessage(trimmed);

    // Begin loading
    state = state.copyWith(isLoading: true, errorMessage: null);

    final client = http.Client();
    try {
      final historyList = state.messages.take(state.messages.length - 1).toList();

      final validHistory = <ChatMessage>[];
      for (final msg in historyList) {
        if (validHistory.isEmpty && !msg.isUser) continue;
        validHistory.add(msg);
      }

      final request = http.Request('POST', Uri.parse(AppLinks.chatEndpoint));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'message': trimmed,
        'history': validHistory.map((m) => m.toJson()).toList(),
        'language': lang.code, // PASS LANGUAGE TO BACKEND
      });

      final response = await client.send(request);

      if (response.statusCode != 200) {
        print("API ERROR: Status Code ${response.statusCode}");
        final respStr = await response.stream.bytesToString();
        print("API ERROR RESPONSE: $respStr");
        state = state.copyWith(
          isLoading: false,
          errorMessage: t['error_server'],
        );
        return;
      }

      _addBotMessage("");

      await for (final line in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (line.startsWith('data: ')) {
          final dataStr = line.substring(6).trim();
          if (dataStr == '[DONE]') break;

          try {
            final data = jsonDecode(dataStr);
            final content = data['content'] as String?;

            if (content != null) {
              _updateLastBotMessage(content);
            }
          } catch (e) {
            print("Error decoding stream chunk: $e");
          }
        }
      }
    } catch (e, stackTrace) {
      print("====================================");
      print("CONNECTION ERROR IN CHAT PROVIDER:");
      print("Error: $e");
      print("StackTrace: $stackTrace");
      print("====================================");
      state = state.copyWith(
        isLoading: false,
        errorMessage: t['error_connection'],
      );
    } finally {
      client.close();
      state = state.copyWith(isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearConversation() {
    state = const ChatState();
    _initialGreeting();
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  void _addUserMessage(String text) {
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      ],
    );
  }

  void _addBotMessage(String text) {
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(text: text, isUser: false, timestamp: DateTime.now()),
      ],
    );
  }

  void _updateLastBotMessage(String newText) {
    if (state.messages.isEmpty) return;
    
    final lastMsg = state.messages.last;
    if (lastMsg.isUser) return;

    final updatedMessages = List<ChatMessage>.from(state.messages);
    updatedMessages[updatedMessages.length - 1] = ChatMessage(
      text: lastMsg.text + newText,
      isUser: false,
      timestamp: lastMsg.timestamp,
    );

    state = state.copyWith(messages: updatedMessages);
  }
}

// ─── PROVIDER ─────────────────────────────────────────────────────────────────

final chatProvider = StateNotifierProvider.autoDispose<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(ref),
);
