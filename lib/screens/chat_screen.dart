import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../providers/language_provider.dart';
import '../utils/translations.dart';
import '../theme/app_theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final language = ref.watch(languageProvider);
    final t = Translations.of(language.code);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Scroll to bottom whenever messages change
    ref.listen<ChatState>(chatProvider, (prev, next) {
      if ((prev?.messages.length ?? 0) != next.messages.length) {
        _scrollToBottom();
      }
    });

    // Show error snackbar
    ref.listen<ChatState>(chatProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () => ref.read(chatProvider.notifier).clearError(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, t),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState(isDark, t)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: chatState.messages.length +
                        (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length &&
                          chatState.isLoading) {
                        return _TypingBubble(isDark: isDark);
                      }
                      final msg = chatState.messages[index];
                      return _MessageBubble(
                        message: msg,
                        isDark: isDark,
                        t: t,
                      ).animate().fadeIn(
                            delay: Duration(milliseconds: 50),
                            duration: 300.ms,
                          ).slideY(begin: 0.1, duration: 300.ms, curve: Curves.easeOut);
                    },
                  ),
          ),
          _buildInputBar(context, chatState, isDark, t),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Map<String, String> t) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🐻‍❄️', style: TextStyle(fontSize: 20)),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scaleXY(begin: 0.95, end: 1.05, duration: 1200.ms),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t['menu_tutor']!,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF66BB6A),
                      shape: BoxShape.circle,
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .fade(begin: 0.4, end: 1.0, duration: 800.ms),
                  const SizedBox(width: 5),
                  Text(
                    'Online • Global Warming',
                    style: GoogleFonts.nunito(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 22),
          tooltip: t['new_chat_title'],
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(t['new_chat_title']!),
                content: Text(t['new_chat_desc']!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(t['cancel']!),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ref.read(chatProvider.notifier).clearConversation();
                    },
                    child: Text(t['clear']!, style: const TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark, Map<String, String> t) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌍', style: TextStyle(fontSize: 64))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 0.95, end: 1.05, duration: 2.seconds),
          const SizedBox(height: 16),
          Text(
            t['start_conversation']!,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: isDark ? AppTheme.textDarkLight : AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t['chat_hint']!,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: isDark ? AppTheme.textDarkDim : AppTheme.textLight,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildInputBar(BuildContext context, ChatState state, bool isDark, Map<String, String> t) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 12
            : 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.messages.length <= 1) ...[
                  _SuggestionChips(onTap: (text) {
                    _controller.text = text;
                    _sendMessage();
                  }, languageCode: ref.read(languageProvider).code),
                  const SizedBox(height: 8),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 120),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          maxLines: 4,
                          minLines: 1,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            color: isDark ? AppTheme.textDarkLight : AppTheme.textDark,
                          ),
                          decoration: InputDecoration(
                            hintText: t['type_question'],
                            hintStyle: GoogleFonts.nunito(
                              color: isDark ? AppTheme.textDarkDim : AppTheme.textLight,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SendButton(
                      isLoading: state.isLoading,
                      onTap: _sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _SendButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [Colors.grey.shade400, Colors.grey.shade500]
                : [const Color(0xFF0F2027), const Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;
  final Map<String, String> t;

  const _MessageBubble({required this.message, required this.isDark, required this.t});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF0F2027), Color(0xFF2C5364)]),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🐻‍❄️', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t['copied']!),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? const LinearGradient(
                          colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isUser
                      ? null
                      : isDark
                          ? AppTheme.cardDark
                          : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: isUser
                      ? null
                      : Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.grey.withValues(alpha: 0.12),
                        ),
                ),
                child: Text(
                  message.text,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: isUser
                        ? Colors.white
                        : isDark
                            ? AppTheme.textDarkLight
                            : AppTheme.textDark,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person_rounded,
                    size: 18, color: AppTheme.primaryGreen),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  final bool isDark;
  const _TypingBubble({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0F2027), Color(0xFF2C5364)]),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🐻‍❄️', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(
                      begin: 0.6,
                      end: 1.0,
                      duration: 500.ms,
                      delay: Duration(milliseconds: 150 * i),
                      curve: Curves.easeInOut,
                    );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

class _SuggestionChips extends StatelessWidget {
  final ValueChanged<String> onTap;
  final String languageCode;

  const _SuggestionChips({required this.onTap, required this.languageCode});

  static const Map<String, List<String>> _suggestionsMap = {
    'id': [
      '🌡️ Efek rumah kaca',
      '☀️ Radiasi matahari',
      '🌊 Keseimbangan energi',
      '🏭 CO₂ dan panas',
    ],
    'en': [
      '🌡️ Greenhouse effect',
      '☀️ Solar radiation',
      '🌊 Energy balance',
      '🏭 CO₂ and heat',
    ]
  };

  @override
  Widget build(BuildContext context) {
    final suggestions = _suggestionsMap[languageCode] ?? _suggestionsMap['id']!;
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => onTap(suggestions[i].substring(3)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.25)),
              ),
              child: Text(
                suggestions[i],
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ).animate(delay: Duration(milliseconds: 80 * i)).fadeIn(duration: 300.ms);
        },
      ),
    );
  }
}
