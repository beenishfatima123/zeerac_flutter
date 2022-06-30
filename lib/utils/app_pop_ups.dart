import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/my_application.dart';
import 'package:flutter/material.dart';

class AppPopUps {
 static bool isDialogShowing = true;

  static void showSnackBar(
      {required String message,
      required BuildContext context,
      Color color = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showDialogContent(
      {DialogType dialogType = DialogType.WARNING,
      String? title,
      onOkPress,
      onCancelPress,
      String? description,
      Widget? body}) {
    AwesomeDialog(
      context: myContext!,
      animType: AnimType.SCALE,
      dialogType: dialogType,
      body: body,
      title: title ?? '',
      desc: description ?? '',
      dismissOnTouchOutside: false,
      btnOkOnPress: onOkPress ??
          () {
            //Navigator.pop(myContext!);
          },
      btnCancelOnPress: onCancelPress ??
          () {
            // Get.back();
          },
    ).show();
  }

  dissmissDialog() {
    if (isDialogShowing) {
      navigatorKey.currentState!.pop();
    }
  }

 static showProgressDialog({BuildContext? context, bool? barrierDismissal}) {
    isDialogShowing = true;
    showDialog(
        useRootNavigator: false,
        useSafeArea: false,
        barrierDismissible: barrierDismissal ?? false,
        context: context!,
        builder: (context) => Center(
              child: Container(
                decoration: BoxDecoration(
                  //color: AppColors(..blackcardsBackground,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(25.r)),
                  boxShadow: [
                    BoxShadow(
                      //  color: AppColors().shadowColor,
                      color: Colors.transparent,
                      spreadRadius: 5.r,
                      blurRadius: 5.r,
                      offset: const Offset(3, 5), // changes position of shadow
                    ),
                  ],
                ),
                height: 120.h,
                width: 120.h,
                //  child: Lottie.asset(AssetsNames().loader),
                child: const CircularProgressIndicator(),
              ),
            )).then((value) {
      isDialogShowing = false;
    });
  }
}
