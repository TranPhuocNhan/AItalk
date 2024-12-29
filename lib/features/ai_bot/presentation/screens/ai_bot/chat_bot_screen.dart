import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/message.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_bot/data/chat_bot_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/publish_item.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/widgets/ai_bot/chat_bot_history.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:flutter_ai_app/utils/message_role_enum.dart';
import 'package:get_it/get_it.dart';

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

  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  TextEditingController chatController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ScrollController historyControler = ScrollController();
  
  Color _fillColor = Colors.grey.shade300;
  Color _iconColor = Colors.grey;
  late List<Message> history;
  bool _isAnswering = false;




  List<PublishItem> publishData = generateSampleData();
  static List<PublishItem> generateSampleData(){
    List<PublishItem> output = [
      new PublishItem(imgLink: "assets/images/telegram.png", name: "Telegram"),
      new PublishItem(imgLink: "assets/images/slack.png", name: "Slack"),
      new PublishItem(imgLink: "assets/images/messenger.png", name: "Messenger"),
    ];
    return output;
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
  void updateControler(){
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_){
      if(historyControler.hasClients){
        historyControler.jumpTo(historyControler.position.maxScrollExtent);
      }
    });
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
    _isAnswering = false;
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          PopupMenuButton<String>(
            icon: Row(
              children: [
                Icon(Icons.publish_rounded),
                SizedBox(width: 10,),
                Text("Publish"),
              ],
            ),
            itemBuilder: (BuildContext context){
              return[
                PopupMenuItem(
                  value: "telegram",
                  child: Row(
                    children: [
                      Image.asset(publishData[0].imgLink),
                      const SizedBox(width: 10,),
                      Text(publishData[0].name),
                    ],
                  )
                ),
                PopupMenuItem(
                  value: "slack",
                  child: Row(
                    children: [
                      Image.asset(publishData[1].imgLink),
                      const SizedBox(width: 10,),
                      Text(publishData[1].name),
                    ],
                  )
                ),
                PopupMenuItem(
                  value: "messenger",
                  child: Row(
                    children: [
                      Image.asset(publishData[2].imgLink),
                      const SizedBox(width: 10,),
                      Text(publishData[2].name),
                    ],
                  )
                ),
              ];
            },
            onSelected: (value) async{
              // try{
              //   String link = await ChatBotManager().handlePublishValue(value, widget.assistant.id);
              //   if(link != ""){
              //     showRedirectDialog(link);
              //   }
              // }catch(err){
              //   HelperFunctions().showMessageDialog("Publish to ${value}", err.toString(), context);
              // }
              
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ChatBotHistory(data: history, controller: historyControler),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _isAnswering ? Text("Answering..."): SizedBox(),
                ],
              ),
              SizedBox(height: 10,),
              //TEXT FIELD AREA 
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
                            updateAnswerState(true);
                            Message userMess = Message(
                              role: MessageRole.user, 
                              createdDate: DateTime.now().millisecondsSinceEpoch, 
                              content: chatController.value.text
                            ); 
                            addMessageToHistory(userMess);
                            updateControler();
                            // var response = await ChatBotManager().getReponseMessageFromBot(widget.assistant, chatController.value.text);
                            Message assisMess = Message(
                              role: MessageRole.assistant, 
                              createdDate: DateTime.now().millisecondsSinceEpoch, 
                              content: await ChatBotManager().getResponseMessageFromBot(widget.assistant, chatController.value.text, widget.assistant.openAiThreadIdPlay)
                            );
                            chatController.clear();
                            addMessageToHistory(assisMess);
                            updateControler();
                            updateAnswerState(false);
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

  void showRedirectDialog(String url){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Publication Submitted"),
          content: Text(url),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async{
                try{
                  Navigator.pop(context);
                  // ChatBotManager().launchUrl(url);
                  ChatBotManager().launchUrl1(url);
                }catch(err){
                  HelperFunctions().showSnackbarMessage(err.toString(), context);
                }
              }, 
              child: Text("Open"),
            ),
          ],
        );
      },
    );
  }


}
