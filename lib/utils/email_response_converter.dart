import 'package:flutter_ai_app/utils/formality_enum.dart';
import 'package:flutter_ai_app/utils/length_enum.dart';
import 'package:flutter_ai_app/utils/tone_enum.dart';

class EmailResponseConverter {
  String convertLength(Length input){
    switch(input){
      case Length.long: {
        return "long";
      }
      case Length.medium: {
        return "medium";
      }
      case Length.short: {
        return "short";
      }
      default:{
        return "long";
      }
    }
  }
  String convertTone(Tone input){
    switch(input){
      case Tone.concerned:{
        return "concerned";
      }
      case Tone.confident:{
        return "confident";
      }
      case Tone.direct:{
        return "direct";
      }
      case Tone.empathetic:{
        return "empathetic";
      }
      case Tone.enthusiastic:{
        return "enthusiastic";
      }
      case Tone.friendly:{
        return "friendly";
      }
      case Tone.informational:{
        return "informational";
      }
      case Tone.optimistic:{
        return "optimistic";
      }
      case Tone.personable:{
        return "personable";
      }
      case Tone.sincere:{
        return "sincere";
      }
      case Tone.witty:{
        return "witty";
      }
      default:{
        return "auto";
      }
    }
  }
  String ConvertFormality(Formality input){
    switch(input){
      case Formality.casual:{
        return "casual";
      }
      case Formality.formal:{
        return "formal";
      }
      case Formality.neutral:{
        return "neutral";
      }
      default:{
        return "neutral";
      }
    }
  }
}