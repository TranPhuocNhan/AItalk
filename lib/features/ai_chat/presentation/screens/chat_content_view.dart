import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_bot/data/chat_bot_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/bot_thread.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/message.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/widgets/ai_bot/chat_bot_history.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/assistant_manager.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/conversation.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_view.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/tools_section.dart';
import 'package:flutter_ai_app/utils/message_role_enum.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatContentView extends StatefulWidget {
  final Assistant assistant;
  List<AiBot>? bots = null;
  BotThread? thread;
  ChatContentView({
    super.key,
    required this.assistant,
    this.bots,
    this.thread,
  });


  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class _ChatContentViewState extends State<ChatContentView> {
  final TextEditingController _controller = TextEditingController();
  List<Conversation>? _listConversationContent;
  final String logoPath = 'assets/images/logo_icon.png';
  List<AiBot> bots = [];
  List<Message> history = [];
  ScrollController historyControler = ScrollController();
  bool _isAnswering = false;
  AiBotService aiBotService = GetIt.instance<AiBotService>();
  bool isReadingHistory = false;

  late Function (bool, Assistant) onUpdate;

  void readingHistoryMessage() async{
    setState(() {
      isReadingHistory = true;
    });
    history = await AsisstantManager().readingHistoryForPersonalBot(widget.thread!);
    history = history.reversed.toList();
    if(widget.bots == null ){
      bots = await AsisstantManager().getAiBots();
    }
    setState(() {
      isReadingHistory = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleGetAiBot();
    if(!widget.assistant.isDefault){
      WidgetsBinding.instance.addPostFrameCallback((_){
        readingHistoryMessage();
      });
    }
    onUpdate = (bool value, Assistant assistant) async{
      if(value){
        if(assistant.isDefault){
          final chatProvider = Provider.of<ChatProvider>(context, listen: false);
          await chatProvider.sendFirstMessage(ChatMessage(
            assistant: AssistantDTO(
              id: chatProvider.selectedAssistant.id,
              model: 'dify',
              name: chatProvider.selectedAssistant.name
             ), 
            role: "user", content: "new chat"
          ));
          _controller.clear(); 
          Navigator.pop(context);
          // Chuyển hướng đến ChatContentView
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatContentView(assistant:  chatProvider.selectedAssistant,)),
          );
        }else{
          BotThread thread = await aiBotService.createNewThread(assistant.id, "${DateTime.now()}");
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatContentView(assistant: assistant, thread: thread, bots: bots,)));
        }
        // open new chat
      }
    };
  }
  void updateControler(){
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_){
        if(historyControler.hasClients){
          historyControler.jumpTo(historyControler.position.maxScrollExtent);
        }
      });
    });
  }
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
  void updateAnswerState(bool value){
    setState(() {
      _isAnswering = value;
    });
  }
  
  void handleGetAiBot() async{
    List<AiBot> data = await AsisstantManager().getAiBots();
    setState(() {
      bots = data;
    });
  }
  bool isDefaultBot(){
    return widget.assistant.isDefault;
  }
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    _listConversationContent = chatProvider.listConversationContent;
    return Scaffold(
      appBar: AppBar(
        title: (!isDefaultBot() ? Text(widget.thread!.threadName) : SizedBox()),
      ),
      body: Column(
        children: [
          (isDefaultBot()) ? 
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: chatProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildMessageList(chatProvider),
            ),
          ) : 
          Expanded(
            child: (isReadingHistory) ? Center(child: CircularProgressIndicator(),) : 
              ChatBotHistory(data: history, controller: historyControler)
          ),
          !isDefaultBot() ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5,),
              _isAnswering ? Text("Answering...") : SizedBox()
            ],
          ) : SizedBox(),
          ToolsSection(bots: bots, onUpdate: onUpdate,),
          _buildInputArea(chatProvider),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black45,
      actions: [
        const Icon(Icons.whatshot, color: Colors.orange),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Text('29', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            // print("New Chat is clicked! - Back to Home Screen");
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  Widget _buildMessageList(ChatProvider chatProvider) {
    if (_listConversationContent == null || _listConversationContent!.isEmpty) {
      return Center(child: Text("...Loading..."));
    }

    return ListView.builder(
      itemCount: _listConversationContent?.length ?? 0,
      itemBuilder: (context, index) {
        return _buildChatItem(index, chatProvider);
      },
    );
  }

  Widget _buildChatItem(int index, ChatProvider chatProvider) {
    final conversation = _listConversationContent![index];
    final isPending = chatProvider.isMessagePending(conversation.query ?? "");

    return Column(
      children: [
        if (conversation.query != null)
          _buildMessageCard("You", conversation.query ?? "", true),
        if (isPending) _buildMessageCard("AiTalk", "Typing...", false),
        if (!isPending && conversation.answer != null)
          _buildMessageCard("AiTalk", conversation.answer ?? "", false),
      ],
    );
  }

  Widget _buildMessageCard(String role, String content, bool isUserMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage)
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Image.asset(
                logoPath,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Card(
              elevation: 4,
              color: isUserMessage ? Colors.grey[50] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUserMessage
                            ? Colors.blueAccent
                            : Colors.deepPurpleAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUserMessage) const SizedBox(width: 8),
          if (isUserMessage)
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          PopupMenuButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onSelected: (value) {
                if (value == 'Add') {
                  chatProvider.newChat();
                }
              },
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'Add',
                      child: Text("New Chat"),
                    ),
                    PopupMenuItem<String>(
                      child: Text("Record Voice"),
                    ),
                  ]),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Chat anything with AiTalk...",
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.grey),
            onPressed: () async {
              if(widget.assistant.isDefault){
                //handle send message with default bot 
                chatProvider.sendMessage(_controller.text);
                _controller.clear();
              }else{
                // handle send message with personal bot 
                updateAnswerState(true);
                Message userMess = Message(
                  role: MessageRole.user, 
                  createdDate: DateTime.now().millisecondsSinceEpoch, 
                  content: _controller.value.text,
                );
                addMessageToHistory(userMess);
                if(history.length > 1)
                  updateControler();
                String assistantId = chatProvider.selectedAssistant.id;
                Message assisMess = Message(
                  role: MessageRole.assistant, 
                  createdDate: DateTime.now().millisecondsSinceEpoch, 
                  content: await ChatBotManager().getResponseMessageFromBot(
                    AsisstantManager().findBotFromListData(this.bots, assistantId)!,
                    _controller.value.text,
                    widget.thread!.threadId,
                     )
                );
                _controller.clear();
                addMessageToHistory(assisMess);
                updateControler();
                updateAnswerState(false);
              }
            },
          ),
        ],
      ),
    );
  }
}
