import 'package:flutter_ai_app/utils/language_enum.dart';

class LanguageConverter{
  String Convert(Language input) {
    switch(input){
      case Language.Auto : {
        return "Auto";
      }
      case Language.English: {
        return "English";
      }
      case Language.Spanish: {
        return "Spanish";
      }
      case Language.French:{
        return "French";
      }
      case Language.German: {
        return "German";
      }
      case Language.Italian:{
        return "Italian";
      }
      case Language.Portuguese:{
        return "Portuguese";
      }
      case Language.Russian:{
        return "Russian";
      }
      case Language.Chinese:{
        return "Chinese";
      }
      case Language.Vietnamese: {
        return "Vietnamese";
      }
      default:{
        return "Auto";
      }
    }
  }
}