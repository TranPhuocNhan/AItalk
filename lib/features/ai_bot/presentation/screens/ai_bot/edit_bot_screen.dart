import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/ai_bot/ai_%20bot.dart';
import 'package:flutter_ai_app/core/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/ai_bot/update_bot_kb.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:get_it/get_it.dart';

class EditBotScreen extends StatefulWidget{
  final AiBot data; 
  final Function(AiBot update) onUpdate;
  EditBotScreen({
    required this.data,
    required this.onUpdate,
  });
  @override
  State<StatefulWidget> createState() => _EditBotState();
}

class _EditBotState extends State<EditBotScreen>{
  late AiBot data; 
  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  late Function(AiBot update) onUpdate;


  late TextEditingController botNameController ;
  late TextEditingController botDescController;
  late TextEditingController botInstructController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.onUpdate = widget.onUpdate;
    data = widget.data;
    botNameController = TextEditingController(text: data.assistantName);
    botDescController = TextEditingController(text: data.description);
    botInstructController = TextEditingController(text: data.instructions);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorPalette().bgColor,
        title: const Text(
          "Edit Bot",
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
      ),
      body: SingleChildScrollView(
        child:  Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME  
                const SizedBox(height: 20,),
                RichText(
                  text: TextSpan(
                    text: "Bot Name " ,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.red,
                        )
                      )
                    ]
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  'Give your bot a name to identify it on platform',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: botNameController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      )
                    )
                  ),
                ),

                // DESCRIPTION
                const SizedBox(height: 20,),
                const Text(
                  "Bot Description " ,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  'Leave empty to auto-generate an apt description.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: botDescController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      )
                    )
                  ),
                ),

                // INSTRUCTIONS
                const SizedBox(height: 20,),
                const Text(
                  "Bot Instructions " ,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  'Leave empty to auto-generate an apt description.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: botInstructController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      )
                    )
                  ),
                ),
                // KNOWLEDGE BASE
                const SizedBox(height: 20,),
                const Text(
                  "Knowledge Base" ,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                      color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10,),
                UpdateBotKnowledgeBase(input: data),
                // GROUP BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1
                          )
                        )
                      ),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        if(botNameController.value.text == ""){
                          HelperFunctions().showMessageDialog("Message","The name field is required!",context);
                        } else{
                          updateLoadingProgress(true);
                          await updateBot(data.id, botNameController.value.text, botDescController.value.text, botInstructController.value.text);
                          HelperFunctions().showSnackbarMessage("Updated", context);
                          updateLoadingProgress(false);
                        }
                      }, 
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette().bigIcon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading ? 
                    const CircularProgressIndicator() :
                    const SizedBox(height: 0,),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateBot(String id, String name, String desc, String instruction) async{
    var result = await aiBotService.updateAssistant(id, name, instruction, desc);
    onUpdate(result);
    Navigator.pop(context);
  }
  void updateLoadingProgress(bool value){
    setState(() {
      isLoading = value;      
    });
  }
  
}