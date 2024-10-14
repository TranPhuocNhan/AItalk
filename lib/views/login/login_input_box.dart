import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginInputBox extends StatelessWidget{
  String content = "";
  IconData preIcon = Icons.hourglass_empty;
  Color mainColor = Colors.white;
  late TextEditingController controller;
  late GlobalKey<FormState> key;
  LoginInputBox({
    required String input,
    required IconData pre,
    required Color color,
    required TextEditingController ctr,
    required GlobalKey<FormState> key,
  }){
    this.content = input;
    this.preIcon = pre;
    this.mainColor = color;
    this.controller = ctr;
    this.key = key;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Form(
        key: key,
        child: TextFormField(
          controller: controller,
          validator: (value){
            if(value!.isEmpty){
              return "You must enter a value in this field";
            }
          },
          decoration: InputDecoration(
            label: Text(content),
            prefixIcon: Icon(preIcon, color: mainColor,),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: mainColor,
              )
            ),
            enabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              )
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              )
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              )
            ),
            
          ),
        ),
      )
    );
  }

}