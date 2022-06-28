import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/tutorial_response_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

class VideoPlayerScoringController extends GetxController {
  RxBool isLoading = false.obs;
  int scores = 0;
  RxBool isAnswerSubmitted = false.obs;
  late VideoPlayerController videoController;

  RxList<RxString> selectedAnswerList = <RxString>[].obs;

  void initializeVideo(TutorialResponseModel model) {
    videoController = VideoPlayerController.network((model.courseVideo ?? '')
            .isNotEmpty
        ? "${ApiConstants.baseUrl}${model.courseVideo}"
        : 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
  }

  void calculateScores(TutorialResponseModel model) {
    for (var i = 0; i < (model.questions?.length ?? 0); i++) {
      if (selectedAnswerList[i].value ==
          (model.questions![i].correctAnswer ?? '')) {
        scores++;
      }
    }
  }

  void resetQuiz() {
    selectedAnswerList.clear();
    scores = (0);
    isAnswerSubmitted.value = false;
  }
}
