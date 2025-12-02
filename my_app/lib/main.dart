import 'package:flutter/material.dart';
//import 'dart:async';
import 'api_service.dart';

void main() {
  runApp(const ChatGPTApp());
}

class ChatGPTApp extends StatefulWidget {
  const ChatGPTApp({super.key});

  @override
  State<ChatGPTApp> createState() => _ChatGPTAppState();
}

class _ChatGPTAppState extends State<ChatGPTApp> {
  bool _isDarkMode = true;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade50,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black87),
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10A37F),
          brightness: Brightness.light,
          secondary: Colors.blueGrey,
          error: Colors.red,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF343541),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF343541),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF202123)),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10A37F),
          brightness: Brightness.dark,
          surface: const Color(0xFF444654),
          secondary: Colors.blueGrey.shade200,
          error: Colors.redAccent,
        ),
      ),
      home: ChatScreen(isDarkMode: _isDarkMode, onThemeChanged: _toggleTheme),
    );
  }
}

// --- Data Models ---
enum ChatMessageType { user, bot }

class ChatMessage {
  final String text;
  final ChatMessageType type;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.type, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  ChatSession({required this.id, required this.title, required this.messages});
}

// --- Main Chat Screen ---
class ChatScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ChatScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService(); // Initialize the ApiService

  // State variables
  List<ChatMessage> _currentMessages = [];
  List<ChatSession> _history = [];
  bool _isTyping = false;
  bool _isRecording = false; // For microphone
  final bool _liveTalkMode = false; // For TTS

  // Mock History Data
  @override
  void initState() {
    super.initState();
    _history = [
      ChatSession(id: '1', title: 'Flutter Help', messages: []),
      ChatSession(id: '2', title: 'Recipe for Pizza', messages: []),
      ChatSession(id: '3', title: 'Life Advice', messages: []),
    ];
  }

  // --- Logic ---
  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _currentMessages.add(ChatMessage(text: text, type: ChatMessageType.user));
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final responseText = await _apiService.sendMessage(text);
      if (mounted) {
        setState(() {
          _isTyping = false;
          _currentMessages.add(
            ChatMessage(text: responseText, type: ChatMessageType.bot),
          );
        });
        _scrollToBottom();
        if (_liveTalkMode) {
          _speakResponse(responseText);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _currentMessages.add(
            ChatMessage(
              text: "Error: Could not connect to API.",
              type: ChatMessageType.bot,
            ),
          );
        });
      }
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      // Logic: Start 'speech_to_text' listener here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listening... (Requires speech_to_text package)'),
        ),
      );
    } else {
      // Logic: Stop listener and put text in controller
    }
  }

  void _speakResponse(String text) {
    // Logic: Call 'flutter_tts' speak method here
    print("Speaking: $text");
  }

  void _startNewChat() {
    setState(() {
      if (_currentMessages.isNotEmpty) {
        _history.insert(
          0,
          ChatSession(
            id: DateTime.now().toString(),
            title: "${_currentMessages.first.text.substring(0, 10)}...",
            messages: List.from(_currentMessages),
          ),
        );
      }
      _currentMessages = [];
    });
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Container(
          color:
              theme.bottomSheetTheme.backgroundColor ??
              theme.colorScheme.surface,
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.attach_file,
                  color: theme.colorScheme.onSurface,
                ),
                title: Text(
                  'File',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File picking not implemented yet.'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo, color: theme.colorScheme.onSurface),
                title: Text(
                  'Photo',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Photo picking not implemented yet.'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _loadHistory(ChatSession session) {
    setState(() {
      _currentMessages = List.from(session.messages);
    });
    Navigator.pop(context);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: OutlinedButton.icon(
                onPressed: _startNewChat,
                icon: Icon(Icons.add, color: theme.colorScheme.onSurface),
                label: Text(
                  'New chat',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.chat_bubble_outline,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      size: 20,
                    ),
                    title: Text(
                      _history[index].title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _loadHistory(_history[index]),
                  );
                },
              ),
            ),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.2)),
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
              secondary: Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: theme.colorScheme.onSurface,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.secondary,
                child: Text(
                  'U',
                  style: TextStyle(color: theme.colorScheme.onSecondary),
                ),
              ),
              title: Text(
                'User Name',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                'user@example.com',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: ActionChip(label: Text('ChatGPT'), onPressed: () {}),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentMessages.isEmpty
                ? _buildWelcomeScreen()
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _currentMessages.length,
                    itemBuilder: (context, index) =>
                        ChatBubble(message: _currentMessages[index]),
                  ),
          ),
          if (_isTyping)
            LinearProgressIndicator(
              minHeight: 2,
              color: theme.colorScheme.primary,
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What can I help with?',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _buildSuggestionGrid(),
        ],
      ),
    );
  }

  Widget _buildSuggestionGrid() {
    return SizedBox(
      width: 400,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildSuggestionButton(Icons.image_outlined, 'Create image'),
          _buildSuggestionButton(Icons.summarize_outlined, 'Summarize text'),
          _buildSuggestionButton(Icons.analytics_outlined, 'Analyze data'),
          _buildSuggestionButton(Icons.code, 'Code'),
          _buildSuggestionButton(Icons.more_horiz, 'More'),
        ],
      ),
    );
  }

  Widget _buildSuggestionButton(IconData icon, String text) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: () => _handleSubmitted(text),
      icon: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.9)),
      label: Text(text, style: TextStyle(color: theme.colorScheme.onSurface)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.2)),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _buildInputArea() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor),
            ),
            child: IconButton(
              onPressed: _showAttachmentMenu,
              icon: Icon(Icons.add, color: theme.colorScheme.onSurface),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _textController,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Ask ChatGPT...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic_none),
                      onPressed: _toggleRecording,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    if (_textController.text.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              _handleSubmitted(_textController.text),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.graphic_eq),
                        onPressed: () {},
                        color: Colors.yellow.shade700,
                      ),
                  ],
                ),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBot = message.type == ChatMessageType.bot;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: isBot
            ? theme.colorScheme.surface
            : theme.scaffoldBackgroundColor,
        border: isBot
            ? Border(bottom: BorderSide(color: theme.dividerColor))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isBot
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Icon(
              isBot ? Icons.auto_awesome : Icons.person,
              size: 16,
              color: isBot
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSecondary,
            ),
          ),
          Expanded(
            child: SelectableText(
              message.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
