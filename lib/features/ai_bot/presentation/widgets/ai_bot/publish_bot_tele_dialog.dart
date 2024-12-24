import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/publish_item.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/telegram_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/bot_integration_services.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:get_it/get_it.dart';

class PublishBotTeleDialog {
  
  Widget createConfigTeleWidget(BuildContext context, PublishItem item, String botId, TelegramPublish? publish, Function(TelegramPublish) onUpdate, Function(bool) onDelete, bool isPublished){
    TextEditingController botTokenController = TextEditingController(text: publish?.token);
     BotIntegrationServices integrationServices = GetIt.instance<BotIntegrationServices>();

    return AlertDialog(
      content: Container(
        height: MediaQuery.sizeOf(context).height / 3,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Configure Telegram Bot",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  HelperFunctions().launchUrl(
                      "https://jarvis.cx/help/knowledge-base/publish-bot/telegram");
                },
                child: const Text(
                  "how to obtain Telegram configurations?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              //TELEGRAM BOT TOKEN
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Token",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: " *",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))
              ])),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: botTokenController,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                      onPressed: () async {
                        try{
                          if(isPublished){
                            await integrationServices.disconnectBotIntegration(botId, "telegram");
                            onDelete(true);
                          }else{
                            await integrationServices.verifyTelegramPublish(botTokenController.value.text);
                            TelegramPublish verified = new TelegramPublish(
                              type: "telegram", 
                              id: "", 
                              assistantId: botId, 
                              token: botTokenController.value.text, 
                              redirect: "", 
                              botName: ""
                            );
                            onUpdate(verified);
                          }
                          
                        }catch(err){

                        }
                        Navigator.pop(context);
                      },
                      child: (isPublished) ? 
                      const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ) :
                      Text(
                        "Ok",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}