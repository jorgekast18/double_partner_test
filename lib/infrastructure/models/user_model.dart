import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.lastName,
    required super.birthDate,
    required super.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
      birthDate: DateTime.parse(map['birthDate'] as String),
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'email': email,
    };
  }

  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      lastName: user.lastName,
      birthDate: user.birthDate,
      email: user.email,
    );
  }

  User toDomain() {
    return User(
      id: id,
      name: name,
      lastName: lastName,
      birthDate: birthDate,
      email: email,
    );
  }
}