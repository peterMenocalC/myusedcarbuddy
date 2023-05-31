class InspectionOptionsData {
  String timestamp;
  bool success;
  String msg;
  String defaultImage;
  List<Question> questions;

  InspectionOptionsData({
    this.timestamp,
    this.success,
    this.msg,
    this.defaultImage,
    this.questions
  });

  InspectionOptionsData.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    success = json['success'];
    msg = json['msg'];
    defaultImage = json['default_required_img'];
    questions = json["questions"].map<Question>((json) => Question.fromJson(json, -1)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['default_required_img'] = this.defaultImage;
    data['questions'] = this.questions;
    return data;
  }
}

class Question {
  int id;
  int parentId;
  int parentId2;
  String title;
  String option_type;
  int message_option;
  int photo_option;
  int is_damage_option;
  String input_var;
  int sort_order;
  List<Option> options;
  List<Images> saved_optional_images;
  List<Damage> saved_damaged_options;
  String saved_message_option;
  String value;
  List<Question>associated_questions;
  List<int>associated_tire_qns;
  bool is_optional;
  Question({
    this.id,
    this.title,
    this.sort_order,
    this.input_var,
    this.option_type,
    this.message_option,
    this.photo_option,
    this.is_damage_option,
    this.options,
    this.value,
    this.saved_optional_images,
    this.saved_damaged_options,
    this.saved_message_option,
    this.associated_questions,
    this.associated_tire_qns,
    this.is_optional
  });

  Question.fromJson(Map<String, dynamic> json, int parentid) {
    id = json['id'];
    parentId = parentid;
    title = json['title'];
    sort_order = json['sort_order'];
    input_var = json['input_var'];
    option_type = json['option_type'];
    message_option = json['message_option'];
    photo_option = json['photo_option'];
    is_damage_option = json['is_damage_option'];
    value = json['value'];
    options = json['options'].map<Option>((json) => Option.fromJson(json, id))
        .toList();
    saved_optional_images = json['saved_optional_images'] !=null ?
      json['saved_optional_images'].map<Images>((json) => Images.fromJson(json)).toList() : List();
    saved_damaged_options = json['saved_damaged_options'] !=null ?
    json['saved_damaged_options'].map<Damage>((json) => Damage.fromJson(json)).toList() : List();
    saved_message_option = json['saved_message_option'];
    associated_questions = json['associated_questions'] != null
        ? json['associated_questions']
            .map<Question>((json) => Question.fromJson(json, parentId))
            .toList()
        : List();
    associated_tire_qns = json['associated_tire_qns'] != null
        ?  List.from(json['associated_tire_qns']) : List();
    is_optional = json['is_optional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sort_order'] = this.sort_order;
    data['input_var'] = this.input_var;
    data['option_type'] = this.option_type;
    data['message_option'] = this.message_option;
    data['photo_option'] = this.photo_option;
    data['is_damage_option'] = this.is_damage_option;
    data['options'] = this.options;
    data['parentId'] = this.parentId;
    data['value'] = value;
    data['saved_optional_images'] = saved_optional_images;
    data['saved_damaged_options'] = saved_damaged_options;
    data['saved_message_option'] = saved_message_option;
    data['associated_questions'] = associated_questions;
    data['associated_tire_qns'] = associated_tire_qns;
    data['is_optional'] = is_optional;
    return data;
  }
}

class Option {
  int id;
  String title;
  List<Question> associated_questions;
  Option({
    this.id,
    this.title,
    this.associated_questions
  });

  Option.fromJson(Map<String, dynamic> json, int parentId ) {
    id = json['id'];
    title = json['title'];
    associated_questions = json['associated_questions'].map<Question>((json) => Question.fromJson(json, parentId)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sort_order'] = this.associated_questions;
    return data;
  }
}
class Damage {
  int id;
  List<DamageType> type;
  List<DamageType>size;
  String notes;
  List<Images>images;
  Damage({
    this.id,
    this.type,
    this.size,
    this.notes,
    this.images
  });

  Damage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'].map<DamageType>((json) =>DamageType.fromJson(json)).toList();
    size = json['size'].map<DamageType>((json) =>DamageType.fromJson(json)).toList();
    notes = json['notes'];
    images = json['images'].map<Images>((json) =>Images.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['size'] = this.size;
    data['notes'] = this.notes;
    data['images'] = this.images;

    return data;
  }
}

class DamageType {
  int id;
  String title;
  DamageType({
    this.id,
    this.title
  });

  DamageType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}


class Images {
  int id;
  String image;
  Images({
    this.id,
    this.image
  });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}



