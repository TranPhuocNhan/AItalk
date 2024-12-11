import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/profile/presentation/manage_token_provider.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:provider/provider.dart';

class TokenUsageCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TokenUsageState();
}

class _TokenUsageState extends State<TokenUsageCard>{
  @override
  Widget build(BuildContext context) {
    final tokenManage = Provider.of<Managetokenprovider>(context);
    return Card(
      color: Colors.lightGreen.shade50 ,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Token Usage",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            LinearProgressIndicator(
              value: tokenManage.percentage.toDouble(),
              minHeight: 5,
              color: ColorPalette().selectedItemOnDrawerColor,
              valueColor: AlwaysStoppedAnimation<Color>(ColorPalette().btnColor),
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tokenManage.getRemainToken().toString(),
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
                Text(
                  tokenManage.getTotalToken().toString(),
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
