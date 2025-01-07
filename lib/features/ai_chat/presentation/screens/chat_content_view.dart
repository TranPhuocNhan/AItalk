import 'dart:convert';

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
import 'package:flutter_ai_app/features/ai_chat/presentation/widgets/tools_section.dart';
import 'package:flutter_ai_app/features/profile/presentation/providers/manage_token_provider.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
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
  ScrollController _defaultHitoryController = ScrollController();
  bool _isAnswering = false;
  AiBotService aiBotService = GetIt.instance<AiBotService>();
  bool isReadingHistory = false;

  Color _fillColor = Colors.grey.shade300;
  Color _iconColor = Colors.grey;
  final FocusNode _focusNode = FocusNode();

  late Function(bool, Assistant) onUpdate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleGetAiBot();
    if (!widget.assistant.isDefault) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        readingHistoryMessage();
      });
    }
    // handle scroll message in default bot
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).addListener(() {
        _scrollToBottom();
      });
    });

    onUpdate = (bool value, Assistant assistant) async {
      if (value) {
        if (assistant.isDefault) {
          final chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          final tokenProvider =
              Provider.of<Managetokenprovider>(context, listen: false);
          int remain = await chatProvider.sendFirstMessage(ChatMessage(
              assistant: AssistantDTO(
                  id: chatProvider.selectedAssistant.id,
                  model: 'dify',
                  name: chatProvider.selectedAssistant.name),
              role: "user",
              content: "new chat"));
          tokenProvider.updateRemainToken(remain);
          _controller.clear();
          Navigator.pop(context);
          // Chuyển hướng đến ChatContentView
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatContentView(
                      assistant: chatProvider.selectedAssistant,
                    )),
          );
        } else {
          BotThread thread = await aiBotService.createNewThread(
              assistant.id, "${DateTime.now()}");
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatContentView(
                        assistant: assistant,
                        thread: thread,
                        bots: bots,
                      )));
        }
        // open new chat
      }
    };
    //handle UI related textfield
    _focusNode.addListener(() {
      setState(() {
        _fillColor = _focusNode.hasFocus ? Colors.white : Colors.grey.shade300;
        _iconColor = _focusNode.hasFocus ? ColorPalette().bigIcon : Colors.grey;
      });
    });
  }

  void _scrollToBottom() {
    if (_defaultHitoryController.hasClients) {
      _defaultHitoryController.animateTo(
          _defaultHitoryController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final tokenProvider =
        Provider.of<Managetokenprovider>(context, listen: false);

    _listConversationContent = chatProvider.listConversationContent;
    return Scaffold(
      appBar: AppBar(
        title: (!isDefaultBot() ? Text(widget.thread!.threadName) : SizedBox()),
      ),
      body: Column(
        children: [
          (isDefaultBot())
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: chatProvider.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _buildMessageList(chatProvider),
                  ),
                )
              : Expanded(
                  child: (isReadingHistory)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ChatBotHistory(
                          data: history, controller: historyControler)),
          !isDefaultBot()
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    _isAnswering ? Text("Answering...") : SizedBox()
                  ],
                )
              : SizedBox(),
          ToolsSection(
            bots: bots,
            onUpdate: onUpdate,
          ),
          _buildInputArea(chatProvider, tokenProvider),
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
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomeView()),
            // );
            Navigator.pop(context, 0);
            print("New Chat is clicked! - Back to Home Screen");
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
      controller: _defaultHitoryController,
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

  Widget _buildInputArea(
      ChatProvider chatProvider, Managetokenprovider tokenProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          PopupMenuButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onSelected: (value) {
                if (value == 'Add') {
                  chatProvider.newChat();
                  Navigator.pop(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'Add',
                      child: Text("New Chat"),
                    ),
                  ]),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: _fillColor,
                  hintText: "Chat anything with AiTalk...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      //handle send message with default bot
                      if (widget.assistant.isDefault) {
                        try {
                          await chatProvider.sendMessage(
                              _controller.text, tokenProvider, context);
                          _controller.clear();
                        } catch (err) {
                          HelperFunctions().showMessageDialog(
                            "Failed Send Message",
                            err.toString(),
                            context,
                          );
                        }
                        _controller.clear();
                      } // handle send message with personal bot
                      else {
                        updateAnswerState(true);
                        Message userMess = Message(
                          role: MessageRole.user,
                          createdDate: DateTime.now().millisecondsSinceEpoch,
                          content: _controller.value.text,
                        );
                        addMessageToHistory(userMess);
                        if (history.length > 1) updateControler();
                        String assistantId = chatProvider.selectedAssistant.id;
                        String tempMesssage = _controller.value.text;
                        _controller.clear();
                        Message assisMess = Message(
                            role: MessageRole.assistant,
                            createdDate: DateTime.now().millisecondsSinceEpoch,
                            content: await ChatBotManager()
                                .getResponseMessageFromBot(
                              AsisstantManager()
                                  .findBotFromListData(this.bots, assistantId)!,
                              tempMesssage,
                              widget.thread!.threadId,
                            ));
                        addMessageToHistory(assisMess);
                        updateControler();
                        updateAnswerState(false);
                      }
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
    );
  }

  void updateControler() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (historyControler.hasClients) {
          historyControler.jumpTo(historyControler.position.maxScrollExtent);
        }
      });
    });
  }

  void updateListHistory(List<Message> update) {
    setState(() {
      history = update;
    });
  }

  void addMessageToHistory(Message mess) {
    setState(() {
      history.add(mess);
    });
  }

  void updateAnswerState(bool value) {
    setState(() {
      _isAnswering = value;
    });
  }

  void handleGetAiBot() async {
    List<AiBot> data = await AsisstantManager().getAiBots();
    setState(() {
      bots = data;
    });
  }

  bool isDefaultBot() {
    return widget.assistant.isDefault;
  }

  void readingHistoryMessage() async {
    setState(() {
      isReadingHistory = true;
    });
    history =
        await AsisstantManager().readingHistoryForPersonalBot(widget.thread!);
    history = history.reversed.toList();
    if (widget.bots == null) {
      bots = await AsisstantManager().getAiBots();
    }
    setState(() {
      isReadingHistory = false;
    });
  }
}
