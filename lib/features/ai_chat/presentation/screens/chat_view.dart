import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/assistant_manager.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/ai_search_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/ai_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/chat_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/free_unlimited_section.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/tools_section.dart';

class ChatView extends StatefulWidget {
  ChatView({super.key});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with AutomaticKeepAliveClientMixin<ChatView> {
  @override
  bool get wantKeepAlive => true;
  List<AiBot> bots = [];

  late Function (bool, Assistant) onUpdate;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleGetAiBot();
    onUpdate = (bool value, Assistant assistant){
      if(value){
        print("ENTER ON UPDATE AT CHAT VIEW");
      }
    };
  }

  void handleGetAiBot() async{
    List<AiBot> data = await AsisstantManager().getAiBots();
    setState(() {
      bots = data;
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print("ChatView build...");
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting section
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.waving_hand_outlined)),
                const SizedBox(height: 10),
                const Text(
                  "Hello Welcome to AiChat",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                AISection(),
                AISearchSection(),
                FreeUnlimitedSection(),
                ToolsSection(bots: bots, onUpdate: onUpdate,),
                ChatSection(bots: bots,),
              ],
            ),
          ),
        ),
        // Right sidebar
      ],
    );
  }
}
