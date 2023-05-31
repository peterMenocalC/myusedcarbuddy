class ForgotPasswordResponse {
  int timestamp;
  bool success;
  String msg;


  ForgotPasswordResponse({
    this.timestamp,
    this.success,
    this.msg,

  });

  ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    success = json['success'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['success'] = this.success;
    data['msg'] = this.msg;
    return data;
  }
}