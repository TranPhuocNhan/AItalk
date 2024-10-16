import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/style/Color.dart';

class SignupInputBox  extends StatefulWidget{
  late String content;
  late Color mainColor; 
  late TextEditingController controller;
  late GlobalKey<FormState> key;
  late String error;
  late TextEditingController? compare;
  SignupInputBox({
    required String data,
    required Color color,
    required TextEditingController controller,
    required GlobalKey<FormState> globalKey,
    required String errText,
    TextEditingController? compare,
  }){
    this.mainColor = color;
    this.content = data;
    this.controller = controller;
    this.key = globalKey;
    this.error = errText;
    this.compare = compare;
    
  }  
  @override
  State<StatefulWidget> createState() => _SignupInputBoxState();
  
}

class _SignupInputBoxState extends State<SignupInputBox>{
  late String content;
  late Color mainColor;
  late TextEditingController controller;
  late GlobalKey<FormState> key;
  late String txtError;
  TextEditingController? compare;

  @override
  void initState() {
    super.initState();
    content = widget.content;
    mainColor = widget.mainColor;
    controller = widget.controller;
    key = widget.key;
    txtError = widget.error;
    compare = widget.compare;
  }

  bool isVisibility = false;

  String? _validate(String? value){
    if(value!.isEmpty){
      return "You must enter a value in this field";
    }
    if(content == "Confirm Password"){
      if(controller.value.text != compare?.value.text){
        return "Password do not match";
      }
    }
    return null;
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
            suffixIcon: (content.contains("Password")) ? (
              IconButton(
                onPressed: (){
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                }, 
                icon: (isVisibility) ? Icon(Icons.visibility, color: ColorPalette().btnColor,) : Icon(Icons.visibility_off, color: ColorPalette().btnColor,))
            ) : null,
            helperText: (content.toString().contains("Password")) ? "Password must contain special character!" : null,
            helperStyle: TextStyle(
              fontSize: 10,
              color: Colors.green
            ),
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
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: (content.contains("Password")) ? !isVisibility : false,
        ),
      )
    );
  }
}
