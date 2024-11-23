import 'package:flutter/foundation.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_chat/data/assistant_manager.dart';

class AssistantProvider extends ChangeNotifier {
  final AsisstantManager _asisstantManager = AsisstantManager();
  List<Assistant> _assistants = [];
  String? _selectedAssistant;

  AssistantProvider() {
    _assistants = _asisstantManager.getAssistants();
    _selectedAssistant = _assistants.isNotEmpty ? _assistants.first.name : null;
  }

  List<Assistant> get assistants => _assistants;
  String? get selectedAssistant => _selectedAssistant;

  void setSelectedAssistant(String assistantName) {
    _selectedAssistant = assistantName;
    notifyListeners();
  }
}
