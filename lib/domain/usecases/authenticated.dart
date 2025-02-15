import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

class IsAuth implements NoParamsUseCase<bool> {
  final FirebaseAuth _firebaseAuth;

  IsAuth(this._firebaseAuth);

  @override
  Future<Either<Failure, bool>> call() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return const Left(ServerFailure('Error al verificar el estado de autenticación.'));
    }
  }
}
