import 'package:flutter/material.dart';
import 'package:flutter_ai_app/widgets/create_prompt.dart';

class PromptLibraryScreen extends StatefulWidget {
  @override
  _PromptLibraryScreenState createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = [
    'All',
    'Marketing',
    'AI Painting',
    'Chatbot',
    'SEO',
    'Writing'
  ];
  String selectedCategory = 'All';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prompt Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'My Prompt'),
            Tab(text: 'Public Prompt'),
            Tab(text: 'Favorite Prompt'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab My Prompt
          _buildMyPromptList(),

          // Tab Public Prompt
          _buildPublicPromptList(),

          // Tab Favorite Prompt
          _buildFavoritePromptList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new prompt action
          showDialog(context: context, builder: (context) => PromptForm());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  // List of prompts for "My Prompt" tab
  Widget _buildMyPromptList() {
    final prompts = [
      {
        'title': 'Brainstorm',
        'description': 'Generate creative ideas for your project.',
        'isFavorite': false,
      },
      {
        'title': 'Translate to Japanese',
        'description': 'Quickly translate text into Japanese.',
        'isFavorite': false,
      },
      {
        'title': 'Grammar corrector',
        'description':
            'Improve your spelling and grammar by correcting errors in your writing.',
        'isFavorite': true,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: prompts.length,
      itemBuilder: (context, index) {
        final prompt = prompts[index];
        return _buildPromptItem(prompt);
      },
    );
  }

  Widget _buildPublicPromptList() {
    final prompts = [
      {
        'title': 'Grammar corrector',
        'description':
            'Improve your spelling and grammar by correcting errors in your writing.',
        'isFavorite': true,
      },
      {
        'title': 'Learn Code FAST!',
        'description':
            'Teach you the code with the most understandable knowledge.',
        'isFavorite': false,
      },
      {
        'title': 'Story generator',
        'description': 'Write your own beautiful story.',
        'isFavorite': false,
      },
      {
        'title': 'Essay improver',
        'description': 'Improve your content\'s effectiveness with ease.',
        'isFavorite': false,
      },
      {
        'title': 'Pro tips generator',
        'description': 'Get perfect tips and advice tailored to your field.',
        'isFavorite': false,
      },
      {
        'title': 'Resume Editing',
        'description':
            'Provide suggestions on how to improve your resume to make it stand out.',
        'isFavorite': false,
      },
      {
        'title': 'AI Painting Prompt Generator',
        'description':
            'Input your keywords and style to generate creative prompts.',
        'isFavorite': false,
      },
    ];
    return Column(
      children: [
        _buildSearchBar(),
        _buildCategoryList(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return _buildPublicPromptItem(prompt);
            },
          ),
        )
      ],
    );
  }

  // Widget to build each individual prompt item
  Widget _buildPromptItem(Map<String, dynamic> prompt) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(prompt['title'] ?? ''),
        subtitle: Text(prompt['description'] ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prompt['isFavorite']) Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                // Edit action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: categories.map((category) {
          return _buildFilterItem(category);
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }

  _buildPublicPromptItem(Map<String, dynamic> prompt) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(prompt['title'] ?? ''),
        subtitle: Text(prompt['description'] ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.star,
                  color: Colors.amber,
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

  Widget _buildFilterItem(String category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = selected ? category : 'All';
          });
        },
      ),
    );
  }

  Widget _buildFavoritePromptList() {
    final prompts = [
      {
        'title': 'Grammar corrector',
        'description':
            'Improve your spelling and grammar by correcting errors in your writing.',
        'isFavorite': true,
      },
      {
        'title': 'Learn Code FAST!',
        'description':
            'Teach you the code with the most understandable knowledge.',
        'isFavorite': false,
      },
      {
        'title': 'Story generator',
        'description': 'Write your own beautiful story.',
        'isFavorite': false,
      },
      {
        'title': 'Essay improver',
        'description': 'Improve your content\'s effectiveness with ease.',
        'isFavorite': false,
      },
      {
        'title': 'Pro tips generator',
        'description': 'Get perfect tips and advice tailored to your field.',
        'isFavorite': false,
      },
      {
        'title': 'Resume Editing',
        'description':
            'Provide suggestions on how to improve your resume to make it stand out.',
        'isFavorite': false,
      },
      {
        'title': 'AI Painting Prompt Generator',
        'description':
            'Input your keywords and style to generate creative prompts.',
        'isFavorite': false,
      },
    ];
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              if (prompt['isFavorite'] == true) {
                return _buildPublicPromptItem(prompt);
              }
            },
          ),
        )
      ],
    );
  }
}
