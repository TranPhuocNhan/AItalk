import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/knowledge_base/data/api_response/knowledge_res_dto.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/utils/helper_functions.dart';
import 'package:get_it/get_it.dart';

class SelectKbDialog extends StatefulWidget {
  final List<KnowledgeResDto> availableKb;
  final String assistantId;
  final Function(bool updateData) onUpdate;
  SelectKbDialog({
    required this.availableKb,
    required this.assistantId,
    required this.onUpdate,
  });

  @override
  State<StatefulWidget> createState() => _selectKbDialogState();
}

class _selectKbDialogState extends State<SelectKbDialog> {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  late List<KnowledgeResDto> availableKb;
  late String assistantId;
  int selectedItem = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.availableKb = widget.availableKb;
    this.assistantId = widget.assistantId;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 400),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Knowledge Base",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: availableKb.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color: (selectedItem == index)
                                      ? ColorPalette().bgColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedItem = index;
                                  });
                                },
                                child: Text(availableKb[index].knowledgeName),
                              ),
                            )),
                          ],
                        );
                      })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        try{
                          await aiBotService.importKnowledgeForBot(assistantId, availableKb[selectedItem].id);
                          widget.onUpdate(true);
                          Navigator.pop(context);
                          HelperFunctions().showSnackbarMessage("Added", context);
                        }catch(err){
                          Navigator.pop(context);
                          HelperFunctions().showSnackbarMessage(err.toString(), context);
                        }
                      },
                      child: const Text("Ok"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleImportKnowledgeAction(){

  }
}
