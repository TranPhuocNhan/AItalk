import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/ai_bot/ai_%20bot.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';

class ChatBotScreen extends StatefulWidget{
  final AiBot data;
  ChatBotScreen({
    required this.data,
  });
  @override
  State<StatefulWidget> createState() => _chatBotState();
  
}

class _chatBotState extends State<ChatBotScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       backgroundColor: ColorPalette().bgColor,
        title: Text(
          widget.data.assistantName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),  
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),

        ),
      ),
    );
  }
  
}