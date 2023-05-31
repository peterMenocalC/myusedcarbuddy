
import 'package:flutter/cupertino.dart';

class DamageEntry {
  String timestamp;
  bool success;
  String msg;
  List<DamageItem> damages = List();
  String value;
  String sizeValue;
  int typeIndex;
  int sizeIndex;
  String typeId;
  String sizeId;

  DamageEntry({
    this.timestamp,
    this.success,
    this.msg,
    this.damages,
    this.value,
    this.sizeValue,
    this.typeIndex,
    this.sizeIndex,
    this.typeId,
    this.sizeId
  });

  DamageEntry.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    success = json['success'];
    msg = json['msg'];
    damages = json["damages"].map<DamageItem>((json) => DamageItem.fromJson(json)).toList();
    value =json[''];
    sizeValue = json[''];
    typeIndex =json[''];
    sizeIndex = json[''];
    typeId =json[''];
    sizeId = json[''];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['damages'] = this.damages;
    data['']=this.value;
    data[''] = this.sizeValue;
    data['']=this.typeIndex;
    data[''] = this.sizeIndex;
    data['']=this.typeId;
    data[''] = this.sizeId;
    return data;
  }
}


class DamageItem {
  int id;
  String title;
  List<Size> size = List();
  DamageItem({
    this.id,
    this.size,
  });

  DamageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    size = json['size'].map<Size>((json) => Size.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['size'] = this.size;
    return data;
  }
}

class Size {
  int id;
  String title;
  Size({
    this.id,
    this.title
  });

  Size.fromJson(Map<String, dynamic> json) {
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




