import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/utils/email_response_style.dart';
import 'package:flutter_ai_app/features/email_response/presentation/email_style_provider.dart';
import 'package:flutter_ai_app/utils/formality_enum.dart';
import 'package:flutter_ai_app/utils/length_enum.dart';
import 'package:flutter_ai_app/utils/tone_enum.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/views/email_response/custom_button.dart';
import 'package:flutter_ai_app/views/email_response/custom_title.dart';
import 'package:provider/provider.dart';

class CustomMailDialog extends StatefulWidget {
  final Length originLength;
  final Formality originFormality;
  final Tone originTone;
  CustomMailDialog({
    required this.originLength,
    required this.originFormality,
    required this.originTone,
  });
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
                  const SizedBox(width: 10,),
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
                      styleManage.resetOriginValue(widget.originLength, widget.originFormality, widget.originTone);
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(Icons.close)
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 10,),
              CustomTitle(data: "Length", icon: Icons.featured_play_list_outlined),
              // group length item 
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(content: "Short", ic: null, type: EmailResponseStyle.LENGTH, position: 0),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Medium", ic: null, type: EmailResponseStyle.LENGTH, position: 1),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Long", ic: null, type: EmailResponseStyle.LENGTH, position: 2),
                ],
              ),
              const SizedBox(height: 20,),
              CustomTitle(data: "Formality", icon: Icons.playlist_add_check_circle_outlined),
              Row(
                children: [
                  CustomButton(content: "Casual", ic: null, type: EmailResponseStyle.FORMALITY, position: 0),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Neutral", ic: null, type: EmailResponseStyle.FORMALITY, position: 1),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Formal", ic: null, type: EmailResponseStyle.FORMALITY, position: 2),
                  const SizedBox(width: 10,),
                ],
              ),
              const SizedBox(height: 20,),
              CustomTitle(data: "Tone", icon: Icons.tag_faces_sharp),
              Row(
                children: [
                  CustomButton(content: "Witty", ic: null, type: EmailResponseStyle.TONE, position: 0),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Empathetic", ic: null, type: EmailResponseStyle.TONE, position: 1),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Personable", ic: null, type: EmailResponseStyle.TONE, position: 2),
                  const SizedBox(width: 10,),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  CustomButton(content: "Concerned", ic: null, type: EmailResponseStyle.TONE, position: 3),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Friendly", ic: null, type: EmailResponseStyle.TONE, position: 4),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Direct", ic: null, type: EmailResponseStyle.TONE, position: 5),
                  const SizedBox(width: 10,),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  CustomButton(content: "Sincere", ic: null, type: EmailResponseStyle.TONE, position: 6),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Optimistic", ic: null, type: EmailResponseStyle.TONE, position: 7),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Confident", ic: null, type: EmailResponseStyle.TONE, position: 8),
                  const SizedBox(width: 10,),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  CustomButton(content: "Informational", ic: null, type: EmailResponseStyle.TONE, position: 9),
                  const SizedBox(width: 10,),
                  CustomButton(content: "Enthusiastic", ic: null, type: EmailResponseStyle.TONE, position: 10),
                  const SizedBox(width: 10,),
                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette().iconColor,
                      
                    ),
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