import 'dart:convert';

class PostInspectionOptionsData {
  int user_id;
  int category_id;
  int order_id;
  int sub_category_id;
  List<QuestionAnswer> answers;

  PostInspectionOptionsData({
    this.user_id,
    this.category_id,
    this.order_id,
    this.sub_category_id,
    this.answers
  });

  PostInspectionOptionsData.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    category_id = json['category_id'];
    order_id = json['order_id'];
    sub_category_id = json['sub_category_id'];
    answers = json["answers"].map<QuestionAnswer>((json) => QuestionAnswer.fromJson(json, -1)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['category_id'] = this.category_id;
    data['order_id'] = this.order_id;
    data['sub_category_id'] = this.sub_category_id;
    data['answers'] = this.answers;
    return data;
  }
}

class QuestionAnswer {
  int question_id;
  String answer;
  String optional_message;
  bool isComplete;
  QuestionAnswer({
    this.question_id,
    this.answer,
    this.optional_message,
    this.isComplete
  });

  QuestionAnswer.fromJson(Map<String, dynamic> json, int parentid) {
    question_id = json['question_id'];
    answer = json['answer'];
    optional_message = json['optional_message'];
    isComplete = json[''];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.question_id;
    data['answer'] = this.answer;
    data['optional_message'] = this.optional_message;
    data['']= this.isComplete;
    return data;
  }
}

class InspectionPostResponse {
  bool success;
  String msg;
  String timestamp;

  InspectionPostResponse.fromJson(Map<String, dynamic> json) {
    success= json['success'];
    msg= json['msg'];
    timestamp= json['timestamp'];
  }
}


