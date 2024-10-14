import 'package:flutter/material.dart';

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
  // final TextEditingController controller = TextEditingController();
  // final GlobalKey<FormState> formkey = GlobalKey<FormState>();
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
            if(content == "Confirm Password"){
              if(controller.value.text != compare?.value.text){
                return "Password do not match";
              }
            }
            return null;
          },
          decoration: InputDecoration(
            label: Text(content),
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
        ),
      )
    );
  }
  
}

// class SignupInputBox extends StatelessWidget{
//   late String content;
//   late Color mainColor; 
//   SignupInputBox({
//     required String data,
//     required Color color,
//   }){
//     this.mainColor = color;
//     this.content = data;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 5, bottom: 5),
//       child: TextFormField(
//         decoration: InputDecoration(
//           label: Text(content),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: mainColor,
//             )
//           ),
//           enabledBorder:  OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.black,
//             )
//           ),
//         ),
//       ),
//     );
//   }
  
// }