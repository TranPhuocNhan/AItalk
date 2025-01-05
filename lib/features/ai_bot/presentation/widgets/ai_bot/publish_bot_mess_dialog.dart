import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/messenger_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/publish_item.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/bot_integration_services.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:get_it/get_it.dart';

class PublishBotMessengerDialog {
  Widget createConfigMessageWidget(BuildContext context, PublishItem item, String botId, MessengerPublish? publish, Function(MessengerPublish) onUpdate, Function(bool) onDeleted, bool isPublished) {
    TextEditingController botTokenController =
        TextEditingController(text: publish?.botToken);
    TextEditingController pageIdController =
        TextEditingController(text: publish?.pageId);
    TextEditingController appSecretController =
        TextEditingController(text: publish?.appSecret);
    BotIntegrationServices integrationServices =
        GetIt.instance<BotIntegrationServices>();

    return AlertDialog(
      content: Container(
        height: MediaQuery.sizeOf(context).height / 2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Configure Messenger Bot",
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
                      "https://jarvis.cx/help/knowledge-base/publish-bot/messenger");
                },
                child: const Text(
                  "how to obtain Messenger configurations?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              //CALLBACK URL
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Callback URL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                                text:
                                    'https://knowledge-api.jarvis.cx/kb-core/v1/hook/messenger/$botId'))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Copied")));
                        });
                      },
                      icon: Icon(
                        Icons.copy,
                        size: 15,
                      ))
                ],
              ),
              Text(
                "https://knowledge-api.jarvis.cx/kb-core/v1/hook/messenger/$botId",
              ),
              //VERIFY TOKEN
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Verify Token",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                                ClipboardData(text: 'Knowledge'))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Copied")));
                        });
                      },
                      icon: Icon(
                        Icons.copy,
                        size: 15,
                      ))
                ],
              ),
              Text(
                "Knowledge",
              ),
              //MESSENGER BOT TOKEN
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Messender Bot Token",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
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
              // PAGE ID
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Messender Bot Page Id",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                TextSpan(
                    text: " *",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))
              ])),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: pageIdController,
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
              // APP SECRET
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Messender Bot App Secret",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,  
                    )),
                TextSpan(
                    text: " *",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red))
              ])),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: appSecretController,
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
                            await integrationServices.disconnectBotIntegration(botId, "messenger");
                            onDeleted(true);
                          }else{
                            await integrationServices.verifyMessengerPublish(
                              botTokenController.value.text,
                              pageIdController.value.text,
                              appSecretController.value.text,
                            );
                            MessengerPublish verified = new MessengerPublish(
                              type: "messenger", 
                              id: "", 
                              assistantId: botId, 
                              pageId: pageIdController.value.text, 
                              botToken: botTokenController.value.text, 
                              redirect: "", 
                              appSecret: appSecretController.value.text, 
                            );
                            onUpdate(verified);
                          }
                        }catch(err){
                          print("Error --> ${err}");
                        }
                          
                        Navigator.pop(context);
                      },
                      child: isPublished ? Text(
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
