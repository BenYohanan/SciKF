class RegisterModel {
  final String? fullName;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? id;

  RegisterModel({
    required this.fullName,
    required this.email,
    this.password,
    required this.phoneNumber,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'id': id,
    };
  }
}

class LoginModel {
  final String userName;
  final String password;

  LoginModel({
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}

class UpdateUserModel {
  final String email;
  final String? profilePicture;

  UpdateUserModel({
    required this.email,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}