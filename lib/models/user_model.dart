class UserModel {
  final String fullName;
  final String email;
  final String docId;

  UserModel({
    required this.fullName,
    required this.email,
    required this.docId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      docId: json['docId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'docId': docId,
    };
  }
}
