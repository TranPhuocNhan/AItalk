import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelperFunctions {
  // dialog with 1 button ok to dispose dialog 
  void showMessageDialog(String title, String content, BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text("Ok")
            )
          ],
        );
      }
    );
  }

  void showSnackbarMessage(String message, BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}