import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_app/utils/providers/manageTokenProvider.dart';

class ShowDialogSupport {
  
  void showProgressHandlingDialog(BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        );
      });

  }
  
  void showDialogNotifyEmailRsp(String message, BuildContext context) async{
    if (!message.contains("Please fill all")){
      Navigator.pop(context);
    }
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            "Email Response",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),  
          ),
          content: Text(message),
          actions: [
            TextButton(
              //CHƯA TEST CHỨC NĂNG NÀY TRÊN MOBILE
              onPressed: () async{
                await Clipboard.setData(ClipboardData(text: message)).then((_){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied")));
                });
              },
              child: Text("Copy"),
            ),
            TextButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).pop();
              }, 
              child: Text("Close"),
            )
          ],
        );
      }
    );
  }

  void showDialogNotifyEmailRspIdea(List<String> ideas, BuildContext context){
    Navigator.pop(context);
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            "Email Response",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            height: 400,
            width: 400,
            child: ListView.builder(
              itemCount: ideas.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(ideas[index]),
                  leading: Icon(Icons.check_circle_outline),
                );
              }
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: Text("Close")
            )
          ],
        );
      }
    );
  }

}