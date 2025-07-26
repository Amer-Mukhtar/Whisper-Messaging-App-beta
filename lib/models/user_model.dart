class UserModel {
  final String fullName;
  final String email;
  String? imageUrl;

  UserModel({
    required this.fullName,
    required this.email,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
