import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/tutorials_controller.dart';
import 'package:zeerac_flutter/modules/users/models/tutorial_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/tutorials/tutorials_widget.dart';
import 'package:zeerac_flutter/utils/app_alert_bottom_sheet.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';
import '../../controllers/video_player_controller.dart';

class VideoPlayerScoringPage extends GetView<VideoPlayerScoringController>
    with TutorialWidgetsMixin {
  VideoPlayerScoringPage({Key? key}) : super(key: key);
  static const id = '/VideoPlayerScoringPage';

  TutorialResponseModel? model = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: 'Tutorial'),
      body: GetX<VideoPlayerScoringController>(
        initState: (state) {
          if (model != null) {
            controller.initializeVideo(model!);
          }
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                if (model != null)
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ///video player
                        SizedBox(
                          height: 350.h,
                          child: FutureBuilder(
                            future: controller.videoController.initialize(),
                            builder: (context, snapShot) {
                              if (snapShot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return Chewie(
                                controller: ChewieController(
                                  videoPlayerController:
                                      controller.videoController,
                                  autoPlay: false,
                                  looping: false,
                                ),
                              );
                            },
                          ),
                        ),

                        vSpace,

                        /* Button(
                          leftPadding: 50.w,
                          rightPading: 50.w,
                          buttonText: 'Go for test',
                          textColor: AppColor.whiteColor,
                          onTap: () {
                            showBottom(context, model!);
                          },
                        )*/

                        ///Questions

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Answer following questions based on video',
                            style: AppTextStyles.textStyleBoldTitleLarge,
                          ),
                        ),
                        vSpace,

                        !controller.isAnswerSubmitted.value
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: model!.questions?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        ///correct answer: selected answer
                                        controller.selectedAnswerList
                                            .add(''.obs);
                                        return getQuestionQuizWidget(
                                            model!.questions![index],
                                            controller
                                                .selectedAnswerList[index]);
                                      }),
                                  vSpace,
                                  Button(
                                    buttonText: 'Submit',
                                    leftPadding: 50.w,
                                    rightPading: 50.w,
                                    textColor: AppColor.whiteColor,
                                    onTap: () {
                                      if (model != null) {
                                        controller.isAnswerSubmitted.value =
                                            true;
                                        controller.calculateScores(model!);
                                      }
                                    },
                                  ),
                                  vSpace,
                                ],
                              )
                            : Column(
                                /// answers building
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Your scores are = ${controller.scores} / ${model?.questions?.length ?? 0}'),
                                  vSpace,
                                  Button(
                                    buttonText: 'Reset',
                                    leftPadding: 50.w,
                                    rightPading: 50.w,
                                    textColor: AppColor.whiteColor,
                                    onTap: () {
                                      controller.resetQuiz();
                                    },
                                  ),
                                ],
                              ),

                        vSpace,
                      ],
                    ),
                  ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  void showBottom(BuildContext context, TutorialResponseModel model) {
    AppBottomSheets.showAppAlertBottomSheet(
        context: context,
        isFull: true,
        title: "Questions",
        isDismissable: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              vSpace,
              Button(
                buttonText: 'Submit',
                textColor: AppColor.whiteColor,
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ));
  }
}
