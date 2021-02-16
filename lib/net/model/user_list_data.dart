import 'package:seekyouapp/data/manager/user.dart';

/// code : 0
/// msg : "SUCCESS"
/// data : [{"userId":"1","userPhoto":null,"userName":"lisi","userEmail":null,"userWx":null,"userQq":null,"userAge":300,"userGender":null,"userDesc":null,"userHobbies":null}]

class UserListData {

  List<User> modelList;

  UserListData({
      List<User> data}){
    modelList = data;
}

  UserListData.fromJson(dynamic json) {
    if (json["modelList"] != null) {
      modelList = [];
      json["modelList"].forEach((v) {
        modelList.add(User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (modelList != null) {
      map["modelList"] = modelList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}