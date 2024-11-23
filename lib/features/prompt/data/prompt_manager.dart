import 'package:flutter_ai_app/core/models/prompt/get_prompt_response.dart';
import 'package:flutter_ai_app/core/models/prompt/prompt.dart';
import 'package:flutter_ai_app/core/services/prompt_service.dart';
import 'package:get_it/get_it.dart';

class PromptManager {
  final PromptService _promptService = GetIt.instance<PromptService>();

  Future<GetPromptResponse> fetchPrompts({
    required String query,
    required int offset,
    required int limit,
    String? category,
    bool? isFavorite,
    bool? isPublic,
  }) async {
    return await _promptService.getPrompts(
      query: query,
      offset: offset,
      limit: limit,
      category: category,
      isFavorite: isFavorite,
      isPublic: isPublic,
    );
  }

  Future<Map<String, dynamic>> createPrompt({
    required String category,
    required String content,
    required String description,
    required bool isPublic,
    required String language,
    required String title,
  }) async {
    return await _promptService.createPrompt(
        category: category,
        content: content,
        description: description,
        isPublic: isPublic,
        language: language,
        title: title);
  }

  Future<void> updatePrompt({required Prompt prompt}) async {
    return await _promptService.updatePrompt(prompt: prompt);
  }

  Future<void> deletePrompt({required String promptId}) async {
    return await _promptService.deletePrompt(promptId: promptId);
  }

  Future<void> favoritePrompt({required String promptId}) async {
    return await _promptService.favoritePrompt(promptId: promptId);
  }

  Future<void> unfavoritePrompt({required String promptId}) async {
    return await _promptService.unfavoritePrompt(promptId: promptId);
  }
}
