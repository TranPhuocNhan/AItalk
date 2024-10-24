import 'package:flutter/material.dart';

class AISearchSection extends StatelessWidget {
  const AISearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("AI Search"),
        subtitle: const Text("Search for AI"),
        trailing: const Icon(Icons.search),
        onTap: () {},
      ),
    );
  }
}
