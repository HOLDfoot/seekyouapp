class User {
  int age;
  String email;
  int id;
  String name;
  String password;

  String userId;
  String userToken;

  String userAge; // age
  String userName; // name
  String userGender;
  String userDesc;
  String userPhoto;

  /// 用户的爱好, 用以区分同类和异类
  List<String> userHobbies;

  /// 用户的微信, 当互相关注后可以看到对方的微信和邮箱
  String userWx;
  String userQq;


  User(
      {this.age,
      this.email,
      this.id,
      this.name,
      this.password,
      this.userId,
      this.userToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      age: json['age'],
      email: json['email'],
      id: json['id'],
      name: json['name'],
      password: json['password'],
      userId: json['userId'],
      userToken: json['userToken'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['password'] = this.password;
    data['userId'] = this.userId;
    data['userToken'] = this.userToken;
    return data;
  }
}
