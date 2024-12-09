import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/utils/providers/email_style_provider.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatefulWidget {
  late String title;
  late IconData? icon = null;
  late StyleType type = StyleType.LENGTH;
  late int position ;
  CustomButton({
    required String content, 
    required IconData? ic,
    required StyleType type,
    required int position,
  }){
    this.title = content;
    this.icon = ic;
    this.type = type;
    this.position = position;
  }
  @override
  State<StatefulWidget> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>{
  late String title;
  late IconData? icon; 
  late StyleType type;
  late int position;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.title = widget.title;
    this.icon = widget.icon;
    this.type = widget.type;
    this.position = widget.position;
  }
  @override
  Widget build(BuildContext context) {
    final styleManage = Provider.of<EmailStyleProvider>(context);
    List<bool> listData;
    switch(type){
      case StyleType.LENGTH:{
        listData = styleManage.getListLength();
        break;
      }
      case StyleType.FORMALITY: {
        listData = styleManage.getListFormality();
        break;
      }
      case StyleType.TONE:{
        listData = styleManage.getListTone();
        break;
      }
      default:{
        listData = styleManage.getListLength();
        break;
      }
    }
    return OutlinedButton(
      onPressed: (){
        switch(type){
          case StyleType.LENGTH: {
            styleManage.updateListLength(position);
            listData = styleManage.getListLength();
            break;
          }
          case StyleType.FORMALITY: {
            styleManage.updateListFormality(position);
            listData = styleManage.getListFormality();
            break;
          }
          case StyleType.TONE: {
            styleManage.updateListTone(position);
            listData = styleManage.getListTone();
            break;
          }
          default: {
            break;
          }
        }
      }, 
      child: (icon != null) ?
        Row(
          children: [
            Icon(icon),
            Text(
              title,
              style: TextStyle(
                color: listData[position] ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ) :
        Text(
          title,
          style: TextStyle(
            color: listData[position] ? Colors.black : Colors.grey,
          ),
        ),
      // child: Row(
      //   children: [
      //     Icon(icon),
      //   ],
      // ),
      style: OutlinedButton.styleFrom(
        backgroundColor: listData[position] ? ColorPalette().iconColor.withOpacity(0.5) : Colors.grey.shade100,
        side: BorderSide(
          color: listData[position] ? ColorPalette().iconColor : Colors.grey,
        )
      ),
    );
  }

}

enum StyleType{
  LENGTH,
  FORMALITY,
  TONE,
}