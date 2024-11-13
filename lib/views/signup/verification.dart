import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';

class VerificationScreen extends StatefulWidget{
  late BuildContext verContext;
  VerificationScreen({
    required BuildContext context,
  }){
    this.verContext = context;
  }
  @override
  State<StatefulWidget> createState() => _VerificationState();
}

class _VerificationState extends State<VerificationScreen>{
  late BuildContext verContext;
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.verContext = widget.verContext;
  }

  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette().bgColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text(
                "Verification",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette().headerColor
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "Please check your email to get OTP code",
              ),
              SizedBox(height: 80,),
              
              // OPT 
              Container(
                height: 70,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.all(5),
                      width: 60,
                      child: TextField(
                        controller: controllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette().iconColor,
                            )
                          )
                        ),
                        onChanged: (value){
                          if(value.isNotEmpty){
                            if(index < 5){
                              FocusScope.of(context).nextFocus();
                            }
                          }else{
                            if(index > 0){
                              FocusScope.of(context).previousFocus();
                            }
                          }
                        },
                      ),
                    );
                  }
              ),
              ),  
              SizedBox(height: 50,),
              //BUTTON CONFIRM 
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 50),
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.sizeOf(verContext).width * 2 / 3,
                  child: ElevatedButton(
                    onPressed: (){}, 
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette().btnColor,
                    ),
                    
                  ),
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
  
}