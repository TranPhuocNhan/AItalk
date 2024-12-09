class SuggestIdeaRequest {
  String action = "Suggest 3 ideas for this email";
  String email;
  String language;
  SuggestIdeaRequest({
    required this.email,
    required this.language,
  });
}