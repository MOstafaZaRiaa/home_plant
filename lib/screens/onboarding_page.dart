import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:home_plant/widgts/switch_betwen_fisrt_pages.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:home_plant/getX/onboarding.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onBoarding = Get.put(OnBoardingGetX());
    final deviceWidth = MediaQuery.of(context).size.width;
    return SimpleBuilder(
      builder: (BuildContext context )=>
          IntroductionScreen(
        pages: [
          buildPageViewModel(
            deviceWidth,
            'Let\'s to plant our planet.',
            'Here you can find all different plants.',
            'assets/images/1.png',
          ),
          buildPageViewModel(
            deviceWidth,
            'Very beautiful plants.',
            'Here you can find all different plants.',
            'assets/images/2.png',
          ),
          buildPageViewModel(
            deviceWidth,
            'Order now what you favorite.',
            'Here you can receive products immediately.',
            'assets/images/3.png',
          ),
          buildPageViewModel(
            deviceWidth,
            'Let\'s to make it better.',
            'Order Now.',
            'assets/images/4.png',
          ),
        ],
        onDone: () {
          onBoarding.changeIsFirst(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SwitchBetweenFirstPages(),
            ),
          );
        },
        done: Text(
          'Order Now',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        showSkipButton: true,
        nextFlex: 0,
        skipFlex: 0,
        skip: Text('Skip',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,),),
        next: Icon(Icons.arrow_forward,color: Theme.of(context).primaryColor,),
        animationDuration: 1000,
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColor,
          size: Size(10,10),
          activeSize: Size(22,10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          )
        ),
      ),
    );
  }

  PageViewModel buildPageViewModel(
    double deviceWidth,
    String title,
    String body,
    String image,
  ) {
    return PageViewModel(
      title: title,
      body: body,
      image: Image.asset(
        image,
        width: deviceWidth * 0.7,
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 20,
        ),
        descriptionPadding: EdgeInsets.all(16).copyWith(
          bottom: 0,
        ),
        imagePadding: EdgeInsets.all(24).copyWith(
          bottom: 0,
        ),
      ),
    );
  }
}
