import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/tutorial_response_model.dart';

class VideoPlayerScoringController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt scores = (-1).obs;
  late VideoPlayerController videoController;

  RxList<Rx<Map<String, String>>> selectedAnswerList =
      <Rx<Map<String, String>>>[].obs;

  void initializeVideo(TutorialResponseModel model) {
    videoController = VideoPlayerController.network((model.courseVideo ?? '')
            .isNotEmpty
        ? "${ApiConstants.baseUrl}${model.courseVideo}"
        : 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
  }

  void calculateScores() {
    for (var element in selectedAnswerList) {}
  }
}
