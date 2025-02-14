import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String lastName;
  final DateTime birthDate;
  final String email;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, lastName, birthDate, email, password];
}

class SignOutRequested extends AuthEvent {}