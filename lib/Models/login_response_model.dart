class LoginResponseModel {
  String userId;
  String roleId;
  String userName;
  String empCode;
  String empEmail;
  String profileImage;

  LoginResponseModel({
    required this.userId,
    required this.roleId,
    required this.userName,
    required this.empCode,
    required this.empEmail,
    required this.profileImage,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      userId: json['userId'] ?? '',
      roleId: json['roleId'] ?? '',
      userName: json['userName'] ?? '',
      empCode: json['empCode'] ?? '',
      empEmail: json['empEmail'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
