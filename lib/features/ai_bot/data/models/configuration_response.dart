abstract class ConfigurationResponse {
  String type;
  String id;
  String assistantId;
  String redirect;
  ConfigurationResponse({
    required this.type,
    required this.id,
    required this.assistantId,
    required this.redirect,
  });
}