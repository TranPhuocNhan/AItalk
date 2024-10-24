import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/style/Color.dart';

class TokenUsageCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TokenUsageState();
}

class _TokenUsageState extends State<TokenUsageCard>{
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Token Usage",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            LinearProgressIndicator(
              value: 40.0/50.0,
              minHeight: 5,
              color: ColorPalette().selectedItemOnDrawerColor,
              valueColor: AlwaysStoppedAnimation<Color>(ColorPalette().endLinear),
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "40",
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
                Text(
                  "50",
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ],
            )
          ],
        ),  
      )
    );
  }

}
