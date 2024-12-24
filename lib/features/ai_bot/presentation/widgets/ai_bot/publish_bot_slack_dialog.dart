import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/publish_item.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/slack_publish.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/bot_integration_services.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:get_it/get_it.dart';

class PublishBotSlackDialog {
  
  Widget createConfigSlackWidget(BuildContext context,PublishItem item, String botId, SlackPublish? publish, Function(SlackPublish) onUpdate, Function(bool) onDelete, bool isPublished){
    TextEditingController botTokenController = TextEditingController(text: publish?.botToken);
    TextEditingController clientIdController = TextEditingController(text: publish?.clientId);
    TextEditingController clientSecretController = TextEditingController(text: publish?.clientSecret);
    TextEditingController signingSecretController = TextEditingController(text: publish?.signingSecret);
    BotIntegrationServices integrationServices = GetIt.instance<BotIntegrationServices>();
    return AlertDialog(
      content: Container(
        height: MediaQuery.sizeOf(context).height / 2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Configure Slack Bot",
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
                      "https://jarvis.cx/help/knowledge-base/publish-bot/slack");
                },
                child: const Text(
                  "how to obtain Slack configurations?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              //OAUTH2 REDIRECT URLS
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "OAuth2 Redirect URLs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                                text:
                                    'https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/auth/$botId'))
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
                "https://knowledge-api.dev.jarvis.cx/kb-core/v1/bot-integration/slack/auth/$botId",
              ),
              //EVENT REQUEST URL
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Event Request URL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                                text:
                                    'https://knowledge-api.dev.jarvis.cx/kb-core/v1/hook/slack/$botId'))
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
                "https://knowledge-api.dev.jarvis.cx/kb-core/v1/hook/slack/$botId",
              ),
              //SLASH REQUEST URL
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Slash Request URL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                                text:
                                    'https://knowledge-api.dev.jarvis.cx/kb-core/v1/hook/slack/slash/$botId'))
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
                "https://knowledge-api.dev.jarvis.cx/kb-core/v1/hook/slack/slash/$botId",
              ),
              
              //TOKEN
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
              // CLIENT ID
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Client Id",
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
                controller: clientIdController,
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
              //CLIENT SECRET
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Client Secret",
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
                controller: clientSecretController,
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
              //SIGNING SECRET
              SizedBox(
                height: 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Signing Secret",
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
                controller: signingSecretController,
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
                          await integrationServices.verifySlackPublish(
                            botTokenController.value.text, 
                            clientIdController.value.text, 
                            clientSecretController.value.text, 
                            signingSecretController.value.text
                          );
                        }catch(err){

                        }
                        Navigator.pop(context);
                      },
                      child: Text(
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