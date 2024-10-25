import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/EmailResponse/test_data.dart';

class CardBoxChat extends StatefulWidget{
  late TestEmail data;
  CardBoxChat({
    required TestEmail data,
  }){
    this.data = data;
  }
  @override
  State<StatefulWidget> createState() => _CardBoxChatState();
}

class _CardBoxChatState extends State<CardBoxChat>{
  late TestEmail data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.data = widget.data;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: (data.type == TypeSender.SYSTEM) ? Colors.blue.shade50 : Colors.blueGrey.shade100,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Divider(),
            Text(
              data.content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                
              ),
            )
          ],
        ),
      ),
    );
  }
}