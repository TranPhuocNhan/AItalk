import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/email_response/data/models/email_request.dart';
import 'package:flutter_ai_app/features/email_response/data/models/email_response.dart';
import 'package:flutter_ai_app/features/email_response/data/models/suggest_idea_request.dart';
import 'package:flutter_ai_app/features/email_response/data/services/email_response_service.dart';
import 'package:flutter_ai_app/features/profile/presentation/providers/manage_token_provider.dart';
import 'package:flutter_ai_app/utils/LanguageConverter.dart';
import 'package:flutter_ai_app/utils/email_response_converter.dart';
import 'package:flutter_ai_app/utils/email_response_type.dart';
import 'package:flutter_ai_app/utils/language_enum.dart';
import 'package:flutter_ai_app/features/email_response/presentation/providers/email_style_provider.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/features/email_response/presentation/screens/email_style_popup.dart';
import 'package:flutter_ai_app/features/email_response/presentation/widgets/show_dialog_support.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class EmailResponseScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EmailResponseState();
  
}

class _EmailResponseState extends State<EmailResponseScreen>{
  EmailResponseType emailType = EmailResponseType.ResponseEmail;
  final EmailResponseService emailResponseService = GetIt.instance<EmailResponseService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController mainIdeaController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Color _fillColor = Colors.grey.shade300;
  Color _iconColor = Colors.grey;
  var selectedLanguage = Language.Auto;


  List<DropdownMenuItem<Language>> buildDropDownMenuItems(){
    return Language.values.map((Language lang) => DropdownMenuItem<Language>( 
        value: lang,
        child: Text(LanguageConverter().Convert(lang)),
      )
    ).toList();  
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener((){
      setState(() {
        _fillColor = _focusNode.hasFocus ? Colors.white : Colors.grey.shade300;
        _iconColor = _focusNode.hasFocus ? ColorPalette().bigIcon : Colors.grey;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final styleManage = Provider.of<EmailStyleProvider>(context);
    final tokenManage = Provider.of<Managetokenprovider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          children: [
            const Text(
              "Email Response",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: ColorPalette().bgColor,
        leading: Builder(builder: (context){
          return IconButton(
            onPressed: (){
              Scaffold.of(context).openDrawer();
            }, 
            icon: const Icon(Icons.menu),
            color: Colors.black,
          );
        }),
      ),
      drawer: AppDrawer(selected: 1),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: size.width / 2 - size.width * 0.05,
                  child:  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        emailType = EmailResponseType.ResponseEmail;
                      });
                    }, 
                    child: const Text(
                      "Response Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: (emailType == EmailResponseType.ResponseEmail) ? ColorPalette().bigIcon : null ,
                      foregroundColor: (emailType == EmailResponseType.ResponseEmail) ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                ),
                Container(
                  width:  size.width / 2 - size.width * 0.05 ,
                  child: ElevatedButton(
                    onPressed: (){
                      setState(() {
                        emailType = EmailResponseType.RequestReplyIdeas;
                      });
                    }, 
                    child: const Text(
                      "Suggest Reply Ideas",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: (emailType == EmailResponseType.RequestReplyIdeas) ? ColorPalette().bigIcon : null,
                        foregroundColor: (emailType == EmailResponseType.RequestReplyIdeas) ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                ),
              ],
            ),
            //input email area 
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //header input
                    Padding(padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/mail_icon.png",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10,),
                          const Text(
                            "Input email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),  
                        ],
                      )
                    ),
                    const Divider(),
                    //text field 
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          maxLines: 20,
                          controller: emailController,
                        ),
                      )
                    ),
                    // Stype Setup
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        emailType == EmailResponseType.ResponseEmail ?
                        TextButton(
                          onPressed: (){
                            showDialog(
                              context: context, 
                              builder: (BuildContext context){
                                return CustomMailDialog(
                                  originLength: styleManage.getChosenLength(), 
                                  originFormality: styleManage.getChosenFormality(), 
                                  originTone: styleManage.getChosenTone()
                                );
                              }
                            );
                          }, 
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome_sharp),
                              const Text("Style | Length")
                            ],
                          )
                        ) : const SizedBox(width: 0,),
                        const TextButton(
                          onPressed: null, 
                          child: const Text(
                            "Language: ",
                            style: TextStyle(
                              color: const Color(0xff806d9f)
                            ),  
                          )
                        ),
                        DropdownButton<Language>(
                          value: selectedLanguage,
                          items: buildDropDownMenuItems(), 
                          onChanged: (Language? newLang){
                            setState(() {
                              selectedLanguage = newLang as Language;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                )
              )
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: emailType == EmailResponseType.ResponseEmail ? 
                      TextField(
                        focusNode: _focusNode,
                        controller: mainIdeaController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _fillColor,
                          hintText: "Tell us how you want to reply...",
                          border:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: (){
                              print("sent message");
                              handleSendButton(styleManage, tokenManage);
                            }, 
                            icon: Icon(Icons.send, color: _iconColor,),
                          ), 
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette().bigIcon),
                            borderRadius: BorderRadius.circular(15),
                          )
                        ),
                      ) :
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: ElevatedButton(
                          onPressed: (){
                            handleSendButton(styleManage, tokenManage);
                          }, 
                          child: const Text(
                            'Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,

                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette().bigIcon,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void handleSendButton(EmailStyleProvider styleManage, Managetokenprovider tokenManage) async{
    if(emailType == EmailResponseType.ResponseEmail){
      var email = emailController.value.text;
      var mainIdea = mainIdeaController.value.text;
      if(email == "" || mainIdea == ""){
        ShowDialogSupport().showDialogNotifyEmailRsp("Please fill all text to receive response from AITalk!",  context);
      }else{
        ShowDialogSupport().showProgressHandlingDialog(context);
        EmailRequest req = EmailRequest(
          mainIdea: mainIdea, 
          email: email, 
          length: EmailResponseConverter().convertLength(styleManage.getChosenLength()), 
          formality: EmailResponseConverter().ConvertFormality(styleManage.getChosenFormality()), 
          tone: EmailResponseConverter().convertTone(styleManage.getChosenTone()), 
          language: LanguageConverter().Convert(selectedLanguage).toLowerCase()
        );
        try{
          EmailResponse resp = await emailResponseService.responseEmail(req);
            ShowDialogSupport().showDialogNotifyEmailRsp(resp.email.toString(), context);
            tokenManage.updateRemainTokenWithoutNotify(resp.remainUsage);
            tokenManage.updatePercentageWithoutNotify();
        }catch(err){
           ShowDialogSupport().showDialogNotifyEmailRsp(err.toString(), context);
        }
      }
    }else if(emailType == EmailResponseType.RequestReplyIdeas){
      var email = emailController.value.text;
      if(email == ""){
        ShowDialogSupport().showDialogNotifyEmailRsp("Please fill email content to receive ideas response from AITalk!",  context);
      }else{
        ShowDialogSupport().showProgressHandlingDialog(context);
        SuggestIdeaRequest req = SuggestIdeaRequest(
          email: email, 
          language: LanguageConverter().Convert(selectedLanguage).toLowerCase()
        );
        try{
          List<String> resp = await emailResponseService.suggestEmailIdea(req);
          ShowDialogSupport().showDialogNotifyEmailRspIdea(resp, context);
        }catch(err){
          ShowDialogSupport().showDialogNotifyEmailRsp(err.toString(),   context);
        }
      }
    }
    else{
      return;
    }
  }

}