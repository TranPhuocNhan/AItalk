import 'package:flutter/foundation.dart';
import 'package:flutter_ai_app/features/prompt/data/api_response/get_prompt_response.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt_manager.dart';
import 'package:flutter_ai_app/utils/category_prompt_map.dart';

class PromptProvider extends ChangeNotifier {
  final PromptManager _promptManager;
  PromptProvider({required PromptManager promptManager})
      : _promptManager = promptManager;

  List<Prompt> _favoritePrompts = [];
  List<Prompt> _publicPrompts = [];
  List<Prompt> _privatePrompts = [];
  String _selectedCategory = "All";
  bool _isLoading = false;
  List<String> _categories = categoryPromptMap.values.toList();
  List<String> _categoryKeys = categoryPromptMap.keys.toList();
  Prompt? _selectedPrompt;
  String _searchMyPromptQuery = "";
  String _searchPublicPromptQuery = "";
  String _searchFavoritePromptQuery = "";

  List<String> get categories => _categories;
  List<String> get categoryKeys => _categoryKeys;
  List<Prompt> get favoritePrompts => _favoritePrompts;
  List<Prompt> get publicPrompts => _publicPrompts;
  List<Prompt> get privatePrompts => _privatePrompts;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  Prompt? get selectedPrompt => _selectedPrompt;

  void updateSearchMyPromptQuery(String query) {
    print("updateSearchMyPromptQuery");
    _searchMyPromptQuery = query;
    notifyListeners();
  }

  void updateSearchPublicPromptQuery(String query) {
    print("updateSearchPublicPromptQuery");
    _searchPublicPromptQuery = query;
    notifyListeners();
  }

  void updateSearchFavoritePromptQuery(String query) {
    print("updateSearchFavoritePromptQuery");
    _searchFavoritePromptQuery = query;
    notifyListeners();
  }

  List<Prompt> getFilteredPrivatePrompts() {
    if (_searchMyPromptQuery.isEmpty) return _privatePrompts;
    return _privatePrompts
        .where((prompt) =>
            (prompt.title?.toLowerCase().contains(_searchMyPromptQuery) ??
                false))
        .toList();
  }

  List<Prompt> getFilteredPublicPrompts() {
    return _publicPrompts
        .where((prompt) =>
            (_searchPublicPromptQuery.isEmpty ||
                (prompt.title
                        ?.toLowerCase()
                        .contains(_searchPublicPromptQuery.toLowerCase()) ??
                    false)) &&
            (_selectedCategory == "All" ||
                (prompt.category?.toLowerCase() ==
                    _selectedCategory.toLowerCase())))
        .toList();
  }

  List<Prompt> getFilteredFavoritePrompts() {
    if (_searchFavoritePromptQuery.isEmpty) return _favoritePrompts;
    return _favoritePrompts
        .where((prompt) =>
            (prompt.title?.toLowerCase().contains(_searchFavoritePromptQuery) ??
                false))
        .toList();
  }

  void setSelectedPrompt(Prompt prompt) {
    print("setSelectedPrompt");
    _selectedPrompt = prompt;
    notifyListeners();
  }

  Future<void> fetchPrivatePrompts() async {
    print("fetchPrivatePrompts");
    _isLoading = true;
    final GetPromptResponse response = await _promptManager.fetchPrompts(
      query: "",
      offset: 0,
      limit: 100,
      isPublic: false,
    );
    _privatePrompts = response.items;

    _isLoading = false;
    notifyListeners();
  }

  void updateSelectedCategory(String category) {
    print(" updateSelectedCategory");
    _selectedCategory = category;
    notifyListeners();
  }

  Future<Map<String, dynamic>> createPrompt(Prompt prompt) async {
    print("createPrompt");
    final response = await _promptManager.createPrompt(
      category: prompt.category ?? "",
      content: prompt.content ?? "",
      description: prompt.description ?? "",
      isPublic: prompt.isPublic,
      language: prompt.language ?? "",
      title: prompt.title ?? "",
    );
    if (response["isPublic"]) {
      fetchPublicPrompts();
    } else {
      fetchPrivatePrompts();
    }
    return response;
  }

  Future<void> fetchPublicPrompts() async {
    print("fetchPublicPrompts");
    _isLoading = true;
    notifyListeners();
    final GetPromptResponse response = await _promptManager.fetchPrompts(
      query: "",
      offset: 0,
      limit: 100,
      isPublic: true,
    );
    _publicPrompts = response.items;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFavoritePrompts() async {
    print("fetchFavoritePrompts");
    _isLoading = true;
    notifyListeners();
    final GetPromptResponse response = await _promptManager.fetchPrompts(
      query: "",
      offset: 0,
      limit: 100,
      isFavorite: true,
    );
    _favoritePrompts = response.items;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFavoritePrompt(String promptId) async {
    print("addFavoritePrompt");
    await _promptManager.favoritePrompt(promptId: promptId);
    _updatePromptFavoriteState(promptId, true);
    fetchFavoritePrompts();
  }

  Future<void> removeFavoritePrompt(String promptId) async {
    print("removeFavoritePrompt");
    await _promptManager.unfavoritePrompt(promptId: promptId);
    _updatePromptFavoriteState(promptId, false);
    fetchFavoritePrompts();
  }

  Future<void> updatePrompt(Prompt prompt) async {
    print("updatePrompt");
    await _promptManager.updatePrompt(prompt: prompt);
    fetchPrivatePrompts();
  }

  Future<void> deletePrompt(String promptId) async {
    print("deletePrompt");
    await _promptManager.deletePrompt(promptId: promptId);
    fetchPrivatePrompts();
  }

  void _updatePromptFavoriteState(String promptId, bool isFavorite) {
    print("updatePromptFavoriteState");
    // Update public prompts
    for (var prompt in _publicPrompts) {
      if (prompt.id == promptId) {
        prompt.isFavorite = isFavorite;
      }
    }

    // Update private prompts
    for (var prompt in _privatePrompts) {
      if (prompt.id == promptId) {
        prompt.isFavorite = isFavorite;
      }
    }

    // Notify listeners to rebuild the UI
    notifyListeners();
  }
}
