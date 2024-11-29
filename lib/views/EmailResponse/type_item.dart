import 'package:flutter/cupertino.dart';

class TypeItem{
  const TypeItem({
    required this.title,
    required this.icon,
  });
  final String title;
  final String icon;
}

abstract class TypeItems{
  static const List<TypeItem> items = [Thanks,Sorry,Yes,No,Followup,Request];
  static const Thanks = TypeItem(title: "Thanks", icon: "assets/images/thanks.png");
  static const Sorry = TypeItem(title: "Sorry", icon: "assets/images/sorry.png");
  static const Yes = TypeItem(title: "Yes", icon: "assets/images/yes.png");
  static const No = TypeItem(title: "No", icon: "assets/images/no.png");
  static const Followup = TypeItem(title: "Follow Up", icon: "assets/images/followup.png");
  static const Request = TypeItem(title: "Request for more information", icon: "assets/images/request.png");

  static Widget buildItem(TypeItem item){
    return Row(
      children: [
        Image.asset(item.icon, width: 30, height: 30,),
        const SizedBox(width: 10,),
        Expanded(
          child: Text(
            item.title,
          ),
        )
      ],
    );
  }

  static void onChanged(BuildContext context, TypeItem item){
    switch(item){
      case TypeItems.Thanks:{
        //to do something
        break;
      }
      case TypeItems.Sorry:{
        //todo something
        break;
      }
      case TypeItems.Yes:{
        //todo something
        break;
      }
      case TypeItems.No: {
        //todo something
        break;
      }
      case TypeItems.Followup: {
        //todo something 
        break;
      }
      case TypeItems.Request: {
        //todo something 
        break;
      }
    }
  }
}