import 'package:flutter_ai_app/features/email_response/presentation/email_style_provider.dart';
import 'package:flutter_ai_app/utils/email_response_style.dart';

class EmailStyleManager {
  List<bool> getAndUpdateEmailResponseStyle(EmailStyleProvider styleManage, EmailResponseStyle style, int position){
    switch(style){
      case EmailResponseStyle.LENGTH: {
        styleManage.updateListLength(position);
        return styleManage.getListLength();
      }
      case EmailResponseStyle.FORMALITY: {
        styleManage.updateListFormality(position);
        return styleManage.getListFormality();
      }
      case EmailResponseStyle.TONE: {
        styleManage.updateListTone(position);
        return styleManage.getListTone();
      }
      default: {
        styleManage.updateListLength(position);
        return styleManage.getListLength();
      }
    }
  }
  
  List<bool> getEmailResponseType(EmailStyleProvider styleManage, EmailResponseStyle style){
    switch(style){
      case EmailResponseStyle.LENGTH:{
        return styleManage.getListLength();
      }
      case EmailResponseStyle.FORMALITY: {
        return styleManage.getListFormality();
      }
      case EmailResponseStyle.TONE:{
        return styleManage.getListTone();
      }
      default:{
        return styleManage.getListLength();
      }
    }
  }
}