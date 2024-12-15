import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/ai_bot/message.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/utils/message_role_enum.dart';
import 'package:http/http.dart';

class ChatBotHistory extends StatefulWidget{
  final List<Message> data;
  ChatBotHistory({
    required this.data,
  });
  @override
  State<StatefulWidget> createState() => _chatBotHistoryState();
}

class _chatBotHistoryState extends State<ChatBotHistory>{
  late List<Message> data;
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    this.data = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((_){
      print("ENTER SCROLL");
      if(_scrollController.hasClients){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return ListView.builder(
      controller: _scrollController,
      itemCount: data.length,
      itemBuilder: (context, index){
        return Row(
          mainAxisAlignment: data[index].role == MessageRole.user ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            data[index].role == MessageRole.user ? 
            //USER MESSAGE
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      // maxWidth: screenSize.width - 180,
                      maxWidth: screenSize.width - 120,
                    ),
                    child: Text(
                      data[index].content,
                      style: TextStyle(
                        // overflow: OverF
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorPalette().bgColor,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      child: Icon(Icons.person),
                    ),  
                  )
                ],
              )
            :
            // ASSISTANT RESPONSE 
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: CircleAvatar(
                    child: Icon(Icons.adb),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    // maxWidth: screenSize.width - 180,
                    maxWidth: screenSize.width - 120,
                  ),
                  child: Text(
                    data[index].content,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorPalette().bgColor,
                  ),
                ),
              ],
            ),
         ], 
        );
      },
    );
  }
  
}