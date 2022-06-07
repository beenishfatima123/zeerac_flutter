import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {


  final width = Get.width;
  final height = Get.height;
  final Color? loaderColor;

  LoadingWidget({Key? key, this.loaderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: loaderColor ?? Get.theme.secondaryHeaderColor.withOpacity(0.5),
      child: Center(
          child: SpinKitCubeGrid(
            color: Get.theme.primaryColorDark,
            size: height * 0.08,
            duration: const Duration(milliseconds: 1000),
          )
      ),
    );
  }
}
