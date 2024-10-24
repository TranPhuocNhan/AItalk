class ThreadChat {
  final String threadId;
  final String title;
  final List<Map<String, String>> messages;
  final String status;
  final String description;
  final DateTime time;

  ThreadChat(
      {required this.threadId,
      required this.title,
      required this.messages,
      required this.status,
      required this.description,
      required this.time});
}
