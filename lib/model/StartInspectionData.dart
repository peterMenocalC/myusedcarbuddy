

class StartInspectionData {
  String timestamp;
  bool success;
  String msg;
  List<Category> categories;

  StartInspectionData({
    this.timestamp,
    this.success,
    this.msg,
    this.categories
  });

  StartInspectionData.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    success = json['success'];
    msg = json['msg'];
    categories = json["categories"].map<Category>((json) => Category.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['categories'] = this.categories;
    return data;
  }
}

class Category {
  int id;
  String title;
  int sort_order;
  List<SubCategory> sub_categories;
  Category({
    this.id,
    this.title,
    this.sort_order,
    this.sub_categories
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sort_order = json['sort_order'];
    sub_categories = json['sub_categories'].map<SubCategory>((json) => SubCategory.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sort_order'] = this.sort_order;
    data['sub_categories'] = this.sub_categories;
    return data;
  }
}

class SubCategory {
  int id;
  String title;
  int sort_order;
  int total_qn;
  int total_qn_answered;
  int is_all_answered;
  SubCategory({
    this.id,
    this.title,
    this.sort_order,
    this.total_qn,
    this.total_qn_answered,
    this.is_all_answered
  });

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sort_order = json['sort_order'];
    total_qn = json['total_qn'];
    total_qn_answered = json['total_qn_answered'];
    is_all_answered = json['is_all_answered'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sort_order'] = this.sort_order;
    data['total_qn'] = this.total_qn;
    data['total_qn_answered'] = this.total_qn_answered;
    data['is_all_answered'] = this.is_all_answered;
    return data;
  }
}



