import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/ai_bot/ai_%20bot.dart';
import 'package:flutter_ai_app/core/models/ai_bot/message.dart';
import 'package:flutter_ai_app/features/ai_bot/data/chat_bot_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/ai_bot/chat_bot_history.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/utils/message_role_enum.dart';

class ChatBotScreen extends StatefulWidget {
  final AiBot assistant;
  final List<Message> history;
  ChatBotScreen({
    required this.assistant,
    required this.history
  });
  @override
  State<StatefulWidget> createState() => _chatBotState();
}

class _chatBotState extends State<ChatBotScreen> {
  TextEditingController chatController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Color _fillColor = Colors.grey.shade300;
  Color _iconColor = Colors.grey;
  late List<Message> history;

  void updateListHistory(List<Message> update){
    setState(() {
      history = update;
    });
  }
  void addMessageToHistory(Message mess){
    setState(() {
      history.add(mess);
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener((){
      setState(() {
        _fillColor = _focusNode.hasFocus ? Colors.white : Colors.grey.shade300;
        _iconColor = _focusNode.hasFocus ? ColorPalette().bigIcon : Colors.grey;
      });
    });
    this.history = widget.history;
  }

  @override
  Widget build(BuildContext context) {
    print("ENTER CHAT BOT");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorPalette().bgColor,
        title: Text(
          widget.assistant.assistantName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ChatBotHistory(data: history),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                    focusNode: _focusNode,
                    controller: chatController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: _fillColor,
                        hintText: "Chat something with ${widget.assistant.assistantName}...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            print("sent message");
                            Message userMess = Message(
                              role: MessageRole.user, 
                              createdDate: DateTime.now().millisecondsSinceEpoch, 
                              content: chatController.value.text
                            ); 
                            addMessageToHistory(userMess);
                            // var response = await ChatBotManager().getReponseMessageFromBot(widget.assistant, chatController.value.text);
                            Message assisMess = Message(
                              role: MessageRole.assistant, 
                              createdDate: DateTime.now().millisecondsSinceEpoch, 
                              content: await ChatBotManager().getReponseMessageFromBot(widget.assistant, chatController.value.text)
                            );
                            addMessageToHistory(assisMess);
                          },
                          icon: Icon(
                            Icons.send,
                            color: _iconColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorPalette().bigIcon),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
