class UserPreferenceModel {
  bool _likeTheUser;
  String _userIntent;

  bool get likeTheUser => _likeTheUser;
  String get userIntent => _userIntent;

  UserPreferenceModel({
      bool likeTheUser, 
      String userIntent}){
    _likeTheUser = likeTheUser;
    _userIntent = userIntent;
}

  UserPreferenceModel.fromJson(dynamic json) {
    _likeTheUser = json["likeTheUser"];
    _userIntent = json["userIntent"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["likeTheUser"] = _likeTheUser;
    map["userIntent"] = _userIntent;
    return map;
  }

}