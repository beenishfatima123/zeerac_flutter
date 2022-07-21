import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/pages/dashboard/dashboard_page.dart';
import 'package:zeerac_flutter/modules/users/pages/login/login_page.dart';
import '../utils/user_defaults.dart';

class SplashScreen extends StatefulWidget {
  static const id = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () => {gotoRelevantScreenOnUserType()});
  }

  void gotoRelevantScreenOnUserType() {
    Get.offNamed(DashBoardPage.id);
    /*if (UserDefaults.getUserSession() != null) {
      Get.offNamed(DashBoardPage.id);
    } else {
      Get.offNamed(LoginPage.id);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
