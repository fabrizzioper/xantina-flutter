import 'package:flutter/material.dart';

class TeamChatPage extends StatefulWidget {
  const TeamChatPage({super.key});

  @override
  State<TeamChatPage> createState() => _TeamChatPageState();
}

class _TeamChatPageState extends State<TeamChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mensajes de ejemplo
  final List<Map<String, dynamic>> _messages = [
    {
      'name': 'Bella Throne',
      'timestamp': 'June 12, 2020 - 19:35',
      'message':
          'We\'ve just finalized a new espresso recipe using the new washed Ethiopia lot. Please review the updated grind size and extraction time before tomorrow\'s shift.',
      'likes': 9,
      'dislikes': 2,
    },
    {
      'name': 'Christopher Oshana',
      'timestamp': 'June 12, 2020 - 19:35',
      'message':
          'Heads up: we\'re low on our current Brazil lot. A new one arrives on Thursday. Please monitor usage and mark remaining stock in the app.',
      'likes': 7,
      'dislikes': 1,
    },
    {
      'name': 'Kyle Austin',
      'timestamp': 'June 12, 2020 - 19:35',
      'message':
          'Please remember to complete the calibration checklist before starting your shift. Reach out if anything is missing from the station.',
      'likes': 7,
      'dislikes': 1,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        {
          'name': 'Yo',
          'timestamp': 'Ahora',
          'message': _messageController.text.trim(),
          'likes': 0,
          'dislikes': 0,
        },
      );
      _messageController.clear();
    });

    // Scroll to top
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Team Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Sección de comentario
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Leave a comment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Say something...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9E9E9E),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A2C1A),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _sendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatMessageCard(
                  name: message['name'] as String,
                  timestamp: message['timestamp'] as String,
                  message: message['message'] as String,
                  likes: message['likes'] as int,
                  dislikes: message['dislikes'] as int,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageCard extends StatelessWidget {
  final String name;
  final String timestamp;
  final String message;
  final int likes;
  final int dislikes;

  const _ChatMessageCard({
    required this.name,
    required this.timestamp,
    required this.message,
    required this.likes,
    required this.dislikes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto de perfil
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4A2C1A), // Marrón oscuro
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          // Contenido del mensaje
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y timestamp
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        timestamp,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Mensaje
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Reacciones
                Row(
                  children: [
                    _ReactionButton(
                      icon: Icons.thumb_up,
                      count: likes,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _ReactionButton(
                      icon: Icons.thumb_down,
                      count: dislikes,
                      color: Colors.red,
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

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _ReactionButton({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

