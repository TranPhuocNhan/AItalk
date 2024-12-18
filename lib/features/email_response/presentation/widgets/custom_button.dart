import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/email_response/data/email_style_manager.dart';
import 'package:flutter_ai_app/utils/email_response_style.dart';
import 'package:flutter_ai_app/features/email_response/presentation/providers/email_style_provider.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatefulWidget {
  late String title;
  late IconData? icon = null;
  late EmailResponseStyle type = EmailResponseStyle.LENGTH;
  late int position ;
  CustomButton({
    required String content, 
    required IconData? ic,
    required EmailResponseStyle type,
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
  late EmailResponseStyle type;
  late int position;
  @override
  void initState() {
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
    listData = EmailStyleManager().getEmailResponseType(styleManage, type);
    
    return OutlinedButton(
      onPressed: (){
        EmailStyleManager().getAndUpdateEmailResponseStyle(styleManage, type, position);
      }, 
      child: (icon != null) ?
        Row(
          children: [
            Icon(icon),
            Text(
              title,
              style: TextStyle(
                color: listData[position] ? Colors.black : Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ) :
        Text(
          title,
          style: TextStyle(
            color: listData[position] ? Colors.black : Colors.grey,
            fontSize: 13
          ),
        ),
      style: OutlinedButton.styleFrom(
        backgroundColor: listData[position] ? ColorPalette().iconColor.withOpacity(0.5) : Colors.grey.shade100,
        side: BorderSide(
          color: listData[position] ? ColorPalette().iconColor : Colors.grey,
        )
      ),
    );
  }

}
