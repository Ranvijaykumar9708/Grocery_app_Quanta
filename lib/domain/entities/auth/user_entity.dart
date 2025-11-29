import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? name;
  final String? mobile;
  final String? email;
  final String? address;

  const UserEntity({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.address,
  });

  @override
  List<Object?> get props => [id, name, mobile, email, address];
}

