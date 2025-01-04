import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_bot/data/chat_bot_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/bot_thread.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/message.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/assistant_manager.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_content_view.dart';
import 'package:flutter_ai_app/features/prompt/presentation/widgets/prompt_library_bottom_sheet.dart';
import 'package:flutter_ai_app/utils/message_role_enum.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatSection extends StatefulWidget {
  final List<AiBot> bots;
  const ChatSection({
    super.key,
    required this.bots,
  });

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final TextEditingController _controller = TextEditingController();
  AiBotService aiBotService = GetIt.instance<AiBotService>();

  @override
  void initState() {
    super.initState();

    // Add listener to detect '/' input
    _controller.addListener(() {
      if (_controller.text.startsWith('/')) {
        _showBottomSheet();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => PromptLibraryBottomDialog(),
    );
  }

  void _sendMessage(ChatProvider chatProvider) async {
    final messageContent = _controller.text;

    if (messageContent.isNotEmpty) {
      final message = ChatMessage(
        assistant: AssistantDTO(
          id: chatProvider.selectedAssistant?.id ??
              Assistant.assistants.first.id,
          model: 'dify',
          name: chatProvider.selectedAssistant?.name ??
              Assistant.assistants.first.name,
        ),
        role: "user",
        content: messageContent,
      );
      print("message2: $message");
      chatProvider.addUserMessage(message);

      try {
        await chatProvider.sendFirstMessage(message);
        _controller.clear(); 
        // Chuyển hướng đến ChatContentView
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatContentView(assistant:  chatProvider.selectedAssistant!,)),
        );
      } catch (e) {
        print("Error sending first message: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Column(
      children: [
        _buildInputArea(chatProvider),
      ],
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Type a message...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
            ),
          )),
          IconButton(
            onPressed: () {
              if(chatProvider.selectedAssistant!.isDefault)
                _sendMessage(chatProvider);
              else{
                _sendMessageToPersonalBot(chatProvider);
              }
            },  
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
  void _sendMessageToPersonalBot(ChatProvider chatProvider) async{
    List<Message> history = [];
    //create new thread with bot 
    BotThread thread = await aiBotService.createNewThread(chatProvider.selectedAssistant.id, _controller.value.text);
    Message userMess = Message(
      role: MessageRole.user,
      createdDate: DateTime.now().millisecondsSinceEpoch,
      content: _controller.value.text,
    );
    history.add(userMess);
    Message assisMess = Message(
      role: MessageRole.assistant, 
      createdDate: DateTime.now().millisecondsSinceEpoch, 
      content: await ChatBotManager().getResponseMessageFromBot(
        AsisstantManager().findBotFromListData(widget.bots, chatProvider.selectedAssistant.id)!,
        _controller.value.text,
        thread.threadId,
       ));
    history.add(assisMess);
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatContentView(assistant: chatProvider.selectedAssistant, bots: widget.bots,thread: thread,)));

  }
}
