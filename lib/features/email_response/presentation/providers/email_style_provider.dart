import 'package:flutter/cupertino.dart';
import 'package:flutter_ai_app/utils/formality_enum.dart';
import 'package:flutter_ai_app/utils/length_enum.dart';
import 'package:flutter_ai_app/utils/tone_enum.dart';

class EmailStyleProvider  with ChangeNotifier{
  Formality originFormalityValue = Formality.neutral;
  Tone originToneValue = Tone.friendly;
  Length originLengthValue = Length.long;
  List<Length> originListLength = [Length.short, Length.medium, Length.long];
  List<Formality> originListFormality = [Formality.casual, Formality.neutral, Formality.formal];
  List<Tone> originListTone = [Tone.witty, Tone.empathetic, Tone.personable, Tone.concerned, Tone.friendly, Tone.direct, Tone.sincere,
  Tone.optimistic, Tone.confident, Tone.informational, Tone.enthusiastic];

  bool isDecided = false;
  // theo thứ tự [short, medium, length]
  List<bool> lengthEmail = [false, false, true];  
  // theo thứ tự [casual, neutral, formal]
  List<bool> formalityEmail = [false, true, false];
  //theo thứ tự [witty, empathetic, personable, concerned, friendly, direct,
  //sincere, optimistic, confident, informational, enthusiastic ]
  List<bool> toneEmail = [false, false, false , false, true, false, false, false, false, false, false];
  List<bool> getListLength()  {return this.lengthEmail;}
  List<bool> getListFormality() {return this.formalityEmail;}
  List<bool> getListTone() {return this.toneEmail;}
  Length getChosenLength(){
    for(int i = 0; i < lengthEmail.length; ++i){
      if(lengthEmail[i]){
        print("GET CHOOSEN LENGTH ${originListLength[i]}");
        return originListLength[i];
      }
    }
    return originLengthValue;
  }
  Formality getChosenFormality(){
    for(int i = 0; i < formalityEmail.length; ++i){
      if(formalityEmail[i]){
        return originListFormality[i];
      }
    }
    return originFormalityValue;
  }

  Tone getChosenTone(){
    for(int i = 0; i < toneEmail.length; ++i){
      if(toneEmail[i]){
        return originListTone[i];
      }
    }
    return originToneValue;
  }

  void updateListLength(int position){
    for(int i = 0; i < lengthEmail.length; ++i){
      lengthEmail[i] = false;
    }
    lengthEmail[position] = true;
    notifyListeners();
  }
  void updateListFormality(int position){
    for(int i = 0; i < formalityEmail.length; ++i){
      formalityEmail[i] = false;
    }
    formalityEmail[position] = true;
    notifyListeners();
  }
  void updateListTone(int position){
    for(int i = 0; i < toneEmail.length; ++i){
      toneEmail[i] = false;
    }
    toneEmail[position] = true;
    notifyListeners();
  }
  void updateIsDecided(bool value){
    isDecided = value;
  }


  void resetOriginValue(Length length, Formality formality, Tone tone){
    var lengthPos = originListLength.indexOf(length);
    var formalityPos = originListFormality.indexOf(formality);
    var tonePos = originListTone.indexOf(tone);
    updateListFormality(formalityPos);
    updateListLength(lengthPos);
    updateListTone(tonePos);
  }
}