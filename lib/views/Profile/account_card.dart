import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/services/auth_service.dart';
import 'package:flutter_ai_app/views/login/verify_email.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AccountCardState();
}
class _AccountCardState extends State<AccountCard>{
  
  final AuthService authService = GetIt.instance<AuthService>();
  var username = "";
  var email = "";
  @override
  void initState() {
    super.initState();
    setUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightGreen.shade50,
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
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(email),
            ),
            const Divider(),
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
                title: const Text(
                  "Change pasword",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () async{
                var logoutResult = await authService.logoutAccount();
                if(logoutResult){
                  Navigator.pushNamed(context, '/login');
                }
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
                title: const Text(
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
  
  void setUserInformation() async{
    // print("ENTER SET USER INFORMATION");
    //get user name and email and remain token 
    final prefs = await SharedPreferences.getInstance();
    var name = await prefs.getString('currentUser');
    var mail = await prefs.getString('currentEmail');
    setState(() {
      username = name!;
      email = mail!;
    });

  }
  
}