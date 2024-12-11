import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/ai_bot/ai_%20bot.dart';
import 'package:flutter_ai_app/core/services/ai_bot_services.dart';
import 'package:flutter_ai_app/features/ai_bot/data/bot_manager.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/create_bot_screen.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/edit_bot_screen.dart';
import 'package:flutter_ai_app/features/ai_bot/presentation/screens/search_group.dart';
import 'package:flutter_ai_app/utils/constant/Color.dart';
import 'package:flutter_ai_app/widgets/app_drawer.dart';
import 'package:get_it/get_it.dart';

class AIBotView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AIBotState();
}

class _AIBotState extends State<AIBotView> {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  List<AiBot> lstData = [];
  List<AiBot> actualData = [];
  int origin = 0;
  late Function(bool updateData) updateDataCallback; // use for create new bot
  late Function(AiBot editedData) updateEditCallback; // use for edit a bot
  late Function(String keywork) updateSearchCallback; // use for search function

  void updateListData(List<AiBot> data) {
    setState(() {
      lstData = data;
    });
  }

  void updateAnItemInListData(AiBot data) {
    int index = BotManager().getPositionOfBotInList(data.id, lstData);
    if (index != -1) {
      setState(() {
        lstData[index] = data;
        actualData[index] = data;
      });
    }
  }

  void addItemToListData(AiBot data) {
    setState(() {
      lstData.add(data);
    });
  }

  void updateListAssistant(List<AiBot> data) {
    setState(() {
      lstData = data;
      actualData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    updateDataCallback = (bool update) {
      if (update) {
        fetchData();
      }
    };
    updateEditCallback = (AiBot update) {
      updateAnItemInListData(update);
    };
    updateSearchCallback = (String keyword) {
      if (keyword == "") {
        updateListData(actualData);
      } else {
        List<AiBot> result =
            BotManager().searchAiBotWithKeyword(keyword, actualData);
        updateListData(result);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Bots",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: ColorPalette().bgColor,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
            color: Colors.black,
          );
        }),
      ),
      drawer: AppDrawer(selected: 2),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // SEARCH AREA
              SearchGroup(onUpdate: updateSearchCallback),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Center(
                child: lstData.length == 0
                    ? const Text(
                        "Empty",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ListView.builder(
                            itemCount: lstData.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      lstData[index].assistantName,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      lstData[index].description,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: DropdownButton<String>(
                                      // value: selectedOption,
                                      hint: Icon(Icons.more_vert),
                                      items: [
                                        const DropdownMenuItem<String>(
                                          value: 'edit',
                                          child: const Text('Edit'),
                                        ),
                                        const DropdownMenuItem<String>(
                                          value: 'delete',
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        // handle when click delete or edit
                                        switch (value) {
                                          case "delete":
                                            {
                                              handleDeleteAssistant(
                                                  lstData[index].id,
                                                  lstData[index].assistantName);
                                              break;
                                            }
                                          case "edit":
                                            {
                                              handleEditAssistant(
                                                  lstData[index]);
                                              break;
                                            }
                                          default:
                                            {
                                              break;
                                            }
                                        }
                                      },
                                      underline: const SizedBox(),
                                      icon: const SizedBox.shrink(),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                      ),
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CreateBotScreen(onUpdate: updateDataCallback)),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: ColorPalette().bigIcon,
      ),
    );
  }

  Future<void> fetchData() async {
    List<AiBot> result = await aiBotService.getListAssistant();
    updateListAssistant(result);
  }

  void handleDeleteAssistant(String assistantId, String assistantName) async {
    // show dialog to confirm delete
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Bot"),
            content: Text("Do you want to delete ${assistantName}?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    await aiBotService.deleteAssistant(assistantId);
                    deleteBotWithId(assistantId);
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  void handleEditAssistant(AiBot input) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditBotScreen(
                  data: input,
                  onUpdate: updateEditCallback,
                )));
  }

  void deleteBotWithId(String id) {
    int pos = BotManager().getPositionOfBotInList(id, lstData);
    if (pos != -1) {
      setState(() {
        actualData.removeAt(pos);
        lstData = actualData;
      });
    }
  }
}
