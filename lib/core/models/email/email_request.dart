import 'package:injectable/injectable.dart';

class EmailRequest {
  final String mainIdea;
  final String action = "Reply to this email";
  final String email;
  final String length;
  final String formality;
  final String tone;
  final String language;
  @singleton
  EmailRequest({
    required this.mainIdea,
    required this.email,
    required this.length,
    required this.formality,
    required this.tone,
    required this.language,
  });
}