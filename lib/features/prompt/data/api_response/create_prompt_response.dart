import 'package:flutter_ai_app/features/prompt/data/prompt.dart';

class CreatePromptResponse {
  final Prompt prompt;

  CreatePromptResponse({required this.prompt});

  factory CreatePromptResponse.fromJson(Map<String, dynamic> json) =>
      CreatePromptResponse(prompt: Prompt.fromJson(json['prompt']));

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt.toJson(),
    };
  }
}
