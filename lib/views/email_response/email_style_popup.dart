import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/utils/providers/email_style_provider.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';
import 'package:flutter_ai_app/views/email_response/custom_button.dart';
import 'package:flutter_ai_app/views/email_response/custom_title.dart';
import 'package:provider/provider.dart';

class CustomMailDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomMailDialogState();
}

class _CustomMailDialogState extends State<CustomMailDialog>{
  @override
  Widget build(BuildContext context) {
    final styleManage = Provider.of<EmailStyleProvider>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child:Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/logo_icon.png",
                    width: 25,
                    height: 25,  
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Text(
                      "Email Style",
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorPalette().iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      styleManage.updateIsApply(false);
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.close)
                  )
                ],
              ),
              Divider(),
              SizedBox(height: 10,),
              CustomTitle(data: "Length", icon: Icons.featured_play_list_outlined),
              // group length item 
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(content: "Short", ic: null, type: StyleType.LENGTH, position: 0),
                  SizedBox(width: 10,),
                  CustomButton(content: "Medium", ic: null, type: StyleType.LENGTH, position: 1),
                  SizedBox(width: 10,),
                  CustomButton(content: "Length", ic: null, type: StyleType.LENGTH, position: 2),
                ],
              ),
              SizedBox(height: 20,),
              CustomTitle(data: "Formality", icon: Icons.playlist_add_check_circle_outlined),
              Row(
                children: [
                  CustomButton(content: "Casual", ic: null, type: StyleType.FORMALITY, position: 0),
                  SizedBox(width: 10,),
                  CustomButton(content: "Neutral", ic: null, type: StyleType.FORMALITY, position: 1),
                  SizedBox(width: 10,),
                  CustomButton(content: "Formal", ic: null, type: StyleType.FORMALITY, position: 2),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 20,),
              CustomTitle(data: "Tone", icon: Icons.tag_faces_sharp),
              Row(
                children: [
                  CustomButton(content: "Witty", ic: null, type: StyleType.TONE, position: 0),
                  SizedBox(width: 10,),
                  CustomButton(content: "Empathetic", ic: null, type: StyleType.TONE, position: 1),
                  SizedBox(width: 10,),
                  CustomButton(content: "Personable", ic: null, type: StyleType.TONE, position: 2),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  CustomButton(content: "Concerned", ic: null, type: StyleType.TONE, position: 3),
                  SizedBox(width: 10,),
                  CustomButton(content: "Friendly", ic: null, type: StyleType.TONE, position: 4),
                  SizedBox(width: 10,),
                  CustomButton(content: "Direct", ic: null, type: StyleType.TONE, position: 5),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  CustomButton(content: "Sincere", ic: null, type: StyleType.TONE, position: 6),
                  SizedBox(width: 10,),
                  CustomButton(content: "Optimistic", ic: null, type: StyleType.TONE, position: 7),
                  SizedBox(width: 10,),
                  CustomButton(content: "Confident", ic: null, type: StyleType.TONE, position: 8),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  CustomButton(content: "Informational", ic: null, type: StyleType.TONE, position: 9),
                  SizedBox(width: 10,),
                  CustomButton(content: "Enthusiastic", ic: null, type: StyleType.TONE, position: 10),
                  SizedBox(width: 10,),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      styleManage.updateIsApply(true);
                      Navigator.pop(context);
                    }, 
                    child: Text(
                      "Apply",
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}