import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/prompt/presentation/providers/prompt_provider.dart';
import 'package:flutter_ai_app/features/prompt/presentation/widgets/create_prompt.dart';
import 'package:flutter_ai_app/features/prompt/presentation/widgets/edit_prompt_form.dart';
import 'package:flutter_ai_app/utils/category_prompt_map.dart';
import 'package:provider/provider.dart';

import '../widgets/prompt_dialog.dart';

class PromptLibraryScreen extends StatefulWidget {
  PromptLibraryScreen({super.key});
  @override
  _PromptLibraryScreenState createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  List<Prompt> filteredPrompts = [];
  List<Prompt> filteredFavoritePrompts = [];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PromptProvider>(context, listen: false).fetchPrivatePrompts();
      Provider.of<PromptProvider>(context, listen: false).fetchPublicPrompts();
      Provider.of<PromptProvider>(context, listen: false)
          .fetchFavoritePrompts();
      setState(() {
        filteredPrompts =
            Provider.of<PromptProvider>(context, listen: false).publicPrompts;
        filteredFavoritePrompts =
            Provider.of<PromptProvider>(context, listen: false).favoritePrompts;
      });
    });
    tabController.addListener(() {
      setState(() {
        _searchController.clear();
        if (tabController.index == 1) {
          filteredPrompts =
              Provider.of<PromptProvider>(context, listen: false).publicPrompts;
        } else if (tabController.index == 2) {
          filteredFavoritePrompts =
              Provider.of<PromptProvider>(context, listen: false)
                  .favoritePrompts;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context);
    print("PromptLibraryScreen build...");
    return Scaffold(
      appBar: AppBar(
        title: null,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'My Prompt'),
            Tab(text: 'Public Prompt'),
            Tab(text: 'Favorite Prompt'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Tab My Prompt
          promptProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildMyPromptList(
                  promptProvider.privatePrompts, promptProvider),

          // Tab Public Prompt
          promptProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildPublicPromptList(
                  promptProvider.publicPrompts,
                  promptProvider.categories,
                  promptProvider.selectedCategory,
                  promptProvider),

          // Tab Favorite Prompt
          promptProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildFavoritePromptList(
                  promptProvider.favoritePrompts, promptProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add new prompt action
          final result = await showDialog(
              context: context, builder: (context) => PromptForm());
          if (result != null) {
            final prompt = Prompt(
              id: "",
              isFavorite: false,
              isPublic: result["isPublic"],
              category: result["category"],
              content: result["content"],
              description: result["description"],
              language: result["language"],
              title: result["title"],
            );
            await promptProvider.createPrompt(prompt);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  // List of prompts for "My Prompt" tab
  Widget _buildMyPromptList(
      List<Prompt> privatePrompts, PromptProvider promptProvider) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: privatePrompts.length,
      itemBuilder: (context, index) {
        final prompt = privatePrompts[index];
        return _buildPromptItem(prompt, promptProvider);
      },
    );
  }

  Widget _buildPublicPromptList(
      List<Prompt> publicPrompts,
      List<String> categories,
      String selectedCategory,
      PromptProvider promptProvider) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildCategoryList(categories, selectedCategory, promptProvider),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredPrompts.length,
            itemBuilder: (context, index) {
              final prompt = filteredPrompts[index];
              return _buildPublicPromptItem(prompt, promptProvider);
            },
          ),
        )
      ],
    );
  }

  // Widget to build each individual prompt item
  Widget _buildPromptItem(Prompt prompt, PromptProvider promptProvider) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () async {
          promptProvider.setSelectedPrompt(prompt);
          final result = await showDialog(
              context: context,
              builder: (BuildContext context) => PromptDialog());
        },
        title: Text(prompt.title ?? ''),
        subtitle: Text(prompt.description ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(categoryPromptMap[prompt.category] ?? ''),
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              backgroundColor: Colors.blue.shade400,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 0),
                  borderRadius: BorderRadius.circular(10)),
            ),
            if (prompt.isFavorite) Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                // Edit action
                final result = await showDialog(
                    context: context,
                    builder: (context) =>
                        EditPromptForm(promptData: prompt.toJson()));

                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Prompt updated")),
                  );
                  final updatedPrompt = Prompt(
                    id: prompt.id,
                    isFavorite: false,
                    isPublic: result["isPublic"],
                    category: result["category"],
                    content: result["content"],
                    description: result["description"],
                    language: result["language"],
                    title: result["title"],
                  );
                  await promptProvider.updatePrompt(updatedPrompt);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await promptProvider.deletePrompt(prompt.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Prompt deleted")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditPromptDialog(Prompt prompt, PromptProvider promptProvider) {
    return AlertDialog(
      title: Text("Edit Prompt"),
      content: PromptForm(),
    );
  }

  Widget _buildCategoryList(List<String> categories, String selectedCategory,
      PromptProvider promptProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: categories.map((category) {
          return _buildFilterItem(category, selectedCategory, promptProvider);
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          fillColor: Colors.grey[200],
          filled: true,
        ),
        onChanged: (value) {
          setState(() {
            if (tabController.index == 1) {
              if (value.isEmpty) {
                filteredPrompts =
                    Provider.of<PromptProvider>(context, listen: false)
                        .publicPrompts;
              } else {
                filteredPrompts =
                    Provider.of<PromptProvider>(context, listen: false)
                        .publicPrompts
                        .where((prompt) => (prompt.title?.toLowerCase() ?? "")
                            .contains(value.toLowerCase()))
                        .toList();
              }
            } else if (tabController.index == 2) {
              if (value.isEmpty) {
                filteredFavoritePrompts =
                    Provider.of<PromptProvider>(context, listen: false)
                        .favoritePrompts;
              } else {
                filteredFavoritePrompts =
                    Provider.of<PromptProvider>(context, listen: false)
                        .favoritePrompts
                        .where((prompt) => (prompt.title?.toLowerCase() ?? "")
                            .contains(value.toLowerCase()))
                        .toList();
              }
            }
          });
        },
      ),
    );
  }

  Widget _buildPublicPromptItem(Prompt prompt, PromptProvider promptProvider) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () async {
          promptProvider.setSelectedPrompt(prompt);
          final result = await showDialog(
              context: context,
              builder: (BuildContext context) => PromptDialog());
          if (result != null) {
            final chatProvider =
                Provider.of<ChatProvider>(context, listen: false);
            chatProvider.sendFirstMessage(ChatMessage(
                assistant: AssistantDTO(
                    id: chatProvider.selectedAssistant?.id ??
                        Assistant.assistants.first.id,
                    model: 'dify',
                    name: chatProvider.selectedAssistant?.name ??
                        Assistant.assistants.first.name),
                role: "user",
                content: result));
            chatProvider.setSelectedScreenIndex(0);
            chatProvider.toggleChatContentView();
          }
        },
        title: Text(prompt.title ?? ''),
        subtitle: Text(prompt.description ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(categoryPromptMap[prompt.category] ?? ''),
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              backgroundColor: Colors.blue.shade400,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 0),
                  borderRadius: BorderRadius.circular(10)),
            ),
            IconButton(
                onPressed: () async {
                  if (prompt.isFavorite) {
                    prompt.setIsFavorite(false);
                    await promptProvider.removeFavoritePrompt(prompt.id);
                  } else {
                    prompt.setIsFavorite(true);
                    await promptProvider.addFavoritePrompt(prompt.id);
                  }
                },
                icon: Icon(
                  Icons.star,
                  color: prompt.isFavorite ? Colors.amber : Colors.grey,
                )),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Copy action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterItem(
      String category, String selectedCategory, PromptProvider promptProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              if (_searchController.text.isNotEmpty) {
                filteredPrompts = promptProvider.publicPrompts
                    .where((prompt) =>
                        prompt.category?.toLowerCase() ==
                            category.toLowerCase() &&
                        (prompt.title?.toLowerCase() ?? "")
                            .contains(_searchController.text.toLowerCase()))
                    .toList();
              } else {
                filteredPrompts = promptProvider.publicPrompts
                    .where((prompt) =>
                        prompt.category?.toLowerCase() ==
                        category.toLowerCase())
                    .toList();
              }
              promptProvider.updateSelectedCategory(category);
            } else {
              filteredPrompts = promptProvider.publicPrompts;
              promptProvider.updateSelectedCategory('All');
            }
          });
        },
      ),
    );
  }

  Widget _buildFavoritePromptList(
      List<Prompt> favoritePrompts, PromptProvider promptProvider) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredFavoritePrompts.length,
            itemBuilder: (context, index) {
              final prompt = filteredFavoritePrompts[index];
              return _buildPublicPromptItem(prompt, promptProvider);
            },
          ),
        )
      ],
    );
  }
}
