class Assistant {
  final String name;
  final String id;
  final String imagePath;
  final bool isDefault;

  Assistant({
    required this.name,
    required this.id,
    required this.imagePath,
    required this.isDefault,
  });

  static List<Assistant> assistants = [
    Assistant(
      name: "GPT-4o",
      id: "gpt-4o",
      imagePath: "assets/images/ai_icon/gpt4o_icon.png",
      isDefault: true,
    ),
    Assistant(
      name: "Gpt-4o Mini",
      id: "gpt-4o-mini",
      imagePath: "assets/images/ai_icon/gpt4o_icon.png",
      isDefault: true,
    ),
    Assistant(
      name: "Claude 3.5 Sonnet",
      id: "claude-3-5-sonnet-20240620",
      imagePath: "assets/images/ai_icon/claude_icon.png",
      isDefault: true,
    ),
    Assistant(
      name: "Claude 3.0 Haiku",
      id: "claude-3-haiku-20240307",
      imagePath: "assets/images/ai_icon/claude_icon.png",
      isDefault: true,
    ),
    Assistant(
      name: "Gemini 1.5 Flash Latest",
      id: "gemini-1.5-flash-latest",
      imagePath: "assets/images/gemini_icon.png",
      isDefault: true,
    ),
  ];
}
