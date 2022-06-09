import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';

getTextField(
    {required String hintText,
    required TextEditingController controller,
    String? validateText,
    bool validate = true,
    bool enabled = true,
    int minLines = 1,
    int maxLines = 2,
    List<TextInputFormatter> inputFormatters = const [],
    TextInputType inputType = TextInputType.text,
    validator}) {
  return MyTextField(
      controller: controller,
      enable: enabled,
      hintText: hintText,
      minLines: minLines,
      maxLines: maxLines,
      contentPadding: 20,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      focusBorderColor: AppColor.primaryBlueDarkColor,
      textColor: AppColor.blackColor,
      hintColor: AppColor.blackColor,
      fillColor: AppColor.alphaGrey,
      validator: validator ??
          (String? value) => validate
              ? (value!.trim().isEmpty ? validateText ?? "Required" : null)
              : null);
}

Widget getImageWidget(Rx<File?> file) {
  return Stack(
    children: [
      (file.value != null)
          ? CircleAvatar(
              radius: 70, backgroundImage: Image.file(file.value!).image)
          : const CircleAvatar(
              radius: 70,
              backgroundImage:
                  AssetImage('assets/images/place_your_image.png')),
      Positioned(
        bottom: 1,
        right: 10,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  50,
                ),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 4),
                  color: Colors.black.withOpacity(
                    0.3,
                  ),
                  blurRadius: 3,
                ),
              ]),
          child: const Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(Icons.add_a_photo, color: Colors.black),
          ),
        ),
      ),
    ],
  );
}
