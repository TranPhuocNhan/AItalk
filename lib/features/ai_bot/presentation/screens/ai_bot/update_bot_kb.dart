import 'package:flutter/material.dart';
import 'package:flutter_ai_app/features/ai_bot/data/models/ai_%20bot.dart';
import 'package:flutter_ai_app/features/ai_bot/data/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_bot/data/bot_knowledge_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/ai_bot/select_kb_dialog.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_response.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/services/knowledge-service.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:flutter_ai_app/views/home_view.dart';
import 'package:get_it/get_it.dart';

class UpdateBotKnowledgeBase extends StatefulWidget{
  final AiBot input;
  UpdateBotKnowledgeBase({
    required this.input,
  });
  @override
  State<StatefulWidget> createState() => _updateBotKBState();
}

class _updateBotKBState  extends State<UpdateBotKnowledgeBase>{
  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  final KnowledgeService kbService = GetIt.instance<KnowledgeService>();
  late Function(bool updateData) updateDataCallback; // use for create new bot


  List<KnowledgeResDto> importedKb = [];
  List<KnowledgeResDto> availableKb = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareData();
    updateDataCallback = (bool update) {
      if (update) {
        prepareData();
      }
    };
    
  }
  void updateLoadingPrepareData(bool value){
    setState(() {
      isLoading = value;
    });
  }
  void prepareData() async{
    updateLoadingPrepareData(false);
    isLoading = false;
    KnowledgeResponse response = await aiBotService.getImportedKnowledge(widget.input.id);
    importedKb = response.data;
    KnowledgeResponse response2 = await kbService.getKnowledges();
    availableKb = response2.data;
    updateLoadingPrepareData(true); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (importedKb.length == 0) ? 
        const Text(
          "Don't have any knowledge!...",
          style: TextStyle(
            fontSize: 15,
          ),  
        ) : 
        Container(
          constraints: BoxConstraints(maxHeight: 200.0),
          child: ListView.builder(
          shrinkWrap: true,
          itemCount: importedKb.length,
          itemBuilder: (context, index){
            return Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      importedKb[index].knowledgeName,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () async{
                        try{
                          await BotKnowledgeManager().handleDeleteKBFromBot(widget.input.id, availableKb[index].id);
                          updateDataCallback(true);
                          HelperFunctions().showSnackbarMessage("Deleted", context);
                          print("success delete");
                        }catch(err){
                          HelperFunctions().showSnackbarMessage(err.toString(), context);
                          print("failed delete");
                        }
                      }, 
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }),
        ),
        
          SizedBox(height: 10,),
          isLoading ? 
          TextButton(
            onPressed: (){
              if(availableKb.length > 0){
                showListKBDialog();
              }else{
                showNotificationDialog();
              }
            }, 
            child: Text(
              'Add from knowledge base',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),  
           ),
          ) : 
          CircularProgressIndicator(),
          const SizedBox(height: 30,),
      ],
    );
  }

  
  void showListKBDialog(){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return SelectKbDialog(availableKb: availableKb, assistantId: widget.input.id, onUpdate: updateDataCallback,);
      });
  }
  void showNotificationDialog(){
  showDialog(
    context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Add Knowledge"),
        content: Text("Knowledge list is empty!! Please add knowledge before"),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Cancel")
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView.withSelectInput(selectInput: 3) ));
            }, 
            child: Text("Add Knowledge")
          ),
        ],
      );
    });
}
}

