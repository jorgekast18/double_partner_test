import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';
import '../entities/user.dart';

class RegisterUser implements UseCase<User, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    return await repository.register(params.user, params.password);
  }
}

class RegisterUserParams extends Equatable {
  final User user;
  final String password;

  const RegisterUserParams({
    required this.user,
    required this.password,
  });

  @override
  List<Object> get props => [user, password];
}