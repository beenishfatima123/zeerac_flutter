import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  AnimationController? motionController;
  var scale;

  RxBool isBuying = false.obs;

  @override
  void onInit() {
    motionController = AnimationController(
        duration: const Duration(seconds: 15),
        vsync: this,
        lowerBound: 0.0,
        upperBound: 0.3);
    motionController?.forward();
    motionController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        motionController?.reverse();
      } else if (status == AnimationStatus.dismissed) {
        motionController?.forward();
      }
    });

    super.onInit();
  }
}
