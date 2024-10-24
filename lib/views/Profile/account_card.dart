import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/login/verify_email.dart';
import 'package:flutter_ai_app/views/style/Color.dart';

class AccountCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AccountCardState();
}
class _AccountCardState extends State<AccountCard>{
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: ColorPalette().endLinear.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.person),
              ),
              title: Text(
                "FirstUser",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text("abc123@gmail.com"),
            ),
            Divider(),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  VerifyEmailScreen(context: context, email: "abc123@gmail.com")
                ));
              },
              child:ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: ColorPalette().endLinear.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.lock),
                ),
                title: Text(
                  "Change pasword",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: (){
                //LOGOUT ACCOUNT
                //[...]
              },
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade200,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.logout_outlined,
                    color: Colors.red.shade700,
                  ),
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            )
          ],
        ),  
      ),
    );
  }
  
}