import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/ai_bot/ai_%20bot.dart';
import 'package:flutter_ai_app/core/services/ai_bot_services.dart';
import 'package:get_it/get_it.dart';

class AiBotPopupMenu extends StatefulWidget {
  final AiBot data;
  final Function(String selected, AiBot bot) handleSelectedCallback;
  AiBotPopupMenu({
    required this.data,
    required this.handleSelectedCallback,
  });
  @override
  State<StatefulWidget> createState() => _AiBotPopupState();
}

class _AiBotPopupState extends State<AiBotPopupMenu> {
  final AiBotService aiBotService = GetIt.instance<AiBotService>();
  late Function(String id) updateDeletePositionCallback;

  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Edit'),
                ],
              )),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete),
                const SizedBox(
                  width: 10,
                ),
                const Text('Delete'),
              ],
            ),
          ),
          PopupMenuItem(
            value: "chat",
            child: Row(
              children: [
                const Icon(Icons.chat_rounded),
                const SizedBox(
                  width: 10,
                ),
                const Text('Chat'),
              ],
            ),
          )
        ];
      },
      onSelected: (value){
        switch(value){
          case 'chat':{
            widget.handleSelectedCallback('chat', widget.data);
            break;
          }
          case 'delete':{
            widget.handleSelectedCallback('delete', widget.data);
            break;
          }
          case 'edit':{
            widget.handleSelectedCallback('edit', widget.data);
            break;
          }
          default:{
            break;
          }
        }
      },
    );
  }

  
}
