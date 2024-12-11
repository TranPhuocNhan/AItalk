import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/EmailResponse/type_item.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';

class ResponseTypeDropdown extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ResponseTypeState();
}

class _ResponseTypeState extends State<ResponseTypeDropdown> {
  List<String> title = <String>["Thanks","Sorry","Yes","No","Follow Up","Request for more information"];
  List<String> icon = <String>["assets/images/thanks.png","assets/images/sorry.png","assets/images/yes.png","assets/images/no.png","assets/images/followup.png","assets/image/request.png"];
  String selectedTitle = "Thanks";
  String selectedIcon = "assets/images/thanks.png";
  @override
  Widget build(BuildContext context) {
   return DropdownButton2(
    customButton: Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffc6c8d0).withOpacity(0.5),
      ),
      child: Row(
        children: [
          Image.asset(selectedIcon, width: 30,height: 30,),
          SizedBox(width: 5,),
          Text(selectedTitle),
        ],
      ),
    ),
    items: [
      ...TypeItems.items.map(
        (item) => DropdownMenuItem<TypeItem>(
          value: item,
          child: TypeItems.buildItem(item),
        )
      ),
    ],
    onChanged: (value){
      TypeItems.onChanged(context,value as TypeItem);
      setState(() {
        if(value.title.contains("Request"))
          selectedTitle = "Request";
        else selectedTitle = value.title;
        selectedIcon = value.icon;
      });    
      
    },
    buttonStyleData: ButtonStyleData(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorPalette().iconColor.withOpacity(0.2),
        
      )

    ),
    dropdownStyleData: DropdownStyleData(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorPalette().startLinear,
      ),
      offset: const Offset(0, 8),
    ),
    menuItemStyleData: MenuItemStyleData(
      customHeights: [
        ...List<double>.filled(TypeItems.items.length,48)
      ],
      padding: const EdgeInsets.only(left: 16, right: 16)
    ),    
   );
  }
}