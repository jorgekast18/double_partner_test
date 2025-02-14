import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuthDatasource _authDatasource;

  AuthRepositoryImpl(this._authDatasource);

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final userData = await _authDatasource.signIn(email, password);
      final user = UserModel.fromMap(userData).toDomain();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> register(User user, String password) async {
    try {
      final userData = await _authDatasource.register(
        UserModel.fromDomain(user).toMap(),
        password,
      );
      final registeredUser = UserModel.fromMap(userData).toDomain();
      return Right(registeredUser);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authDatasource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _authDatasource.authStateChanges.map((userData) {
      if (userData == null) return null;
      return UserModel.fromMap(userData).toDomain();
    });
  }
}