//import 'dart:js';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_money/homeScreen.dart';
import 'package:my_money/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomeScreen();
  }

  _navigateToHomeScreen() async {
    await Future.delayed(Duration(milliseconds: 500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ScreenNavigator()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      child: SvgPicture.asset(
        'assets/images/SplashScreen.svg',
        fit: BoxFit.fill,
      ),
    ));
  }
}
