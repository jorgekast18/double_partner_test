import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final DateTime birthDate;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.birthDate,
    required this.email,
  });

  @override
  List<Object> get props => [id, name, lastName, birthDate, email];
}