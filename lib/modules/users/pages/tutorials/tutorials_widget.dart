import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/tutorial_response_model.dart';

import '../../../../utils/helpers.dart';

mixin TutorialWidgetsMixin {
  Future<Widget> tutorialListingMainWidget(TutorialResponseModel model) async {
    Future<String?> file = VideoThumbnail.thumbnailFile(
      video: model.courseVideo != null
          ? "${ApiConstants.baseUrl}${model.courseVideo}"
          : "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: file,
                  builder: (context, AsyncSnapshot<String?> snapShot) {
                    if ((snapShot.data ?? '').isNotEmpty) {
                      return Image.file(
                        File(snapShot.data!),
                        fit: BoxFit.fill,
                        height: 150.h,
                        width: double.infinity,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
              vSpace,
              Text(model.courseTitle ?? '-',
                  style: AppTextStyles.textStyleBoldBodyMedium),
              Text(model.courseDescription ?? '-',
                  style: AppTextStyles.textStyleNormalBodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget getQuestionQuizWidget(Questions question, RxString selectedAnswer) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.h),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.question ?? '',
                style: AppTextStyles.textStyleBoldBodySmall,
              ),
              RadioListTile(
                  value: question.option1 ?? '',
                  title: Text(question.option1 ?? ''),
                  groupValue: selectedAnswer.value,
                  onChanged: (String? value) {
                    selectedAnswer.value = value ?? '';
                  }),
              RadioListTile(
                  value: question.option2 ?? '',
                  title: Text(question.option2 ?? ''),
                  groupValue: selectedAnswer.value,
                  onChanged: (String? value) {
                    selectedAnswer.value = value ?? '';
                  }),
              RadioListTile(
                  value: question.option3 ?? '',
                  title: Text(question.option3 ?? ''),
                  groupValue: selectedAnswer.value,
                  onChanged: (String? value) {
                    selectedAnswer.value = value ?? '';
                  }),
              RadioListTile(
                  value: question.option4 ?? '',
                  title: Text(question.option4 ?? ''),
                  groupValue: selectedAnswer.value,
                  onChanged: (String? value) {
                    selectedAnswer.value = value ?? '';
                  }),
              vSpace,
            ],
          );
        }),
      ),
    );
  }
}
