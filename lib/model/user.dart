class ApplicationUser {
  final String? id;
  final String? fullName;
  final String? email;
  final String? profilePicture;
  final String? phoneNumber;
  final bool isAdmin;

  ApplicationUser({
    this.id,
    this.fullName,
    this.email,
    this.profilePicture,
    this.phoneNumber,
    this.isAdmin = false,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    return ApplicationUser(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      phoneNumber: json['phoneNumber'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profilePicture': profilePicture,
      'PhoneNumber': phoneNumber,
      'isAdmin': isAdmin,
    };
  }
}