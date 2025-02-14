import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> register(User user, String password);
  Future<Either<Failure, void>> signOut();
  Stream<User?> get authStateChanges;
}