import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/constant/Color.dart';

class GroupTypeButton extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _GroupTypeState();
}

class _GroupTypeState extends State<GroupTypeButton> {
  List<String> title = <String>["Thanks","Sorry","Yes","No","Follow Up","Request for more information"];
  List<String> icon = <String>["images/thanks.png","images/sorry.png","images/yes.png","images/no.png","images/followup.png","images/request.png"];
  // List<bool> isSelected = [false,false,false,false,false,false];
  List<bool> selectedRow1 = [false, false, false, false];
  List<bool> selectedRow2 = [false, false]; 
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Wrap(
        spacing: 8.0, // khoảng cách giữa các item trên 1 hàng
        runSpacing: 4.0,  // khoảng cách giữa các hàng 
        children: [
          ToggleButtons(
              isSelected: selectedRow1,
              selectedColor: ColorPalette().btnColor,
              onPressed: (int index){
                setState(() {
                  for(int i = 0; i < selectedRow1.length; ++i){
                    if(i != index){
                      selectedRow1[i] = false;
                    }else{
                      selectedRow1[i] = true;
                    }
                  }  
                  for(int i = 0; i < selectedRow2.length; ++i){
                    selectedRow2[i] = false;
                  }          
                  for(int i = 0; i < selectedRow1.length; ++i)
                    print("${selectedRow1[i]} -- ");
                  for(int i = 0; i < selectedRow2.length; ++i)
                    print("${selectedRow2[i]} -- ");
                });
              },
              children: [
                CreateSingleItem(title[0], icon[0], 100,1,0),
                CreateSingleItem(title[1], icon[1], 100,1,1),
                CreateSingleItem(title[2], icon[2], 80,1,2),
                CreateSingleItem(title[3], icon[3],80,1,3),

              ],
            ),
            ToggleButtons(
              isSelected: selectedRow2,
              selectedColor: ColorPalette().btnColor,

              onPressed: (int index){
                setState(() {
                  for(int i = 0; i < selectedRow2.length; ++i){
                    if(i != index){
                      selectedRow2[i] = false;
                    }else{
                      selectedRow2[i] = true;
                    }
                  }
                  for(int i = 0; i < selectedRow2.length; ++i){
                    selectedRow2[i] = false;
                  }                 
                });
              },
              children: [
                CreateSingleItem(title[4], icon[4],100,2,0),
                CreateSingleItem(title[5], icon[5],250,2,1),
              ],
            ),
        ]
      ),
    );
  }

  Widget CreateSingleItem(String title, String icon, double size, int group, int index){
    return 
    OutlinedButton(
      onPressed:(){
        setState(() {
          if(group == 1){
            for(int i = 0; i < selectedRow1.length; ++i){
              if(i != index){
                selectedRow1[i] = false;
              }else{
                selectedRow1[i] = true;
              }
            }  
            for(int i = 0; i < selectedRow2.length; ++i){
              selectedRow2[i] = false;
            }     
          }else{
            for(int i = 0; i < selectedRow2.length; ++i){
              if(i != index){
                selectedRow2[i] = false;
              }else{
                selectedRow2[i] = true;
              }
            }  
            for(int i = 0; i < selectedRow1.length; ++i){
              selectedRow1[i] = false;
            }     
          }
               
        });
      }, 
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(8),
        backgroundColor: (group == 1) ? (selectedRow1[index] == true ? ColorPalette().btnColor : Colors.white) : (selectedRow2[index] == true ? ColorPalette().btnColor : Colors.white),
        foregroundColor: (group == 1) ? (selectedRow1[index] == true ? Colors.white : Colors.black) : (selectedRow2[index] == true ? Colors.white : Colors.black)
      ),
      child: Row(
        children: [
          Image.asset(icon, width:20, height: 20,),
          Text(
            title,
            style: TextStyle(
              fontSize: 16
            ),  
          ),

        ],
      ),
    );
  }
}