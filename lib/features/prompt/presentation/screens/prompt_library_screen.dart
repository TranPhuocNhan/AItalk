import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_content_view.dart';
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
  List<Prompt> filteredMyPrompts = [];
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
        } else if (tabController.index == 0) {
          filteredMyPrompts =
              Provider.of<PromptProvider>(context, listen: false)
                  .privatePrompts;
        }
      });
    });
  }

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context, listen: true);
    filteredPrompts = promptProvider.getFilteredPublicPrompts();
    filteredFavoritePrompts = promptProvider.getFilteredFavoritePrompts();
    filteredMyPrompts = promptProvider.getFilteredPrivatePrompts();
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
          _buildMyPromptList(
            promptProvider.getFilteredPrivatePrompts(),
            promptProvider,
          ),

          // Tab Public Prompt
          _buildPublicPromptList(
            promptProvider.getFilteredPublicPrompts(),
            promptProvider.categories,
            promptProvider.selectedCategory,
            promptProvider,
          ),

          // Tab Favorite Prompt
          _buildFavoritePromptList(
            promptProvider.getFilteredFavoritePrompts(),
            promptProvider,
          ),
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
              isPublic:
                  result["isPublic"], // Đảm bảo các key tồn tại trong result
              category: result["category"],
              content: result["content"],
              description: result["description"],
              language: result["language"],
              title: result["title"],
            );
            final response = await promptProvider.createPrompt(prompt);
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
    return Column(children: [
      _buildSearchBar(),
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: filteredMyPrompts.length,
          itemBuilder: (context, index) {
            final prompt = filteredMyPrompts[index];
            return _buildPromptItem(prompt, promptProvider);
          },
        ),
      )
    ]);
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

          final chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          if (result != null && result.isNotEmpty) {
            final content = result['content'] as String;

            final message = ChatMessage(
              assistant: AssistantDTO(
                id: chatProvider.selectedAssistant?.id ??
                    Assistant.assistants.first.id,
                model: 'dify',
                name: chatProvider.selectedAssistant?.name ??
                    Assistant.assistants.first.name,
              ),
              role: "user",
              content: content,
            );

            chatProvider
                .addUserMessage(message); // Add message to user's message list

            try {
              // Send message
              await chatProvider.sendFirstMessage(message);

              // Clean up and navigate to ChatContentView
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatContentView()),
              );
            } catch (e) {
              print("Error sending first message: $e");
            }
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
            searchQuery = _searchController.text;
            if (tabController.index == 0) {
              Provider.of<PromptProvider>(context, listen: false)
                  .updateSearchMyPromptQuery(searchQuery);
            } else if (tabController.index == 1) {
              Provider.of<PromptProvider>(context, listen: false)
                  .updateSearchPublicPromptQuery(searchQuery);
            } else if (tabController.index == 2) {
              Provider.of<PromptProvider>(context, listen: false)
                  .updateSearchFavoritePromptQuery(searchQuery);
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
          final chatProvider =
              Provider.of<ChatProvider>(context, listen: false);
          if (result != null && result.isNotEmpty) {
            final content = result['content'] as String;

            final message = ChatMessage(
              assistant: AssistantDTO(
                id: chatProvider.selectedAssistant?.id ??
                    Assistant.assistants.first.id,
                model: 'dify',
                name: chatProvider.selectedAssistant?.name ??
                    Assistant.assistants.first.name,
              ),
              role: "user",
              content: content,
            );

            chatProvider.addUserMessage(
                message); // Thêm tin nhắn vào danh sách tin nhắn của người dùng

            try {
              // Gửi tin nhắn
              await chatProvider.sendFirstMessage(message);

              // Dọn dẹp và chuyển hướng đến ChatContentView
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatContentView()),
              );
            } catch (e) {
              print("Error sending first message: $e");
            }
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
