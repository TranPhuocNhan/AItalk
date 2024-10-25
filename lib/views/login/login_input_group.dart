import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/style/Color.dart';

class LoginInputGroup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInputGroup>{
  final usernameKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];
  bool rememberCheck = false;

  bool isVisibility = false;
  String? _validate(String? value){
    if(value!.isEmpty){
      return "You must enter a value in this field";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //USERNAME TEXTFIELD
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: usernameKey,
            child: TextFormField(
              controller: usernameController,
              validator: _validate,
              decoration: InputDecoration(
                label: Text("Username"),
                prefixIcon: Icon(Icons.person, color: ColorPalette().btnColor,),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette().btnColor,
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
        ),

        //PASSWORD TEXTFIELD 
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Form(
            key: passwordKey,
            child: TextFormField(
              controller: passwordController,
              validator: _validate,
              decoration: InputDecoration(
                label: Text("Password"),
                prefixIcon: Icon(Icons.lock, color: ColorPalette().btnColor,),
                suffixIcon:(
                  IconButton(
                    onPressed: (){
                      setState(() {
                        isVisibility = !isVisibility;
                      });
                    }, 
                    icon: ((!isVisibility)? Icon(Icons.visibility_off, color: ColorPalette().btnColor,) : Icon(Icons.visibility,color: ColorPalette().btnColor,)))
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette().btnColor,
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
              obscureText:  !isVisibility ,
            ),
          )
        ),
        //

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: rememberCheck, 
                  onChanged:(value){
                    setState(() {
                      rememberCheck = !rememberCheck;
                    });
                  },
                ),
                Text("Remember Me"),
                ],
              ),
            TextButton(
              onPressed: (){
                Navigator.pushNamed(context, "/forgot");
              }, 
              child: Text(
                "Forgot Password",
                style: TextStyle(color: Colors.red),
              )
            )
          ],
        ),

        //BUTTON LOGIN 
        Container(
          margin: EdgeInsets.only(top: 30, bottom: 50),
          width: double.infinity,
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.sizeOf(context).width/2,
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              gradient: LinearGradient(
                colors: colorElements,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            ),
            child: ElevatedButton(
              onPressed: (){
                bool checkUsername = usernameKey.currentState!.validate();
                bool checkPassword = passwordKey.currentState!.validate();
                if(checkPassword && checkPassword){
                  //LOGIN EXISTS ACCOUNT 
                  //[...]
                  Navigator.pushNamed(context, '/profile');
                }
              }, 
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Login", 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                )
              ),
            )
        ),


      ],
    );
  }

}