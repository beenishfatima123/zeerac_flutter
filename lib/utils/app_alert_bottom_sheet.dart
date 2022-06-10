import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeerac_flutter/common/styles.dart';

class AppBottomSheets {
  //bool isDialogShowing = false;
  static final AppBottomSheets _singleton = AppBottomSheets._internal();

  factory AppBottomSheets() {
    return _singleton;
  }

  AppBottomSheets._internal();

  static showAppAlertBottomSheet(
      {isDismissable,
      required Widget child,
      BuildContext? context,
      String title = '',
      bool isFull = false}) {
    //   isDialogShowing =true;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        isScrollControlled: isFull,
        enableDrag: false,
        context: context!,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(top: 80.h, left: 30.w, right: 30.w),
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100.r),
                  topLeft: Radius.circular(100.r)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.textStyleBoldBodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: AppColor.blackColor,
                      ),
                    )
                  ],
                ),
                Expanded(child: child)
              ],
            ),
          );
        });
  }
}
