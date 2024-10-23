
class TestEmail{
  String sender = "";
  String content = "";  
  TypeSender type = TypeSender.SYSTEM;
  TestEmail(String sender, String content, TypeSender type){
    this.sender = sender;
    this.content = content;
    this.type = type;
  }
  static List<TestEmail> CreateSampleData(){
    List<TestEmail> output = [
      new TestEmail("ABC", """ Chào Thịnh,

Hy vong ban đang có một tuần tốt lành! Cuối tuần này, tôi đang dư đinh khám phá một số nơi mới ở thành phố. Ban có muốn tham gia cùng tôi không? Đó sẽ là một cơ hôi tuyệt vời để chúng ta trò chuyên và thư giãn sau những ngày làm việc Nếu ban quan tâm, hãy cho tôi biết và chúng ta có thế thảo luận thêm về kế hoạch. 

Chúc ban một ngày tốt lành!""", TypeSender.USER),
      new TestEmail("Javis","""Chào Khoa,

Cảm ơn bạn đã mời tôi tham gia cùng bạn vào cuối tuần này. Tuy nhiên, tôi rất tiếc không thể tham gia được vì đã có kế hoạch khác vào thời điểm đó. Mong răng ban sẽ có một chuyến đi thú vị và đâx ý nghĩa. Chúc ban một ngày tốt lành! 

Thân ái,
Thinh""", TypeSender.SYSTEM),
new TestEmail("ABC", """ Chào Thịnh,

Hy vong ban đang có một tuần tốt lành! Cuối tuần này, tôi đang dư đinh khám phá một số nơi mới ở thành phố. Ban có muốn tham gia cùng tôi không? Đó sẽ là một cơ hôi tuyệt vời để chúng ta trò chuyên và thư giãn sau những ngày làm việc Nếu ban quan tâm, hãy cho tôi biết và chúng ta có thế thảo luận thêm về kế hoạch. 

Chúc ban một ngày tốt lành!""", TypeSender.USER),
    ];
    return output;
  }
}

// ignore: camel_case_types
enum TypeSender{
  SYSTEM, USER
}