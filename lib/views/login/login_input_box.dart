import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginInputBox extends StatefulWidget{
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
  State<StatefulWidget> createState() => _LoginInputBoxState();
}

class _LoginInputBoxState extends State<LoginInputBox>{
  late String content;
  late IconData preIcon;
  late Color mainColor;
  late TextEditingController controller;
  late GlobalKey<FormState> key;
  
  @override
  void initState() {
    super.initState();
    this.content = widget.content;
    this.preIcon = widget.preIcon;
    this.mainColor = widget.mainColor;
    this.controller = widget.controller;
    this.key = widget.key;
  }
  bool isVisibility = false;
  String? _validate(String? value){
    if(value!.isEmpty){
      return "You must enter a value in this field";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Form(
        key: key,
        child: TextFormField(
          controller: controller,
          validator: _validate,
          decoration: InputDecoration(
            label: Text(content),
            prefixIcon: Icon(preIcon, color: mainColor,),
            suffixIcon: (content == "Password") ? (
              IconButton(
                onPressed: (){
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                }, 
                icon: ((!isVisibility)? Icon(Icons.visibility_off, color: mainColor,) : Icon(Icons.visibility,color: mainColor,)))
            ) : null,
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
          keyboardType: TextInputType.visiblePassword,
          obscureText: (content == "Password") ? !isVisibility : false,
        ),
      )
    );
  }
}
  

