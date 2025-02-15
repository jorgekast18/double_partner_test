import 'package:dartz/dartz.dart';
import 'package:double_partner_test/core/errors/failures.dart';
import 'package:double_partner_test/core/usecases/usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class GetCurrentUser implements NoParamsUseCase<firebase_auth.User> {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  GetCurrentUser(this._firebaseAuth);

  @override
  Future<Either<Failure, firebase_auth.User>> call() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Left(AuthFailure('El usuario no está logueado.'));
      } else {
        return Right(user);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
