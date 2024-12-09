import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget{
  String title = "";
  IconData mainIcon = Icons.square;
  CustomTitle({
    required String data,
    required IconData icon}){
      this.title = data;
      this.mainIcon = icon;
    }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          mainIcon,
          color: Colors.grey,
        ),
        SizedBox(width: 10,),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
  
}