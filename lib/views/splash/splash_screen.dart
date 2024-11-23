import 'package:flutter/material.dart';
import 'package:flutter_ai_app/views/splash/PageContent.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen>{
  var _currentIndex = 0;
  final PageController _pageController = PageController();
  final List<PageContent> pages = [
    PageContent(
      image: "assets/images/splash_chat.png", 
      title: "Chat your way!", 
      description: "Engage in dynamic conversations with a selection of AI bots tailored to your interests and needs", 
      color: Color(0xffd6ebd7)
    ),
    PageContent(
      image: "assets/images/splash_mail.png", 
      title: "Mail Master", 
      description: "Streamline your communication with intelligent email support that crafts personalized replies in a flash", 
      color: Color(0xffd6ebd7)
    ),
    PageContent(
      image: "assets/images/splash_prompt.png", 
      title: "Prompt Pro: Craft, Curate, Conquer!", 
      description: "Create and manage prompts effortlessly, unleashing your creativity and optimizing interactions with your AI", 
      color: Color(0xffd6ebd7)
    ),
    PageContent(
      image: "assets/images/logo_icon.png",
      title: "",
      description: "",
      color: Color(0xffd6ebd7)
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener((){
      setState(() {
        _currentIndex = _pageController.page!.round();        
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: pages.length,
        controller: _pageController,
        itemBuilder: (context, index){
          return Container(
            color: pages[index].color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Text( 
                        "${_currentIndex + 1} / ${pages.length}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff98acac)
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/login");
                      }, 
                      child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff5cd8c9),
                        fontWeight: FontWeight.bold
                      ),
                      )
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(pages[index].image),
                      SizedBox(height: 20,),
                      (index != 3) ? 
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(
                          pages[index].title,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5cd8c9)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ) : Text(""),
                      SizedBox(height: 20,),
                      (index != 4) ? 
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          pages[index].description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff98acac),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ) : Text(""),
                    ],
                  ),
                ),
                (index == 3) ?  
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/login');
                    }, 
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff5cd8c9),
                    )
                  )
                )
                  // Container(
                  // margin: EdgeInsets.only(top: 30, bottom: 50),
                  // width: 500,
                  //   alignment: Alignment.center,
                  //   child: Container(
                  //     width: MediaQuery.sizeOf(context).width/2,
                  //     decoration: ShapeDecoration(
                  //       shape: StadiumBorder(),
                  //       color: Color(0xff5cd8c9)
                  //     ),
                  //     child: ElevatedButton(
                  //       onPressed: () async{
                  //       }, 
                  //       child: Padding(
                  //         padding: EdgeInsets.all(10),
                  //         child: Text(
                  //           "Started", 
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 18
                  //             ),
                  //           ),
                  //         ),
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.transparent,
                  //         )
                  //       ),
                  //     )
                  // )
                : Text(""),
                // thanh chỉ dẫn 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length, 
                    (index){
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? Color(0xff98acac) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    })
                ),
                SizedBox(height: 20,),
              ],
            )
          );
        }
      ),
    );
  }
  
}

