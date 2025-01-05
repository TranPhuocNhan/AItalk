import 'package:flutter/material.dart';
import 'package:flutter_ai_app/core/models/assistant.dart';
import 'package:flutter_ai_app/features/ai_chat/data/models/assistant_dto.dart';
import 'package:flutter_ai_app/features/ai_chat/domains/entities/chat_message.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/providers/chat_provider.dart';
import 'package:flutter_ai_app/features/ai_chat/presentation/screens/chat_content_view.dart';
import 'package:flutter_ai_app/features/prompt/data/prompt.dart';
import 'package:flutter_ai_app/features/prompt/presentation/providers/prompt_provider.dart';
import 'package:flutter_ai_app/features/prompt/presentation/widgets/prompt_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ai_app/utils/category_prompt_map.dart';

class PromptLibraryBottomDialog extends StatefulWidget {
  @override
  _PromptLibraryBottomDialogState createState() =>
      _PromptLibraryBottomDialogState();
}

class _PromptLibraryBottomDialogState extends State<PromptLibraryBottomDialog>
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
    return Stack(children: [
      Scaffold(
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
          )),
      if (promptProvider.isLoading)
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ]);
  }

  // List of prompts for "My Prompt" tab
  Widget _buildMyPromptList(
      List<Prompt> privatePrompts, PromptProvider promptProvider) {
    return Column(children: [
      _buildSearchBar(promptProvider),
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
        _buildSearchBar(promptProvider),
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
          ],
        ),
      ),
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

  Widget _buildSearchBar(PromptProvider promptProvider) {
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
              promptProvider.updateSearchMyPromptQuery(searchQuery);
            } else if (tabController.index == 1) {
              promptProvider.updateSearchPublicPromptQuery(searchQuery);
            } else if (tabController.index == 2) {
              promptProvider.updateSearchFavoritePromptQuery(searchQuery);
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
          if (selected) {
            promptProvider.updateSelectedCategory(category);
          } else {
            promptProvider.updateSelectedCategory("All");
          }
        },
      ),
    );
  }

  Widget _buildFavoritePromptList(
      List<Prompt> favoritePrompts, PromptProvider promptProvider) {
    return Column(
      children: [
        _buildSearchBar(promptProvider),
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
