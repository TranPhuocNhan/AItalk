import 'package:flutter/material.dart';

class FreeUnlimitedSection extends StatelessWidget {
  const FreeUnlimitedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        trailing: Icon(Icons.star),
        title: Text("Free Unlimited Queries, Click here!"),
      ),
    );
  }
}
