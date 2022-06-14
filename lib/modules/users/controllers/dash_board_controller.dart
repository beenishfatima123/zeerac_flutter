import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/languages.dart';

class DashBoardController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isLoading = false.obs;

  RxInt selectedIndex = 0.obs;

  var languageName = Languages.getCurrentLanguageName().obs;
}
