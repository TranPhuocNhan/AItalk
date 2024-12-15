import 'package:flutter/material.dart';

class AISection extends StatelessWidget {
  const AISection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AI Selection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("I have these amazing powers:"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Basic Skills",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            _buildBasicSkillsSection(),
            const SizedBox(height: 10),
            const Text(
              "Advance Skills",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            _buildAdvanceSkillsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicSkillsSection() {
    return _buildPowerTitle("List Basic Skills");
  }

  Widget _buildAdvanceSkillsSection() {
    return _buildPowerTitle("List Advance Skills");
  }

  Widget _buildPowerTitle(String title) {
    return ListTile(
      title: Text(title),
    );
  }
}
