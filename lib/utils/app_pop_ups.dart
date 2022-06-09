import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/my_application.dart';

class AppPopUps {
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

  static void showDialog(
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
}
