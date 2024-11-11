import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';

class VerifyEmailScreen extends StatefulWidget{
  late BuildContext verContext;
  late String sendEmail;
  VerifyEmailScreen({required BuildContext context, required email}){
    this.verContext = context;
    this.sendEmail = email;
  }
  @override
  State<StatefulWidget> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailScreen>{
  late BuildContext verContext;
  late String sentEmail ;
  List<TextEditingController> controllers = List.generate(4, (index) => TextEditingController());
  final colorElements = <Color>[ColorPalette().startLinear, ColorPalette().endLinear];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verContext = widget.verContext;
    sentEmail = widget.sendEmail;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(
          "Verify Email",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              //IMAGE 
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette().startLinear.withOpacity(0.1)
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      child: Icon(
                        Icons.mark_email_read_rounded,
                        color: ColorPalette().endLinear,
                        size: 100,  
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50,),
              // TEXT INFORM
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  "Please enter the 4 digits code send to $sentEmail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              //ENTER OPT AREA 
              Container(
                height: 70,
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(4,(index){
                    return Container(
                      padding: EdgeInsets.all(10),
                      width: 80,
                      child: TextField(
                        controller: controllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorPalette().btnColor,
                            )
                          )
                        ),
                        onChanged: (value){
                          if(value.isNotEmpty){
                            if(index < 3){
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
                  } ),
                )
              ),
              SizedBox(height: 30,),
              //BUTTON CONFIRM 
              Container(
                margin: EdgeInsets.only(top: 30),
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
                      Navigator.pushNamed(context, '/changePass');
                    }, 
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
                      backgroundColor: Colors.transparent,
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
