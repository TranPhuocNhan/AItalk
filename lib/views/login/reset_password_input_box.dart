import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/style/Color.dart';

class ResetInputBox extends StatefulWidget{
  late TextEditingController resetController ;
  late GlobalKey<FormState> resetKey;
  late String resetContent;
  late TextEditingController? compareController;
  ResetInputBox({
    required String input,
    required TextEditingController controller,
    required GlobalKey<FormState> key,
    TextEditingController? compare,
  }){
    this.resetContent = input;
    this.resetController = controller;
    this.resetKey = key;
    this.compareController = compare;
  }
  @override
  State<StatefulWidget> createState() => _ResetInputState();
}

class _ResetInputState extends State<ResetInputBox>{
  late TextEditingController resetController ;
  late GlobalKey<FormState> resetKey;
  late String resetContent;
  TextEditingController? compareController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.resetContent = widget.resetContent;
    this.resetController = widget.resetController;
    this.resetKey = widget.resetKey;
    this.compareController = widget.compareController;

  }

  bool isVisibility = false;

  String? _validatePassword(String? value){
    if(value!.isEmpty){
      return "You must enter a value in this field";
    }
    if(resetContent.contains("Confirm")){
      if(value != compareController!.value.text){
        return "Password do not match";
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 30),
      child: Form(
        key: resetKey,
        child: TextFormField(
          controller: resetController,
          validator: _validatePassword,
          decoration: InputDecoration(
            label: Text(resetContent),
            suffixIcon: IconButton(
              onPressed: (){
                setState(() {
                  isVisibility = !isVisibility;
                });
              },
              icon: (!isVisibility ? Icon(Icons.visibility_off, color: ColorPalette().btnColor,) : Icon(Icons.visibility, color: ColorPalette().btnColor,))),
            focusColor: ColorPalette().btnColor,
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: !isVisibility,
        ),
      ),
    );

  }
  
}