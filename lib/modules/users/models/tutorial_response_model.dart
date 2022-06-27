import 'package:zeerac_flutter/dio_networking/decodable.dart';

class TutorialResponseModel implements Decodeable {
  int? id;
  String? courseVideo;
  String? courseTitle;
  String? courseDescription;
  List<Questions>? questions;

  TutorialResponseModel(
      {this.id,
      this.courseVideo,
      this.courseTitle,
      this.courseDescription,
      this.questions});

  TutorialResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseVideo = json['course_video'];
    courseTitle = json['course_title'];
    courseDescription = json['course_description'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_video'] = this.courseVideo;
    data['course_title'] = this.courseTitle;
    data['course_description'] = this.courseDescription;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  decode(json) {
    id = json['id'];
    courseVideo = json['course_video'];
    courseTitle = json['course_title'];
    courseDescription = json['course_description'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    return this;
  }
}

class Questions {
  int? id;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? correctAnswer;
  String? createdAt;
  String? updatedAt;
  int? videoFk;

  Questions(
      {this.id,
      this.question,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.correctAnswer,
      this.createdAt,
      this.updatedAt,
      this.videoFk});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    option1 = json['option_1'];
    option2 = json['option_2'];
    option3 = json['option_3'];
    option4 = json['option_4'];
    correctAnswer = json['correct_answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    videoFk = json['video_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['option_1'] = this.option1;
    data['option_2'] = this.option2;
    data['option_3'] = this.option3;
    data['option_4'] = this.option4;
    data['correct_answer'] = this.correctAnswer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['video_fk'] = this.videoFk;
    return data;
  }
}
