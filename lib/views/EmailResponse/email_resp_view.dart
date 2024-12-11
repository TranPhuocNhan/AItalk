import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/EmailResponse/card_box_chat.dart';
import 'package:flutter_ai_app/views/EmailResponse/group_type_button.dart';
import 'package:flutter_ai_app/views/EmailResponse/response_type_dropdown.dart';
import 'package:flutter_ai_app/views/EmailResponse/test_data.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';

class EmailResponseScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EmailResponseState();
}

class _EmailResponseState extends State<EmailResponseScreen>{
  List<TestEmail> data = TestEmail.CreateSampleData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Email Response",
                style: TextStyle(
                  color: Colors.black
                ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              
            )
          ],
        ),
        // backgroundColor: ColorPalette().mainColor,
        backgroundColor: ColorPalette().bgColor,
        actions: [                
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ResponseTypeDropdown(),
          )
        ],
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index){
                  return CardBoxChat(data: data[index]);
                },  
              ),
              ),
            GroupTypeButton(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorPalette().bgColor,
                        hintText: "Tell us how you want to reply...",
                        border:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                       suffixIcon: IconButton(
                          onPressed: (){
                            print("sent message");
                          }, 
                          icon: Icon(Icons.send, color: ColorPalette().iconColor,),
                        ), 
                      ),
                      
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(selected: 1),
    );
  }
}


