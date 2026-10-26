

class UserModel {
  final int? id;
  final String userName;
  final String userLocation;

  UserModel({
    this.id,
    required this.userName,
    required this.userLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'userLocation': userLocation,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      userName: map['userName'],
      userLocation: map['userLocation'],
    );
  }
}