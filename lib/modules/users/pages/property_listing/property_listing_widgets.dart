import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_detail_page.dart';
import 'package:zeerac_flutter/utils/app_utils.dart';
import '../../../../common/spaces_boxes.dart';
import 'package:flutter/src/widgets/image.dart' as core;

mixin PropertyListingWidgets {
  Widget propertiesWidget(PropertyModel result) {
    String firstImage = result.thumbnail == null
        ? ApiConstants.imageNetworkPlaceHolder
        : "${ApiConstants.baseUrl}${result.thumbnail ?? ''}";

    return InkWell(
      onTap: () {
        Get.toNamed(PropertyDetailsPage.id, arguments: result);
      },
      child: Card(
        child: SizedBox(
          height: 260.h,
          child: Row(
            children: [
              ///images
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    NetworkPlainImage(
                      url: firstImage,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: AppColor.alphaGrey,
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${result.image.length}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.image,
                            size: 12,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              hSpace,

              ///features and information
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppUtils.readTimestamp(
                                  DateTime.parse(result.createdAt!)
                                      .millisecondsSinceEpoch),
                              style: AppTextStyles.textStyleBoldBodyXSmall,
                            ),
                          ),
                          Row(
                            children: [
                              Text("Verified",
                                  style:
                                      AppTextStyles.textStyleNormalBodyXSmall),
                              hSpace,
                              const Icon(
                                Icons.verified_outlined,
                                size: 10,
                                color: AppColor.green,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    vSpace,
                    Flexible(
                      child: Text(
                        ("${result.currency ?? ''} ${result.price ?? ''}"),
                        style: AppTextStyles.textStyleBoldBodyMedium,
                      ),
                    ),
                    Text(
                      result.loca ?? '',
                      style: AppTextStyles.textStyleBoldBodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Flexible(
                      child: Text(
                        result.purpose ?? '',
                        style: AppTextStyles.textStyleNormalBodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bed, size: 12),
                              Text("${result.beds ?? 0}"),
                            ],
                          ),
                          SizedBox(width: 10.h),
                          Row(
                            children: [
                              const Icon(Icons.bathtub, size: 12),
                              Text("${result.bathrooms ?? 0}"),
                            ],
                          ),
                          SizedBox(width: 10.h),
                          Flexible(
                            child: Row(
                              children: [
                                const Icon(Icons.area_chart, size: 12),
                                Flexible(
                                    child: Text(
                                        "${result.space ?? '0'} ${result.unit ?? ''}",
                                        overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.h),
                          const Icon(Icons.favorite_border),
                        ],
                      ),
                    ),
                    vSpace,
                    Expanded(
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Call')),
                          hSpace,
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                'Message',
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTextField(
      {required String hintText,
      required TextEditingController controller,
      String? validateText,
      bool validate = true,
      bool enabled = true,
      int minLines = 1,
      double? leftPadding,
      double? rightPadding,
      int maxLines = 2,
      onChanged,
      List<TextInputFormatter> inputFormatters = const [],
      TextInputType inputType = TextInputType.text,
      validator}) {
    return MyTextField(
        controller: controller,
        enable: enabled,
        hintText: hintText,
        minLines: minLines,
        maxLines: maxLines,
        contentPadding: 8,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        focusBorderColor: AppColor.alphaGrey,
        textColor: AppColor.blackColor,
        hintColor: AppColor.blackColor,
        fillColor: AppColor.alphaGrey,
        onChanged: onChanged,
        validator: validator ??
            (String? value) => validate
                ? (value!.trim().isEmpty ? validateText ?? "Required" : null)
                : null);
  }

  Widget getImageWidgetPlain(Rx<File?> file, {String? networkImage = ''}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        (file.value != null)
            ? core.Image.file(file.value!, fit: BoxFit.fill)
            : (networkImage != ''
                ? NetworkPlainImage(url: "${ApiConstants.baseUrl}$networkImage")
                : core.Image.asset(
                    'assets/images/place_your_image.png',
                    fit: BoxFit.fill,
                  )),
        Positioned(
          bottom: 5,
          right: 15,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white,
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
}
