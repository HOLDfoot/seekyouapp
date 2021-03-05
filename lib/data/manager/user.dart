class User {
    /// 从页面请求中缓存的用户信息
    bool likeTheUser = false;
    String userIntent;

    int userAge;
    String userDesc;
    String userEmail;
    String userGender;

    /// 用户的爱好, 用以区分同类和异类可以通过StringUtils转成List<String>
    String userHobbies;

    String userId;
    String userName;
    String userPassword;
    String userPhoto;
    String userQq;
    String userToken;
    String userWx;

    String userArea;

    User({this.userAge, this.userDesc, this.userEmail, this.userGender, this.userHobbies, this.userId, this.userName, this.userPassword, this.userPhoto, this.userQq, this.userToken, this.userWx, this.userArea});

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            userAge: json['userAge'], 
            userDesc: json['userDesc'], 
            userEmail: json['userEmail'], 
            userGender: json['userGender'], 
            userHobbies: json['userHobbies'], 
            userId: json['userId'], 
            userName: json['userName'], 
            userPassword: json['userPassword'], 
            userPhoto: json['userPhoto'], 
            userQq: json['userQq'], 
            userToken: json['userToken'], 
            userWx: json['userWx'], 
            userArea: json['userArea'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['userAge'] = this.userAge;
        data['userDesc'] = this.userDesc;
        data['userEmail'] = this.userEmail;
        data['userGender'] = this.userGender;
        data['userHobbies'] = this.userHobbies;
        data['userId'] = this.userId;
        data['userName'] = this.userName;
        data['userPassword'] = this.userPassword;
        data['userPhoto'] = this.userPhoto;
        data['userQq'] = this.userQq;
        data['userToken'] = this.userToken;
        data['userWx'] = this.userWx;
        data['userArea'] = this.userArea;
        return data;
    }
}