import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/utils/assistant_map.dart';

class AsisstantManager {
  List<Assistant> getAssistants() {
    return assistantMap.entries
        .map((e) => Assistant(name: e.key, id: e.value))
        .toList();
  }

  String getAssistantId(String assistantName) {
    return assistantMap[assistantName] ?? "gpt4o-mini";
  }
}
