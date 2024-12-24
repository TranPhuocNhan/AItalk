import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/publish_item.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';

class PublishBotResultScreen extends StatefulWidget{
  final List<ConfigurationResponse> data;
  final List<PublishItem> items;
  PublishBotResultScreen({
    required this.data,
    required this.items,
  });
  @override
  State<StatefulWidget> createState() => _publishBotResultState();
}

class _publishBotResultState extends State<PublishBotResultScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette().bgColor,
        title: const Text(
          "Publication Submitted",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Container(
            child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (context, index){
                return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Image.asset(widget.items[index].imgLink, fit: BoxFit.fill, width: 20, height: 20,),
                          const SizedBox(width: 10,),
                          Text(widget.items[index].name),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          String link = widget.data[index].redirect;
                          print("FINAL LINK -> ${widget.data[index].redirect}");
                          String pattern = "redirect_uri=";
                          int pos = link.indexOf(pattern);
                          if(pos != -1){
                            int startIndex = pos + pattern.length;
                            String updateUrl = link.replaceRange(startIndex, startIndex, "https://");
                            link = updateUrl;
                          }
                          HelperFunctions().launchUrl(link);
                        }, 
                        child: widget.data[index].type.contains("slack") ?  Text("Authorize") : Text("Open"),
                      )
                    ],
                  ),
                );
              }
            ),
          )
        ),
      ),
    );
  }
  
}