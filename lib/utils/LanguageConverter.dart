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
      // case Language.Portuguese:{
      //   return "Portuguese";
      // }
      case Language.Portuguese1:{
        return "Brazil";
      }
      case Language.Portuguese2:{
        return "Portugal";
      }
      case Language.Russian:{
        return "Russian";
      }
      // case Language.Chinese:{
      //   return "Chinese";
      // }
      case Language.Vietnamese: {
        return "Vietnamese";
      }
      case Language.Arabic:{
        return "Arabic";
      }
      case Language.Chinese1:{
        return "Hong Kong";
      }
      case Language.Chinese2:{
        return "Simplified";
      }
      case Language.Chinese3:{
        return "Taiwan";
      }
      case Language.Czech: {
        return "Czech";
      }
      case Language.Dutch:{
        return "Dutch";
      }
      case Language.Hindi:{
        return "Hindi";
      }
      case Language.Indonesia:{
        return "Indonesia";
      }
      case Language.Japanese:{
        return "Japanese";
      }
      case Language.Korean:{
        return "Korean";
      }
      case Language.Persian:{
        return "Persian";
      }
      case Language.Polish:{
        return "Polish";
      }
      case Language.Spanish:{
        return "Latin America and Caribbean";
      }
      case Language.Thai:{
        return "Thailand";
      }
      case Language.Turkish:{
        return "Turkish";
      }
      case Language.Ukrainian:{
        return "Ukrainian";
      }
      default:{
        return "Auto";
      }
    }
  }
}