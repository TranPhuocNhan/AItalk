import 'package:flutter/material.dart';

class Managetokenprovider with ChangeNotifier{
  bool _isUnlimited = false;
  int _totalTokens = 0;
  int _available = 0;
  void updateRemainToken(int value){
    _available = value;
    notifyListeners();
  }
  void updateTotalToken(int value){
    _totalTokens = value;
    notifyListeners();
  }
  void setIsUnlimited(){
    _isUnlimited = !_isUnlimited;
    notifyListeners();
  }
  int getRemainToken(){return _available;}
  int getTotalToken(){return _totalTokens;}  
  int getPercentage(){
    if(_totalTokens == 0 || _available == 0 ) {
      return 0;
    }
    else {
      var percent = (_available.toDouble() / _totalTokens.toDouble()).toInt();
      return percent;
    }
  }
  bool getIsUnlimited(){return _isUnlimited;}

  void decreateRemaining(){
    _available -= 1;
    notifyListeners();
  }



}