import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/data/bot_integration_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/data/bot_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/configuration_response.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/messenger_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/publish_item.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/slack_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/telegram_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/bot_integration_services.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/ai_bot/publish_bot_result_screen.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/widgets/ai_bot/publish_bot_mess_dialog.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/widgets/ai_bot/publish_bot_slack_dialog.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/widgets/ai_bot/publish_bot_tele_dialog.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';

class PublishBotScreen  extends StatefulWidget{
  final AiBot bot;
  final List<ConfigurationResponse> configurations;
  final BotIntegrationServices integrationServices;
  PublishBotScreen({
    required this.bot,
    required this.configurations,  
    required this.integrationServices
  });
  @override
  State<StatefulWidget> createState() => _publishBotState();
}

class _publishBotState extends State<PublishBotScreen> {
  List<PublishItem> publishData = generateSampleData();
  static List<PublishItem> generateSampleData(){
    List<PublishItem> output = [
      new PublishItem(imgLink: "assets/images/telegram.png", name: "Telegram"),
      new PublishItem(imgLink: "assets/images/slack.png", name: "Slack"),
      new PublishItem(imgLink: "assets/images/messenger.png", name: "Messenger"),
    ];
    return output;
  }
  SlackPublish? slack = null;
  TelegramPublish? tele = null;
  MessengerPublish? mess = null;
  List<bool> verified = [false, false, false];
  List<bool> selectPublish = [false, false, false];
  List<bool> published = [false, false, false];
  //CALLBACK 
  late Function (MessengerPublish) onUpdateMessengerPublishState;
  late Function (SlackPublish updateData) onUpdateSlackPublishState;
  late Function (TelegramPublish updateData) onUpdateTelegramPublishState;
  late Function (bool) onDeleteMessConfiguration;
  late Function (bool) onDeleteTelegramConfiguration;
  late Function (bool) onDeleteSlackConfiguration;

  @override
  void initState() {
    super.initState();
    slack = BotManager().getSlackPublish(widget.configurations);
    mess = BotManager().getMessengerPublish(widget.configurations);
    tele = BotManager().getTelegramPublish(widget.configurations);
    if(slack != null){
      verified[1] = true;
      published[1] = true;
    }
    if(mess != null) {
      verified[2] = true;
      published[2] = true;
    }
    if(tele != null){
      verified[0] = true;
      published[0] = true;
    }
    onUpdateMessengerPublishState = (MessengerPublish value) async{
      setState(() {
        mess = value;
        verified[2] = true;
      });
    };
    onUpdateTelegramPublishState = (TelegramPublish value) async{
      setState(() {
        tele = value;
        verified[0] = true;
      });
    };
    onUpdateSlackPublishState = (SlackPublish value) async{
      setState(() {
        slack = value;
        verified[1] = true;
      });
    };
    onDeleteMessConfiguration = (bool value){
      setState(() {
        mess = null;
        verified[2] = false;
        published[2] = false;
      });
    };
    onDeleteTelegramConfiguration = (bool value){
      setState(() {
        tele = null;
        verified[0] = false;
        published[0] = false;
      });
    };
    onDeleteSlackConfiguration = (bool value){
      setState(() {
        slack = null;
        verified[1] = false;
        published[1] = false;
      });
    };
  }

  bool canPublish(){
    for(int i = 0; i < selectPublish.length; ++i){
      if(selectPublish[i] == true)
        return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette().bgColor,
        title: const Text(
          "Publish Bot",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: (canPublish()) ?  ColorPalette().bigIcon : ColorPalette().bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey,
                  width: 1,
                )
              )
            ),
            onPressed: (canPublish()) ? () async{
              List<ConfigurationResponse> data =  [];
              List<PublishItem> items = [];
              if(selectPublish[0]) {
                data.add(tele as ConfigurationResponse);
                items.add(PublishItem(imgLink: "assets/images/telegram.png", name: "Telegram"));
              }
              if(selectPublish[1]) {
                data.add(slack as ConfigurationResponse);
                items.add(PublishItem(imgLink: "assets/images/slack.png", name: "Slack")); 
              }
              if(selectPublish[2]) {
                data.add(mess as ConfigurationResponse);
                items.add(PublishItem(imgLink: "assets/images/messenger.png", name: "Messenger"));
              }
              List<ConfigurationResponse> realData = await BotIntegrationManager().handlePublishButton(data, widget.integrationServices);
              print("real data is ${realData.length}");
              Navigator.push(context, MaterialPageRoute(builder: (_) => PublishBotResultScreen(data: realData,items: items,)));
            } : null,  
            child: Text(
              "Publish",
              style: TextStyle(
                fontWeight: (canPublish()) ? FontWeight.bold : FontWeight.normal,
                color: (canPublish()) ? Colors.white : Colors.grey, 
              ),
            ), 
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Container(
            height: 300,
            child:
              ListView.builder(
                itemCount: publishData.length,
                itemBuilder: (context, index){
                  return Card(
                    color: selectPublish[index] ? ColorPalette().bgColor : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: selectPublish[index], 
                                onChanged: (value){
                                  setState(() {
                                    if(verified[index] && value != null)
                                      selectPublish[index] = value;
                                  });
                                }
                              ),
                              Image.asset(publishData[index].imgLink, fit: BoxFit.fill, width: 20, height: 20,),
                              SizedBox(width: 10,),
                              Text(publishData[index].name)
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: verified[index] ? ColorPalette().bgColor : Colors.grey.shade300,
                            ),
                            child: verified[index] ? Text(
                              "Verified",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ) : Text(
                              "Not configured",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: (){
                                  showConfigureDialog(publishData[index]);
                                }, 
                                child: Text("Configure")
                              )
                            ],
                          ),
                        ],
                        
                      ),
                    ),
                  );
                })
  
          ),
        ),  
      ),
    );
  }

  void showConfigureDialog(PublishItem item){
    switch(item.name){
      case "Telegram":{
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return PublishBotTeleDialog().createConfigTeleWidget(context, item, widget.bot.id, tele, onUpdateTelegramPublishState, onDeleteTelegramConfiguration, published[0]);
          });
        break;
      } 
      case "Messenger":{
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return PublishBotMessengerDialog().createConfigMessageWidget(context, item, widget.bot.id, mess, onUpdateMessengerPublishState, onDeleteMessConfiguration , published[2]);
          }
        );
        break;
      }
      case "Slack":{
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return PublishBotSlackDialog().createConfigSlackWidget(context, item, widget.bot.id, slack, onUpdateSlackPublishState, onDeleteSlackConfiguration, published[1]);
          });
        break;
      }
      default: {
        break;
      }
    }
  }

}