import '../../../domain/entities/auth/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.mobile,
    super.email,
    super.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
    };
  }
}
