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

class PromptLibraryBottomDialog extends StatefulWidget {
  @override
  _PromptLibraryBottomDialogState createState() =>
      _PromptLibraryBottomDialogState();
}

class _PromptLibraryBottomDialogState extends State<PromptLibraryBottomDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  List<Prompt> filteredPrompts = [];
  List<Prompt> filteredFavoritePrompts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final promptProvider =
          Provider.of<PromptProvider>(context, listen: false);
      promptProvider.fetchPrivatePrompts();
      promptProvider.fetchPublicPrompts();
      promptProvider.fetchFavoritePrompts();

      setState(() {
        filteredPrompts = promptProvider.publicPrompts;
        filteredFavoritePrompts = promptProvider.favoritePrompts;
      });
    });

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _searchController.clear();
        final promptProvider =
            Provider.of<PromptProvider>(context, listen: false);
        if (_tabController.index == 1) {
          filteredPrompts = promptProvider.publicPrompts;
        } else if (_tabController.index == 2) {
          filteredFavoritePrompts = promptProvider.favoritePrompts;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context);

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            _buildHeader(),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'My Prompt'),
                Tab(text: 'Public Prompt'),
                Tab(text: 'Favorite Prompt'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  promptProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _buildMyPromptList(
                          promptProvider.privatePrompts, promptProvider),
                  promptProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _buildPublicPromptList(
                          promptProvider.publicPrompts,
                          promptProvider.categories,
                          promptProvider.selectedCategory,
                          promptProvider),
                  promptProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _buildFavoritePromptList(
                          promptProvider.favoritePrompts, promptProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Prompt Library",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

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
              return _buildPromptItem(prompt, promptProvider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromptItem(Prompt prompt, PromptProvider promptProvider) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () async {
          promptProvider.setSelectedPrompt(prompt);
          final result = await showDialog(
            context: context,
            builder: (context) => PromptDialog(),
          );
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
      ),
    );
  }

  Widget _buildCategoryList(List<String> categories, String selectedCategory,
      PromptProvider promptProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            onSelected: (selected) {
              setState(() {
                filteredPrompts = selected
                    ? promptProvider.publicPrompts
                        .where((p) => p.category == category)
                        .toList()
                    : promptProvider.publicPrompts;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          setState(() {
            filteredPrompts = filteredPrompts
                .where(
                    (p) => p.title!.toLowerCase().contains(value.toLowerCase()))
                .toList();
          });
        },
      ),
    );
  }

  Widget _buildFavoritePromptList(
      List<Prompt> favoritePrompts, PromptProvider promptProvider) {
    return ListView.builder(
      itemCount: favoritePrompts.length,
      itemBuilder: (context, index) {
        final prompt = favoritePrompts[index];
        return _buildPromptItem(prompt, promptProvider);
      },
    );
  }
}
